import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart' show Locale;
import 'package:shared_preferences/shared_preferences.dart';

import '../api/tune_client.dart';
import '../api/models.dart';
import '../services/server_discovery.dart';

class AppState extends ChangeNotifier {
  static const _kHostLegacy = 'host'; // pre host/port split
  static const _kHost = 'server_host';
  static const _kPort = 'server_port';
  // Nom lisible du dernier serveur choisi dans la liste du reseau. Purement
  // cosmetique : c'est host/port qui font la connexion.
  static const _kServerName = 'server_name';
  static const _kZone = 'zone_id';
  // Acces distant par le relais Tune Bridge. Les deux vont ensemble : un
  // identifiant sans jeton ne donnerait que des 401.
  static const _kBridgeId = 'bridge_server_id';
  static const _kBridgeToken = 'bridge_token';
  static const _kLocale = 'locale';
  static const defaultPort = 8888;

  String _host = '';
  int _port = defaultPort;
  String _serverName = '';
  bool _ready = false;
  TuneClient? _client;
  bool _connected = false;
  bool _loading = false;
  String? _error;

  List<Zone> _zones = [];
  List<Device> _devices = [];
  Map<String, StreamingServiceInfo> _services = {};
  int? _currentZoneId;
  Timer? _poll;

  /// Favorite keys: `<source>|<type>|<id>` (type ∈ tracks/albums/artists/playlists).
  final Set<String> _favs = {};

  StreamConfig? _streamCfg;
  StreamConfig? get streamConfig => _streamCfg;

  /// UI language; null = follow the system locale.
  Locale? _locale;
  Locale? get locale => _locale;

  String get serverHost => _host;
  int get serverPort => _port;

  /// Nom lisible du serveur memorise, quand il vient de la decouverte reseau.
  /// Vide pour une adresse saisie a la main.
  String get serverName => _serverName;

  /// Vrai une fois [init] termine. Avant cela on ne sait PAS encore s'il y a
  /// un serveur memorise : afficher l'ecran de decouverte tout de suite le
  /// ferait clignoter a chaque lancement.
  bool get ready => _ready;

  /// Vrai quand l'application a de quoi joindre un serveur — adresse locale
  /// memorisee ou appairage au relais.
  bool get hasServer => _host.isNotEmpty || viaBridge;


  /// Combined "host:port" used by the REST client and the auth signatures.
  String get host => _host.isEmpty ? '' : '$_host:$_port';

  TuneClient? get client => _client;
  bool get connected => _connected;
  bool get loading => _loading;
  String? get error => _error;
  List<Zone> get zones => _zones;

  /// Server origin (host without the /api/v1 suffix), for resolving relative
  /// artwork URLs.
  String? get serverBase {
    final c = _client;
    if (c == null) return null;
    final b = c.baseUrl;
    if (b.isEmpty) return null;
    return b.endsWith('/api/v1') ? b.substring(0, b.length - 7) : b;
  }

  List<Device> get devices => _devices;
  Map<String, StreamingServiceInfo> get services => _services;
  int? get currentZoneId => _currentZoneId;

  Zone? get currentZone {
    for (final z in _zones) {
      if (z.id == _currentZoneId) return z;
    }
    return _zones.isNotEmpty ? _zones.first : null;
  }

  /// The renderers/outputs offered in Settings: discovered devices that can
  /// render audio (DLNA renderers + local outputs).
  List<Device> get outputs => _devices.where((d) => d.isRenderer).toList();

  String _bridgeServerId = '';
  String _bridgeToken = '';

  /// Vrai quand l'application passe par le relais au lieu du reseau local.
  bool get viaBridge => _bridgeServerId.isNotEmpty && _bridgeToken.isNotEmpty;
  String get bridgeServerId => _bridgeServerId;

  /// Le jeton n'est PAS expose : l'ecran de reglages n'a besoin que de savoir
  /// s'il existe, jamais de le reafficher.
  bool get hasBridgeToken => _bridgeToken.isNotEmpty;

  /// Construit le client selon le mode courant. Un seul endroit decide, pour
  /// qu'un appelant ne puisse pas oublier le jeton.
  TuneClient? _construireClient() {
    if (viaBridge) {
      return TuneClient(host,
          bridgeServerId: _bridgeServerId, bridgeToken: _bridgeToken);
    }
    return _host.isEmpty ? null : TuneClient(host);
  }

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final lc = prefs.getString(_kLocale);
    _locale = (lc != null && lc.isNotEmpty) ? Locale(lc) : null;
    _host = prefs.getString(_kHost) ?? '';
    _port = prefs.getInt(_kPort) ?? defaultPort;
    _serverName = prefs.getString(_kServerName) ?? '';
    // Migrate the old combined "host:port" pref if present.
    if (_host.isEmpty) {
      final legacy = prefs.getString(_kHostLegacy);
      if (legacy != null && legacy.isNotEmpty) {
        final p = _parse(legacy);
        _host = p.$1;
        _port = p.$2;
      }
    }
    _currentZoneId = prefs.getInt(_kZone);
    _bridgeServerId = prefs.getString(_kBridgeId) ?? '';
    _bridgeToken = prefs.getString(_kBridgeToken) ?? '';
    // En mode distant, l'hote local peut etre vide : le relais suffit.
    if (_host.isNotEmpty || viaBridge) {
      _client = _construireClient();
      await refresh();
    }
    _ready = true;
    notifyListeners();
  }

  /// Splits user input into (host, port). Strips any scheme; an embedded
  /// `:port` overrides; defaults to [defaultPort].
  (String, int) _parse(String input, [int? fallbackPort]) {
    var s = input.trim().replaceAll(RegExp(r'^https?://'), '');
    s = s.replaceAll(RegExp(r'/.*$'), ''); // drop any path
    var port = fallbackPort ?? defaultPort;
    final colon = s.lastIndexOf(':');
    if (colon >= 0) {
      final maybe = int.tryParse(s.substring(colon + 1));
      if (maybe != null) {
        port = maybe;
        s = s.substring(0, colon);
      }
    }
    return (s, port);
  }

  /// Set the UI language ([code] like 'fr'; null = system).
  Future<void> setLocale(String? code) async {
    _locale = (code != null && code.isNotEmpty) ? Locale(code) : null;
    final prefs = await SharedPreferences.getInstance();
    if (code == null || code.isEmpty) {
      await prefs.remove(_kLocale);
    } else {
      await prefs.setString(_kLocale, code);
    }
    notifyListeners();
  }

  Future<void> setServer(String host, String port) async {
    final parsed = _parse(host, int.tryParse(port.trim()));
    _host = parsed.$1;
    _port = parsed.$2;
    // Une adresse tapee a la main n'a pas de nom lisible : on efface celui du
    // serveur decouvert precedent plutot que de laisser un nom qui ment.
    _serverName = '';
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kHost, _host);
    await prefs.setInt(_kPort, _port);
    await prefs.remove(_kServerName);
    _client?.close();
    _client = _construireClient();
    await refresh();
  }

  /// Memorise et rejoint un serveur trouve sur le reseau.
  ///
  /// C'est le meme chemin que [setServer] — host, port, preferences, client —
  /// avec en plus le nom lisible, pour que l'ecran de reglages puisse dire
  /// « Salon » plutot que « 192.168.1.41 ». Le prochain lancement se
  /// reconnecte seul a ce serveur, sans nouvelle recherche.
  Future<void> connectToDiscovered(DiscoveredServer server) async {
    _host = server.host;
    _port = server.port;
    _serverName = server.name;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kHost, _host);
    await prefs.setInt(_kPort, _port);
    await prefs.setString(_kServerName, _serverName);
    _client?.close();
    _client = _construireClient();
    await refresh();
  }

  /// Oublie le serveur memorise et revient a l'ecran de decouverte.
  Future<void> forgetServer() async {
    _host = '';
    _serverName = '';
    _port = defaultPort;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kHost);
    await prefs.remove(_kPort);
    await prefs.remove(_kServerName);
    await prefs.remove(_kHostLegacy);
    _poll?.cancel();
    _client?.close();
    _client = null;
    _connected = false;
    _zones = [];
    _devices = [];
    notifyListeners();
  }

  /// Enregistre — ou efface — l'appairage au relais.
  ///
  /// Les deux valeurs viennent de `POST /api/v1/cloud/bridge/enable`, appele
  /// une fois depuis le reseau local. Passer une chaine vide aux deux revient
  /// a repasser en direct.
  ///
  /// L'hote local est CONSERVE : c'est lui qu'on retrouve en rentrant chez
  /// soi, et le relais est un detour, pas un remplacement.
  Future<void> setBridge(String serverId, String token) async {
    _bridgeServerId = serverId.trim();
    _bridgeToken = token.trim();
    final prefs = await SharedPreferences.getInstance();
    if (_bridgeServerId.isEmpty || _bridgeToken.isEmpty) {
      // Un seul des deux ne sert a rien : on efface la paire entiere plutot
      // que de laisser un etat qui ne produirait que des 401.
      _bridgeServerId = '';
      _bridgeToken = '';
      await prefs.remove(_kBridgeId);
      await prefs.remove(_kBridgeToken);
    } else {
      await prefs.setString(_kBridgeId, _bridgeServerId);
      await prefs.setString(_kBridgeToken, _bridgeToken);
    }
    _client?.close();
    _client = _construireClient();
    await refresh();
  }

  Future<void> refresh() async {
    final c = _client;
    if (c == null) {
      _connected = false;
      notifyListeners();
      return;
    }
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      _connected = await c.ping();
      if (_connected) {
        final results = await Future.wait([
          c.zones(),
          c.devices(),
          c.streamingServices(),
        ]);
        _zones = results[0] as List<Zone>;
        _devices = results[1] as List<Device>;
        _services = results[2] as Map<String, StreamingServiceInfo>
          // Hidden: OAuth services that can't work from a remote client
          // (Tidal client rejected by Tidal; Spotify needs a per-user dev app).
          ..removeWhere((k, _) => k == 'tidal' || k == 'spotify');
        if (currentZone != null) _currentZoneId = currentZone!.id;
        _startPolling();
        unawaited(loadFavorites());
        unawaited(loadStreamConfig());
      } else {
        _poll?.cancel();
      }
    } catch (e) {
      _error = e.toString();
      _connected = false;
      _poll?.cancel();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  // ── Now-playing polling ────────────────────────────────────────────
  void _startPolling() {
    _poll?.cancel();
    _poll = Timer.periodic(const Duration(seconds: 2), (_) => _pollZones());
  }

  Future<void> _pollZones() async {
    final c = _client;
    if (c == null || !_connected) return;
    try {
      _zones = await c.zones();
      notifyListeners();
    } catch (_) {}
  }

  Future<void> togglePlay() async {
    final c = _client;
    final z = currentZone;
    if (c == null || z == null) return;
    if (z.isPlaying) {
      await c.pauseZone(z.id);
    } else {
      await c.resumeZone(z.id);
    }
    await _pollZones();
  }

  Future<void> next() async {
    final c = _client;
    final z = currentZone;
    if (c == null || z == null) return;
    await c.nextZone(z.id);
    await _pollZones();
  }

  Future<void> previous() async {
    final c = _client;
    final z = currentZone;
    if (c == null || z == null) return;
    await c.previousZone(z.id);
    await _pollZones();
  }

  Future<void> stopPlayback() async {
    final c = _client;
    final z = currentZone;
    if (c == null || z == null) return;
    await c.stopZone(z.id);
    await _pollZones();
  }

  Future<void> seek(int positionMs) async {
    final c = _client;
    final z = currentZone;
    if (c == null || z == null) return;
    await c.seekZone(z.id, positionMs);
    await _pollZones();
  }

  @override
  void dispose() {
    _poll?.cancel();
    super.dispose();
  }

  Future<void> setCurrentZone(int id) async {
    _currentZoneId = id;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_kZone, id);
    notifyListeners();
    // Remember it server-side too, so reconnects default to this output.
    try {
      await _client?.setDefaultZone(id);
    } catch (_) {}
  }

  /// Choose the playback output: hot-swap the current zone to [device].
  Future<void> setOutput(Device device) async {
    final c = _client;
    final z = currentZone;
    if (c == null || z == null) return;
    await c.setZoneOutput(z.id, device.type, deviceId: device.id);
    await refresh();
  }

  // ── Favorites ──────────────────────────────────────────────────────
  int _profileId = 1; // local (library) favorites profile
  int get profileId => _profileId;

  /// Bumps whenever the favorites set changes, so screens can reload.
  int _favVersion = 0;
  int get favVersion => _favVersion;

  String _favKey(String source, String type, String id) => '$source|$type|$id';

  /// Local favorites use SINGULAR item types; streaming use plural.
  static String singularType(String type) => switch (type) {
        'tracks' => 'track',
        'albums' => 'album',
        'artists' => 'artist',
        _ => type,
      };

  bool isFavorite(String source, String type, String id) =>
      _favs.contains(_favKey(source, type, id));

  /// Load favorite IDs into [_favs]: every authenticated streaming service,
  /// plus the local library (profile-scoped).
  Future<void> loadFavorites() async {
    final c = _client;
    if (c == null || !_connected) return;
    final keys = <String>{};
    for (final s in _services.values) {
      if (!(s.enabled && s.authenticated)) continue;
      final svc = s.name;
      for (final type in const ['tracks', 'albums', 'artists']) {
        try {
          final items = await c.favorites(svc, type);
          for (final m in items) {
            final id = (m['source_id'] ?? m['id'] ?? m['artist_id'])?.toString();
            if (id != null && id.isNotEmpty) keys.add(_favKey(svc, type, id));
          }
        } catch (_) {}
      }
    }
    // Local library favorites (active profile).
    try {
      _profileId = await c.activeProfileId();
      for (final type in const ['tracks', 'albums', 'artists']) {
        final ids = await c.localFavoriteIds(_profileId, singularType(type));
        for (final id in ids) {
          keys.add(_favKey('local', type, id.toString()));
        }
      }
    } catch (_) {}
    _favs
      ..clear()
      ..addAll(keys);
    _favVersion++;
    notifyListeners();
  }

  /// Add or remove a favorite (optimistic, reverts on error).
  /// Routes local items to the profile favorites API, streaming items to the
  /// per-service favorites API.
  Future<void> toggleFavorite(String source, String type, String id) async {
    final c = _client;
    if (c == null || source.isEmpty || source == 'smart' || id.isEmpty) return;
    final key = _favKey(source, type, id);
    final was = _favs.contains(key);
    if (was) {
      _favs.remove(key);
    } else {
      _favs.add(key);
    }
    notifyListeners();
    try {
      if (source == 'local') {
        final itemId = int.tryParse(id);
        if (itemId == null) throw Exception('Identifiant local invalide');
        final st = singularType(type);
        if (was) {
          await c.removeLocalFavorite(_profileId, st, itemId);
        } else {
          await c.addLocalFavorite(_profileId, st, itemId);
        }
      } else if (was) {
        await c.removeFavorite(source, type, id);
      } else {
        await c.addFavorite(source, type, id);
      }
      _favVersion++;
      notifyListeners();
    } catch (e) {
      if (was) {
        _favs.add(key);
      } else {
        _favs.remove(key);
      }
      notifyListeners();
      rethrow;
    }
  }

  // ── Volume (current zone) ──────────────────────────────────────────
  //
  // `_pollZones` replaces the whole zone list every 2 seconds, so a slider
  // bound straight to `currentZone.volume` snaps backwards while the user is
  // still dragging — the server has not answered yet, and the poll returns the
  // old value. We therefore hold the value the user chose for a short while and
  // prefer it over anything the poll brings back. Same guard as the web client.
  double? _volumeOverride;
  DateTime? _volumeHoldUntil;

  /// Volume of the current zone, 0.0–1.0, honouring a pending local change.
  double get currentVolume {
    final hold = _volumeHoldUntil;
    if (_volumeOverride != null &&
        hold != null &&
        DateTime.now().isBefore(hold)) {
      return _volumeOverride!;
    }
    return currentZone?.volume ?? 1.0;
  }

  /// Move the knob without touching the network — for `Slider.onChanged`.
  void previewVolume(double v) {
    _volumeOverride = v.clamp(0.0, 1.0);
    _volumeHoldUntil = DateTime.now().add(const Duration(seconds: 3));
    notifyListeners();
  }

  /// Commit the chosen volume — for `Slider.onChangeEnd`.
  ///
  /// Committing on drag end rather than on every frame keeps one request per
  /// gesture instead of dozens. A failure restores whatever the server holds,
  /// so the knob never lies about the real volume.
  Future<void> setVolume(double v) async {
    final c = _client;
    final z = currentZone;
    if (c == null || z == null) return;
    previewVolume(v);
    try {
      await c.setZoneVolume(z.id, _volumeOverride!);
    } catch (_) {
      _volumeOverride = null;
      _volumeHoldUntil = null;
      notifyListeners();
      rethrow;
    }
  }

  // ── Zone settings (current zone) ───────────────────────────────────
  Future<void> _patchCurrentZone(Map<String, dynamic> body) async {
    final c = _client;
    final z = currentZone;
    if (c == null || z == null) return;
    await c.patchZone(z.id, body);
    await _pollZones(); // reload zones to reflect the new value
  }

  Future<void> setGapless(bool enabled) =>
      _patchCurrentZone({'gapless_enabled': enabled});

  // ── Streaming quality cap ──────────────────────────────────────────
  Future<void> loadStreamConfig() async {
    final c = _client;
    if (c == null || !_connected) return;
    try {
      _streamCfg = await c.streamConfig();
      notifyListeners();
    } catch (_) {}
  }

  Future<void> setStreamQuality(int sampleRate, int bitDepth) async {
    final c = _client;
    if (c == null) return;
    await c.setStreamQuality(sampleRate, bitDepth);
    await loadStreamConfig();
  }

  // ── Playback helpers (target the current zone) ─────────────────────
  Future<void> playTrack(Track t) async {
    final c = _client;
    final z = currentZone;
    if (c == null || z == null) throw Exception('Aucune zone/sortie sélectionnée');
    if (t.source == 'local') {
      final id = int.tryParse(t.sourceId);
      if (id == null) throw Exception('Identifiant de piste locale invalide');
      await c.playLocalTracks(z.id, [id]);
    } else {
      await c.playStreamingTrack(z.id, t.source, t.sourceId);
    }
    await _pollZones();
  }

  Future<void> playTracks(List<Track> tracks, {int startIndex = 0}) async {
    final c = _client;
    final z = currentZone;
    if (c == null || z == null) throw Exception('Aucune zone/sortie sélectionnée');
    if (tracks.isEmpty) return;
    // Local tracks play by integer ID via a single /play call; streaming
    // tracks use the play-first-then-queue path.
    if (tracks.first.source == 'local') {
      final start = startIndex.clamp(0, tracks.length - 1);
      final ordered = <Track>[
        for (var i = start; i < tracks.length; i++) tracks[i],
        for (var i = 0; i < start; i++) tracks[i],
      ];
      final ids = ordered
          .map((t) => int.tryParse(t.sourceId))
          .whereType<int>()
          .toList();
      if (ids.isNotEmpty) await c.playLocalTracks(z.id, ids);
    } else {
      await c.playTracks(z.id, tracks, startIndex: startIndex);
    }
    await _pollZones();
  }

  Future<void> playAlbum(Album a) async {
    final c = _client;
    final z = currentZone;
    if (c == null || z == null) throw Exception('Aucune zone/sortie sélectionnée');
    final tracks = a.source == 'local'
        ? await c.localAlbumTracks(a.sourceId)
        : await c.streamingAlbumTracks(a.source, a.sourceId);
    await playTracks(tracks);
  }
}

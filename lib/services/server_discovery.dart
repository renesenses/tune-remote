import 'dart:async';
import 'dart:io' show Platform;

import 'package:bonsoir/bonsoir.dart';
import 'package:flutter/foundation.dart';

// ---------------------------------------------------------------------------
// ServerDiscovery — trouve les serveurs Tune du reseau local en mDNS / DNS-SD.
//
// Le serveur Tune publie deja son service sous `_tune-server._tcp.local.` avec
// son nom, son adresse et son port : il n'y a rien a faire cote serveur, cette
// classe ne fait qu'ecouter.
//
// La bibliotheque et la mecanique (Bonsoir, `found` puis `resolve`, TXT lus
// dans `attributes`) sont reprises de tune-server-flutter,
// lib/server/discovery/tune_discovery.dart, pour que les deux applications
// Flutter du meme auteur parlent le meme DNS-SD. Difference : la telecommande
// ne diffuse RIEN, elle ne fait que chercher.
// ---------------------------------------------------------------------------

/// Type DNS-SD publie par le serveur Tune.
const kTuneServiceType = '_tune-server._tcp';

/// Port par defaut de l'API Tune, quand le TXT n'en donne pas d'autre.
const kTuneDefaultPort = 8888;

/// Ce que l'ecran de connexion montre a l'utilisateur.
///
/// Quatre etats, et pas trois : « rien trouve » et « autorisation manquante »
/// se ressemblent a l'ecran mais ne se reparent pas de la meme facon.
enum DiscoveryState {
  /// Aucune recherche en cours (etat au repos).
  idle,

  /// Recherche lancee, rien encore recu.
  searching,

  /// Au moins un serveur repond. La recherche continue en arriere-plan :
  /// un serveur allume plus tard doit encore apparaitre.
  found,

  /// La recherche a tourne assez longtemps sans rien voir.
  empty,

  /// Le systeme a refuse la decouverte (Android le dit, iOS non — voir
  /// [permissionSilentOnThisPlatform]).
  denied,
}

/// Un serveur Tune vu sur le reseau.
@immutable
class DiscoveredServer {
  /// Nom lisible : le TXT `name` publie par le serveur, sinon le nom du
  /// service DNS-SD.
  final String name;

  /// Adresse joignable (IP le plus souvent, parfois un nom `.local`).
  final String host;

  /// Port de l'API Tune.
  final int port;

  /// Version du serveur, si le TXT la donne ('' sinon).
  final String version;

  /// Identifiant stable publie par le serveur, si present.
  final String serverId;

  const DiscoveredServer({
    required this.name,
    required this.host,
    required this.port,
    this.version = '',
    this.serverId = '',
  });

  /// Clef d'unicite dans la liste : deux serveurs sur la meme machine et le
  /// meme port sont le meme serveur.
  String get id => '$host:$port';

  @override
  bool operator ==(Object other) =>
      other is DiscoveredServer && other.id == id && other.name == name;

  @override
  int get hashCode => Object.hash(id, name);

  @override
  String toString() => 'DiscoveredServer($name @ $host:$port v$version)';
}

/// Cherche les serveurs Tune sur le reseau local et tient la liste a jour.
///
/// La recherche reste allumee tant que [stop] n'est pas appele : un serveur
/// qui demarre pendant que l'ecran est ouvert doit s'ajouter tout seul.
class ServerDiscovery extends ChangeNotifier {
  ServerDiscovery({
    Duration? silenceWindow,
    Future<BonsoirDiscovery> Function()? openDiscovery,
  })  : _silenceWindow = silenceWindow ?? const Duration(seconds: 6),
        _openDiscovery = openDiscovery ?? _defaultOpenDiscovery;

  /// Delai au bout duquel une recherche muette est declaree vide. En dessous
  /// de ~5 s on annonce « rien trouve » alors que les reponses arrivent.
  final Duration _silenceWindow;

  /// Fabrique de la recherche Bonsoir. Injectable pour les essais.
  final Future<BonsoirDiscovery> Function() _openDiscovery;

  static Future<BonsoirDiscovery> _defaultOpenDiscovery() async {
    final d = BonsoirDiscovery(type: kTuneServiceType);
    await d.ready;
    return d;
  }

  BonsoirDiscovery? _discovery;
  StreamSubscription<BonsoirDiscoveryEvent>? _sub;
  Timer? _silenceTimer;

  final Map<String, DiscoveredServer> _servers = {};
  DiscoveryState _state = DiscoveryState.idle;
  String? _errorDetail;

  /// Les serveurs trouves, tries par nom pour que l'ordre ne saute pas d'un
  /// rafraichissement a l'autre.
  List<DiscoveredServer> get servers {
    final list = _servers.values.toList()
      ..sort((a, b) {
        final n = a.name.toLowerCase().compareTo(b.name.toLowerCase());
        return n != 0 ? n : a.id.compareTo(b.id);
      });
    return List.unmodifiable(list);
  }

  DiscoveryState get state => _state;

  /// Detail technique du refus, pour la journalisation ; jamais affiche tel
  /// quel a l'utilisateur.
  String? get errorDetail => _errorDetail;

  /// Vrai sur les plateformes ou un refus d'autorisation ne produit AUCUNE
  /// erreur : la recherche tourne et ne rend simplement rien.
  ///
  /// C'est le cas d'iOS (autorisation « reseau local ») : quand la recherche
  /// est muette, l'ecran doit proposer les deux explications a la fois, parce
  /// que le systeme ne nous dit pas laquelle est la bonne.
  static bool get permissionSilentOnThisPlatform =>
      !kIsWeb && (Platform.isIOS || Platform.isMacOS);

  /// Lance — ou relance — la recherche.
  Future<void> start() async {
    await stop();
    _servers.clear();
    _errorDetail = null;
    _state = DiscoveryState.searching;
    notifyListeners();

    try {
      final d = await _openDiscovery();
      _discovery = d;
      // On s'abonne AVANT de demarrer : sinon les premieres reponses,
      // souvent les plus rapides, passent a la tremie.
      _sub = d.eventStream?.listen(
        _onEvent,
        onError: (Object e) => _fail(e),
        cancelOnError: false,
      );
      await d.start();
    } catch (e) {
      _fail(e);
      return;
    }

    _silenceTimer = Timer(_silenceWindow, () {
      if (_state == DiscoveryState.searching && _servers.isEmpty) {
        _state = DiscoveryState.empty;
        notifyListeners();
      }
    });
  }

  /// Arrete la recherche et libere le canal natif.
  Future<void> stop() async {
    _silenceTimer?.cancel();
    _silenceTimer = null;
    try {
      await _sub?.cancel();
    } catch (_) {}
    _sub = null;
    try {
      await _discovery?.stop();
    } catch (_) {}
    _discovery = null;
    if (_state == DiscoveryState.searching) {
      _state = _servers.isEmpty ? DiscoveryState.idle : DiscoveryState.found;
      notifyListeners();
    }
  }

  void _fail(Object e) {
    _silenceTimer?.cancel();
    _silenceTimer = null;
    _errorDetail = e.toString();
    // Android remonte un vrai refus (multicast interdit, NSD indisponible) par
    // le flux d'evenements : on peut le nommer.
    _state = DiscoveryState.denied;
    debugPrint('[ServerDiscovery] echec : $e');
    notifyListeners();
  }

  void _onEvent(BonsoirDiscoveryEvent event) {
    switch (event.type) {
      case BonsoirDiscoveryEventType.discoveryServiceFound:
        // Un service trouve n'a ni adresse ni TXT : il faut le resoudre. On le
        // fait tout de suite, la liste doit se remplir sans geste de
        // l'utilisateur.
        final s = event.service;
        final d = _discovery;
        if (s != null && d != null) {
          s.resolve(d.serviceResolver);
        }
      case BonsoirDiscoveryEventType.discoveryServiceResolved:
        _onResolved(event.service);
      case BonsoirDiscoveryEventType.discoveryServiceLost:
        _onLost(event.service);
      default:
        break;
    }
  }

  void _onResolved(BonsoirService? service) {
    if (service is! ResolvedBonsoirService) return;
    final host = service.host ?? '';
    if (host.isEmpty) return;

    final attrs = service.attributes;
    final server = DiscoveredServer(
      // Le TXT `name` porte le nom lisible (« Tune (Mac-Studio-6.local) ») ;
      // le nom DNS-SD est le repli.
      name: (attrs['name'] ?? '').trim().isNotEmpty
          ? attrs['name']!.trim()
          : service.name,
      host: host,
      port: service.port > 0 ? service.port : kTuneDefaultPort,
      version: attrs['version'] ?? '',
      serverId: attrs['server_id'] ?? '',
    );

    _servers[server.id] = server;
    _silenceTimer?.cancel();
    _silenceTimer = null;
    _state = DiscoveryState.found;
    notifyListeners();
  }

  void _onLost(BonsoirService? service) {
    if (service == null) return;
    // L'evenement « perdu » ne porte que le nom du service : on retire par
    // correspondance de nom, sur le nom DNS-SD comme sur le nom lisible.
    _servers.removeWhere(
      (_, s) => s.name == service.name || s.serverId == service.name,
    );
    if (_servers.isEmpty && _state == DiscoveryState.found) {
      _state = DiscoveryState.empty;
    }
    notifyListeners();
  }

  @override
  void dispose() {
    unawaited(stop());
    super.dispose();
  }
}

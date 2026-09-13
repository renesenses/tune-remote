// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLIt extends AppL {
  AppLIt([String locale = 'it']) : super(locale);

  @override
  String get navSearch => 'Cerca';

  @override
  String get navPlaylists => 'Playlist';

  @override
  String get navFavorites => 'Preferiti';

  @override
  String get navSettings => 'Impostazioni';

  @override
  String get loading => 'Caricamento…';

  @override
  String errorWith(String msg) {
    return 'Errore: $msg';
  }

  @override
  String get notConnected => 'Configura il server nelle Impostazioni';

  @override
  String get playAll => 'Riproduci tutto';

  @override
  String get noTracks => 'Nessun brano';

  @override
  String get searchTitle => 'Cerca';

  @override
  String get searchHint => 'Titolo, album, artista…';

  @override
  String get filterAll => 'Tutto';

  @override
  String get searchEmptyTitle => 'Cerca un titolo, un album o un artista';

  @override
  String get searchEmptySub => 'Qobuz · YouTube · la tua libreria';

  @override
  String get noResults => 'Nessun risultato';

  @override
  String get sectionArtists => 'Artisti';

  @override
  String get sectionAlbums => 'Album';

  @override
  String get sectionPlaylists => 'Playlist';

  @override
  String get sectionTracks => 'Brani';

  @override
  String get sourceLibrary => 'Libreria';

  @override
  String get playlistsTitle => 'Playlist';

  @override
  String get dynamicPlaylists => 'Playlist dinamiche';

  @override
  String get dynamicTag => 'Dinamica';

  @override
  String tracksCount(int n) {
    return '$n brani';
  }

  @override
  String maxTracks(int n) {
    return 'max $n';
  }

  @override
  String get noPlaylists => 'Nessuna playlist';

  @override
  String get favoritesTitle => 'Preferiti';

  @override
  String get tabArtists => 'Artisti';

  @override
  String get tabAlbums => 'Album';

  @override
  String get tabTracks => 'Brani';

  @override
  String get noFavArtists => 'Nessun artista preferito';

  @override
  String get noFavAlbums => 'Nessun album preferito';

  @override
  String get noFavTracks => 'Nessun brano preferito';

  @override
  String get settingsTitle => 'Impostazioni';

  @override
  String get server => 'Server';

  @override
  String get host => 'Host';

  @override
  String get port => 'Porta';

  @override
  String get connect => 'Connetti';

  @override
  String get connected => 'Connesso';

  @override
  String get disconnected => 'Non connesso';

  @override
  String get audioOutput => 'Uscita audio';

  @override
  String get audioOutputDesc =>
      'Ogni zona del server è un\'uscita (ALSA locale, renderer Diretta…). Scegli la zona su cui riprodurre.';

  @override
  String get noZones => 'Nessuna zona disponibile';

  @override
  String get gapless => 'Riproduzione senza pause';

  @override
  String get gaplessDesc =>
      'Disattiva se senti rumore bianco / interruzioni tra i brani su questo renderer.';

  @override
  String get metadataFields => 'Campi metadati';

  @override
  String get metadataFieldsDesc => 'Info mostrate per la libreria locale';

  @override
  String get streamingQuality => 'Qualità streaming';

  @override
  String get streamingQualityDesc =>
      'Limita la frequenza / risoluzione richiesta ai servizi (Qobuz, Tidal…).';

  @override
  String get freqLimit => 'Limite di frequenza';

  @override
  String get qualityMax => 'Massima';

  @override
  String get qualityHires => 'Hi-Res (fino a 192 kHz)';

  @override
  String get qualityCd => 'CD (44.1 kHz / 16 bit)';

  @override
  String get maxFrequency => 'Frequenza max';

  @override
  String get maxBitDepth => 'Profondità max';

  @override
  String get noLimit => 'Nessun limite';

  @override
  String get streamingServices => 'Servizi di streaming';

  @override
  String get language => 'Lingua';

  @override
  String get systemLanguage => 'Sistema';

  @override
  String get nothingPlaying => 'Niente in riproduzione';

  @override
  String get visualizer => 'Visualizzatore';

  @override
  String get cover => 'Copertina';

  @override
  String get addFavorite => 'Aggiungi ai preferiti';

  @override
  String get removeFavorite => 'Rimuovi dai preferiti';

  @override
  String favError(String msg) {
    return 'Preferito non riuscito: $msg';
  }

  @override
  String get metadataTitle => 'Campi metadati';

  @override
  String get metadataSaved => 'Metadati salvati';

  @override
  String get localLibrary => 'Libreria locale';

  @override
  String get localLibraryDesc => 'Cartelle in cui il server cerca la musica';

  @override
  String get musicFolders => 'Cartelle scansionate';

  @override
  String get addFolder => 'Aggiungi una cartella';

  @override
  String get noFolders => 'Nessuna cartella configurata';

  @override
  String get runScan => 'Scansiona libreria';

  @override
  String get scanning => 'Scansione…';

  @override
  String get pickFolder => 'Scegli una cartella';

  @override
  String get addThisFolder => 'Aggiungi questa cartella';

  @override
  String get createPlaylist => 'Crea una playlist';

  @override
  String get playlistName => 'Nome della playlist';

  @override
  String get create => 'Crea';

  @override
  String get addToPlaylist => 'Aggiungi a una playlist';

  @override
  String get newPlaylist => 'Nuova playlist';

  @override
  String get playlistCreated => 'Playlist creata';

  @override
  String get addedToPlaylist => 'Aggiunto alla playlist';

  @override
  String get delete => 'Elimina';

  @override
  String get deletePlaylist => 'Elimina playlist';

  @override
  String get deletePlaylistConfirm => 'Eliminare questa playlist?';

  @override
  String get playlistDeleted => 'Playlist eliminata';

  @override
  String get trackRemoved => 'Rimosso dalla playlist';

  @override
  String get removeFromPlaylist => 'Rimuovi dalla playlist';

  @override
  String get logIn => 'Accedi';

  @override
  String get logOut => 'Disconnetti';

  @override
  String get username => 'Nome utente';

  @override
  String get password => 'Password';

  @override
  String get cancel => 'Annulla';

  @override
  String get noService => 'Nessun servizio';

  @override
  String loginTo(String service) {
    return 'Accedi a $service';
  }

  @override
  String get authorizeInBrowser => 'Autorizza l\'accesso nel browser:';

  @override
  String get openAuthPage => 'Apri la pagina di autorizzazione';

  @override
  String get done => 'Ho finito';

  @override
  String get disabled => 'Disattivato';

  @override
  String get navHome => 'Home';

  @override
  String get listeningActivity => 'Attività di ascolto';

  @override
  String get mostPlayed => 'Più ascoltati';

  @override
  String playsCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n ascolti',
      one: '1 ascolto',
      zero: 'nessun ascolto',
    );
    return '$_temp0';
  }

  @override
  String get lyrics => 'Testo';

  @override
  String get noLyrics => 'Nessun testo per questo brano';

  @override
  String get syncedLyricsPremium =>
      'Il testo sincronizzato richiede una licenza premium: viene mostrato il testo semplice.';

  @override
  String get smartRadio => 'Radio intelligente';

  @override
  String get smartRadioGenerate => 'Sorprendimi';

  @override
  String get smartRadioHint =>
      'Crea una selezione dalla tua libreria in base a ciò che ascolti davvero, oppure scegli un\'atmosfera.';

  @override
  String get moodHappy => 'Allegro';

  @override
  String get moodEnergetic => 'Energico';

  @override
  String get moodCalm => 'Calmo';

  @override
  String get moodFocus => 'Concentrazione';

  @override
  String get moodRomantic => 'Romantico';

  @override
  String get moodSad => 'Malinconia';

  @override
  String get remoteAccess => 'Accesso remoto';

  @override
  String get remoteAccessDesc =>
      'Raggiungere questo server da fuori casa, tramite il relè Tune Bridge. L’associazione si fa una volta, dalla rete locale.';

  @override
  String get bridgeServerId => 'Identificativo del server';

  @override
  String get bridgeToken => 'Token di accesso';

  @override
  String get bridgePair => 'Attivare l\'accesso remoto';

  @override
  String get bridgeUnpair => 'Tornare alla rete locale';

  @override
  String get bridgeActive => 'Accesso remoto attivo';

  @override
  String get bridgeHint =>
      'Entrambi i valori provengono dal server: Impostazioni → Accesso remoto.';

  @override
  String get discoveryTitle => 'Connettersi a un server';

  @override
  String get discoverySection => 'Server sulla rete';

  @override
  String get discoverySearching => 'Ricerca sulla rete locale…';

  @override
  String discoveryFoundCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n server trovati',
      one: '1 server trovato',
    );
    return '$_temp0';
  }

  @override
  String get discoveryNone => 'Nessun server Tune trovato';

  @override
  String get discoveryNoneHint =>
      'Verifica che il server sia acceso e che questo dispositivo sia sulla stessa rete Wi-Fi.';

  @override
  String get discoveryLocalNetworkHint =>
      'Se hai rifiutato l’accesso alla rete locale, iOS non trova nulla e non lo segnala. Consentilo in Impostazioni → Tune Remote → Rete locale, poi riprova.';

  @override
  String get discoveryDenied => 'Rilevamento di rete rifiutato';

  @override
  String get discoveryDeniedHintIos =>
      'Consenti l’accesso alla rete locale in Impostazioni → Tune Remote → Rete locale, poi riprova.';

  @override
  String get discoveryDeniedHintAndroid =>
      'Android ha rifiutato il rilevamento di rete. Attiva il Wi-Fi, esci dalla modalità aereo, poi riprova.';

  @override
  String get discoveryRetry => 'Cerca di nuovo';

  @override
  String get discoveryManualToggle => 'Inserire un indirizzo manualmente';

  @override
  String get discoveryManualIntro =>
      'Un server dietro una VPN o su un’altra sottorete non viene mai rilevato: digita il suo indirizzo.';
}

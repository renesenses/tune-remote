// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLFr extends AppL {
  AppLFr([String locale = 'fr']) : super(locale);

  @override
  String get navSearch => 'Recherche';

  @override
  String get navPlaylists => 'Playlists';

  @override
  String get navFavorites => 'Favoris';

  @override
  String get navSettings => 'Paramètres';

  @override
  String get loading => 'Chargement…';

  @override
  String errorWith(String msg) {
    return 'Erreur : $msg';
  }

  @override
  String get notConnected => 'Configure le serveur dans Paramètres';

  @override
  String get playAll => 'Tout lire';

  @override
  String get noTracks => 'Aucune piste';

  @override
  String get searchTitle => 'Recherche';

  @override
  String get searchHint => 'Titre, album, artiste…';

  @override
  String get filterAll => 'Tout';

  @override
  String get searchEmptyTitle => 'Recherche un titre, un album ou un artiste';

  @override
  String get searchEmptySub => 'Qobuz · YouTube · ta bibliothèque';

  @override
  String get noResults => 'Aucun résultat';

  @override
  String get sectionArtists => 'Artistes';

  @override
  String get sectionAlbums => 'Albums';

  @override
  String get sectionPlaylists => 'Playlists';

  @override
  String get sectionTracks => 'Titres';

  @override
  String get sourceLibrary => 'Bibliothèque';

  @override
  String get playlistsTitle => 'Playlists';

  @override
  String get dynamicPlaylists => 'Playlists dynamiques';

  @override
  String get dynamicTag => 'Dynamique';

  @override
  String tracksCount(int n) {
    return '$n pistes';
  }

  @override
  String maxTracks(int n) {
    return 'max $n';
  }

  @override
  String get noPlaylists => 'Aucune playlist';

  @override
  String get favoritesTitle => 'Favoris';

  @override
  String get tabArtists => 'Artistes';

  @override
  String get tabAlbums => 'Albums';

  @override
  String get tabTracks => 'Titres';

  @override
  String get noFavArtists => 'Aucun artiste favori';

  @override
  String get noFavAlbums => 'Aucun album favori';

  @override
  String get noFavTracks => 'Aucun titre favori';

  @override
  String get settingsTitle => 'Paramètres';

  @override
  String get server => 'Serveur';

  @override
  String get host => 'Hôte';

  @override
  String get port => 'Port';

  @override
  String get connect => 'Connecter';

  @override
  String get connected => 'Connecté';

  @override
  String get disconnected => 'Non connecté';

  @override
  String get audioOutput => 'Sortie audio';

  @override
  String get audioOutputDesc =>
      'Chaque zone du serveur correspond à une sortie (ALSA local, renderer Diretta…). Choisis la zone sur laquelle jouer.';

  @override
  String get noZones => 'Aucune zone disponible';

  @override
  String get gapless => 'Lecture enchaînée (gapless)';

  @override
  String get gaplessDesc =>
      'À désactiver si bruit blanc / glitch entre les pistes sur ce renderer.';

  @override
  String get metadataFields => 'Champs de métadonnées';

  @override
  String get metadataFieldsDesc =>
      'Infos affichées pour la bibliothèque locale';

  @override
  String get streamingQuality => 'Qualité streaming';

  @override
  String get streamingQualityDesc =>
      'Plafonne la fréquence / résolution demandée aux services (Qobuz, Tidal…).';

  @override
  String get freqLimit => 'Limite de fréquence';

  @override
  String get qualityMax => 'Maximum';

  @override
  String get qualityHires => 'Hi-Res (jusqu\'à 192 kHz)';

  @override
  String get qualityCd => 'CD (44.1 kHz / 16 bit)';

  @override
  String get maxFrequency => 'Fréquence max';

  @override
  String get maxBitDepth => 'Profondeur max';

  @override
  String get noLimit => 'Sans limite';

  @override
  String get streamingServices => 'Services de streaming';

  @override
  String get language => 'Langue';

  @override
  String get systemLanguage => 'Système';

  @override
  String get nothingPlaying => 'Rien en lecture';

  @override
  String get visualizer => 'Visualiseur';

  @override
  String get cover => 'Pochette';

  @override
  String get addFavorite => 'Ajouter aux favoris';

  @override
  String get removeFavorite => 'Retirer des favoris';

  @override
  String favError(String msg) {
    return 'Échec favori : $msg';
  }

  @override
  String get metadataTitle => 'Champs de métadonnées';

  @override
  String get metadataSaved => 'Métadonnées enregistrées';

  @override
  String get localLibrary => 'Bibliothèque locale';

  @override
  String get localLibraryDesc => 'Dossiers où le serveur cherche la musique';

  @override
  String get musicFolders => 'Dossiers scannés';

  @override
  String get addFolder => 'Ajouter un dossier';

  @override
  String get noFolders => 'Aucun dossier configuré';

  @override
  String get runScan => 'Scanner la bibliothèque';

  @override
  String get scanning => 'Scan en cours…';

  @override
  String get pickFolder => 'Choisir un dossier';

  @override
  String get addThisFolder => 'Ajouter ce dossier';

  @override
  String get createPlaylist => 'Créer une playlist';

  @override
  String get playlistName => 'Nom de la playlist';

  @override
  String get create => 'Créer';

  @override
  String get addToPlaylist => 'Ajouter à une playlist';

  @override
  String get newPlaylist => 'Nouvelle playlist';

  @override
  String get playlistCreated => 'Playlist créée';

  @override
  String get addedToPlaylist => 'Ajouté à la playlist';

  @override
  String get delete => 'Supprimer';

  @override
  String get deletePlaylist => 'Supprimer la playlist';

  @override
  String get deletePlaylistConfirm => 'Supprimer cette playlist ?';

  @override
  String get playlistDeleted => 'Playlist supprimée';

  @override
  String get trackRemoved => 'Retiré de la playlist';

  @override
  String get removeFromPlaylist => 'Retirer de la playlist';

  @override
  String get logIn => 'Se connecter';

  @override
  String get logOut => 'Se déconnecter';

  @override
  String get username => 'Identifiant / email';

  @override
  String get password => 'Mot de passe';

  @override
  String get cancel => 'Annuler';

  @override
  String get noService => 'Aucun service';

  @override
  String loginTo(String service) {
    return 'Connexion $service';
  }

  @override
  String get authorizeInBrowser => 'Autorise l\'accès dans ton navigateur :';

  @override
  String get openAuthPage => 'Ouvrir la page d\'autorisation';

  @override
  String get done => 'J\'ai terminé';

  @override
  String get disabled => 'Désactivé';

  @override
  String get navHome => 'Accueil';

  @override
  String get listeningActivity => 'Écoute récente';

  @override
  String get mostPlayed => 'Les plus écoutés';

  @override
  String playsCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n écoutes',
      one: '1 écoute',
      zero: 'aucune écoute',
    );
    return '$_temp0';
  }

  @override
  String get lyrics => 'Paroles';

  @override
  String get noLyrics => 'Pas de paroles pour ce titre';

  @override
  String get syncedLyricsPremium =>
      'Les paroles synchronisées nécessitent une licence premium — texte brut affiché.';

  @override
  String get smartRadio => 'Radio intelligente';

  @override
  String get smartRadioGenerate => 'Surprends-moi';

  @override
  String get smartRadioHint =>
      'Compose une sélection dans votre bibliothèque — d\'après ce que vous écoutez vraiment, ou choisissez une humeur.';

  @override
  String get moodHappy => 'Joyeux';

  @override
  String get moodEnergetic => 'Énergique';

  @override
  String get moodCalm => 'Calme';

  @override
  String get moodFocus => 'Concentration';

  @override
  String get moodRomantic => 'Romantique';

  @override
  String get moodSad => 'Mélancolie';

  @override
  String get remoteAccess => 'Accès distant';

  @override
  String get remoteAccessDesc =>
      'Joindre ce serveur depuis l\'extérieur de chez vous, par le relais Tune Bridge. L\'appairage se fait une fois, depuis votre réseau local.';

  @override
  String get bridgeServerId => 'Identifiant du serveur';

  @override
  String get bridgeToken => 'Jeton d\'accès';

  @override
  String get bridgePair => 'Activer l\'accès distant';

  @override
  String get bridgeUnpair => 'Revenir au réseau local';

  @override
  String get bridgeActive => 'Accès distant actif';

  @override
  String get bridgeHint =>
      'Les deux valeurs viennent de votre serveur : Réglages → Accès distant.';

  @override
  String get discoveryTitle => 'Se connecter à un serveur';

  @override
  String get discoverySection => 'Serveurs sur le réseau';

  @override
  String get discoverySearching => 'Recherche sur le réseau local…';

  @override
  String discoveryFoundCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n serveurs trouvés',
      one: '1 serveur trouvé',
    );
    return '$_temp0';
  }

  @override
  String get discoveryNone => 'Aucun serveur Tune trouvé';

  @override
  String get discoveryNoneHint =>
      'Vérifiez que le serveur est allumé et que cet appareil est sur le même réseau Wi-Fi.';

  @override
  String get discoveryLocalNetworkHint =>
      'Si vous avez refusé l\'accès au réseau local, iOS ne trouve rien et ne dit rien. Autorisez-le dans Réglages → Tune Remote → Réseau local, puis relancez la recherche.';

  @override
  String get discoveryDenied => 'Découverte réseau refusée';

  @override
  String get discoveryDeniedHintIos =>
      'Autorisez l\'accès au réseau local dans Réglages → Tune Remote → Réseau local, puis relancez la recherche.';

  @override
  String get discoveryDeniedHintAndroid =>
      'Android a refusé la découverte réseau. Activez le Wi-Fi, quittez le mode avion, puis relancez la recherche.';

  @override
  String get discoveryRetry => 'Relancer la recherche';

  @override
  String get discoveryManualToggle => 'Saisir une adresse à la main';

  @override
  String get discoveryManualIntro =>
      'Un serveur derrière un VPN ou sur un autre sous-réseau n\'est jamais découvert : indiquez son adresse.';
}

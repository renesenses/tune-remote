// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hungarian (`hu`).
class AppLHu extends AppL {
  AppLHu([String locale = 'hu']) : super(locale);

  @override
  String get navSearch => 'Keresés';

  @override
  String get navPlaylists => 'Lejátszási listák';

  @override
  String get navFavorites => 'Kedvencek';

  @override
  String get navSettings => 'Beállítások';

  @override
  String get loading => 'Betöltés…';

  @override
  String errorWith(String msg) {
    return 'Hiba: $msg';
  }

  @override
  String get notConnected => 'Állítsd be a szervert a Beállításokban';

  @override
  String get playAll => 'Összes lejátszása';

  @override
  String get noTracks => 'Nincs szám';

  @override
  String get searchTitle => 'Keresés';

  @override
  String get searchHint => 'Cím, album, előadó…';

  @override
  String get filterAll => 'Összes';

  @override
  String get searchEmptyTitle => 'Keress számot, albumot vagy előadót';

  @override
  String get searchEmptySub => 'Qobuz · YouTube · a gyűjteményed';

  @override
  String get noResults => 'Nincs találat';

  @override
  String get sectionArtists => 'Előadók';

  @override
  String get sectionAlbums => 'Albumok';

  @override
  String get sectionPlaylists => 'Lejátszási listák';

  @override
  String get sectionTracks => 'Számok';

  @override
  String get sourceLibrary => 'Gyűjtemény';

  @override
  String get playlistsTitle => 'Lejátszási listák';

  @override
  String get dynamicPlaylists => 'Dinamikus lejátszási listák';

  @override
  String get dynamicTag => 'Dinamikus';

  @override
  String tracksCount(int n) {
    return '$n szám';
  }

  @override
  String maxTracks(int n) {
    return 'max. $n';
  }

  @override
  String get noPlaylists => 'Nincs lejátszási lista';

  @override
  String get favoritesTitle => 'Kedvencek';

  @override
  String get tabArtists => 'Előadók';

  @override
  String get tabAlbums => 'Albumok';

  @override
  String get tabTracks => 'Számok';

  @override
  String get noFavArtists => 'Nincs kedvenc előadó';

  @override
  String get noFavAlbums => 'Nincs kedvenc album';

  @override
  String get noFavTracks => 'Nincs kedvenc szám';

  @override
  String get settingsTitle => 'Beállítások';

  @override
  String get server => 'Szerver';

  @override
  String get host => 'Gazdagép';

  @override
  String get port => 'Port';

  @override
  String get connect => 'Csatlakozás';

  @override
  String get connected => 'Csatlakoztatva';

  @override
  String get disconnected => 'Nincs csatlakoztatva';

  @override
  String get audioOutput => 'Hangkimenet';

  @override
  String get audioOutputDesc =>
      'A szerver minden zónája egy-egy kimenetnek felel meg (helyi ALSA, Diretta-renderelő…). Válaszd ki, melyiken szóljon.';

  @override
  String get noZones => 'Nincs elérhető zóna';

  @override
  String get gapless => 'Folyamatos lejátszás (gapless)';

  @override
  String get gaplessDesc =>
      'Kapcsold ki, ha fehér zaj vagy zavar hallatszik a számok között ezen a renderelőn.';

  @override
  String get metadataFields => 'Metaadatmezők';

  @override
  String get metadataFieldsDesc => 'A helyi gyűjteményhez megjelenített adatok';

  @override
  String get streamingQuality => 'Streaming minősége';

  @override
  String get streamingQualityDesc =>
      'Korlátozza a szolgáltatásoktól (Qobuz, Tidal…) kért frekvenciát és felbontást.';

  @override
  String get freqLimit => 'Frekvenciakorlát';

  @override
  String get qualityMax => 'Maximum';

  @override
  String get qualityHires => 'Hi-Res (akár 192 kHz)';

  @override
  String get qualityCd => 'CD (44,1 kHz / 16 bit)';

  @override
  String get maxFrequency => 'Max. frekvencia';

  @override
  String get maxBitDepth => 'Max. bitmélység';

  @override
  String get noLimit => 'Nincs korlát';

  @override
  String get streamingServices => 'Streamingszolgáltatások';

  @override
  String get language => 'Nyelv';

  @override
  String get systemLanguage => 'Rendszer';

  @override
  String get nothingPlaying => 'Nem szól semmi';

  @override
  String get visualizer => 'Vizualizáció';

  @override
  String get cover => 'Borító';

  @override
  String get addFavorite => 'Hozzáadás a kedvencekhez';

  @override
  String get removeFavorite => 'Eltávolítás a kedvencekből';

  @override
  String favError(String msg) {
    return 'A kedvencekhez adás nem sikerült: $msg';
  }

  @override
  String get metadataTitle => 'Metaadatmezők';

  @override
  String get metadataSaved => 'A metaadatok mentve';

  @override
  String get localLibrary => 'Helyi gyűjtemény';

  @override
  String get localLibraryDesc => 'Mappák, ahol a szerver a zenét keresi';

  @override
  String get musicFolders => 'Beolvasott mappák';

  @override
  String get addFolder => 'Mappa hozzáadása';

  @override
  String get noFolders => 'Nincs beállított mappa';

  @override
  String get runScan => 'Gyűjtemény beolvasása';

  @override
  String get scanning => 'Beolvasás folyamatban…';

  @override
  String get pickFolder => 'Válassz mappát';

  @override
  String get addThisFolder => 'Ezt a mappát hozzáadom';

  @override
  String get createPlaylist => 'Lejátszási lista létrehozása';

  @override
  String get playlistName => 'A lejátszási lista neve';

  @override
  String get create => 'Létrehozás';

  @override
  String get addToPlaylist => 'Hozzáadás lejátszási listához';

  @override
  String get newPlaylist => 'Új lejátszási lista';

  @override
  String get playlistCreated => 'A lejátszási lista létrejött';

  @override
  String get addedToPlaylist => 'Hozzáadva a lejátszási listához';

  @override
  String get delete => 'Törlés';

  @override
  String get deletePlaylist => 'Lejátszási lista törlése';

  @override
  String get deletePlaylistConfirm => 'Törlöd ezt a lejátszási listát?';

  @override
  String get playlistDeleted => 'A lejátszási lista törölve';

  @override
  String get trackRemoved => 'Eltávolítva a lejátszási listáról';

  @override
  String get removeFromPlaylist => 'Eltávolítás a lejátszási listáról';

  @override
  String get logIn => 'Bejelentkezés';

  @override
  String get logOut => 'Kijelentkezés';

  @override
  String get username => 'Azonosító / e-mail';

  @override
  String get password => 'Jelszó';

  @override
  String get cancel => 'Mégse';

  @override
  String get noService => 'Nincs szolgáltatás';

  @override
  String loginTo(String service) {
    return 'Bejelentkezés: $service';
  }

  @override
  String get authorizeInBrowser => 'Engedélyezd a hozzáférést a böngésződben:';

  @override
  String get openAuthPage => 'Az engedélyezési oldal megnyitása';

  @override
  String get done => 'Végeztem';

  @override
  String get disabled => 'Kikapcsolva';

  @override
  String get navHome => 'Kezdőlap';

  @override
  String get listeningActivity => 'Friss hallgatás';

  @override
  String get mostPlayed => 'Legtöbbet hallgatott';

  @override
  String playsCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n lejátszás',
      one: '1 lejátszás',
      zero: 'nincs lejátszás',
    );
    return '$_temp0';
  }

  @override
  String get lyrics => 'Dalszöveg';

  @override
  String get noLyrics => 'Ehhez a számhoz nincs dalszöveg';

  @override
  String get syncedLyricsPremium =>
      'A szinkronizált dalszöveghez prémium licenc szükséges — egyszerű szöveg jelenik meg.';

  @override
  String get smartRadio => 'Okos rádió';

  @override
  String get smartRadioGenerate => 'Lepj meg';

  @override
  String get smartRadioHint =>
      'Válogatást állít össze a gyűjteményedből — abból, amit valóban hallgatsz, vagy válassz egy hangulatot.';

  @override
  String get moodHappy => 'Vidám';

  @override
  String get moodEnergetic => 'Energikus';

  @override
  String get moodCalm => 'Nyugodt';

  @override
  String get moodFocus => 'Koncentráció';

  @override
  String get moodRomantic => 'Romantikus';

  @override
  String get moodSad => 'Melankólia';
}

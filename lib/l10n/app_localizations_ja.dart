// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLJa extends AppL {
  AppLJa([String locale = 'ja']) : super(locale);

  @override
  String get navSearch => '検索';

  @override
  String get navPlaylists => 'プレイリスト';

  @override
  String get navFavorites => 'お気に入り';

  @override
  String get navSettings => '設定';

  @override
  String get loading => '読み込み中…';

  @override
  String errorWith(String msg) {
    return 'エラー: $msg';
  }

  @override
  String get notConnected => '設定でサーバーを構成してください';

  @override
  String get playAll => 'すべて再生';

  @override
  String get noTracks => 'トラックなし';

  @override
  String get searchTitle => '検索';

  @override
  String get searchHint => 'タイトル、アルバム、アーティスト…';

  @override
  String get filterAll => 'すべて';

  @override
  String get searchEmptyTitle => 'タイトル・アルバム・アーティストを検索';

  @override
  String get searchEmptySub => 'Qobuz · YouTube · ライブラリ';

  @override
  String get noResults => '結果なし';

  @override
  String get sectionArtists => 'アーティスト';

  @override
  String get sectionAlbums => 'アルバム';

  @override
  String get sectionPlaylists => 'プレイリスト';

  @override
  String get sectionTracks => 'トラック';

  @override
  String get sourceLibrary => 'ライブラリ';

  @override
  String get playlistsTitle => 'プレイリスト';

  @override
  String get dynamicPlaylists => 'ダイナミックプレイリスト';

  @override
  String get dynamicTag => 'ダイナミック';

  @override
  String tracksCount(int n) {
    return '$n 曲';
  }

  @override
  String maxTracks(int n) {
    return '最大 $n';
  }

  @override
  String get noPlaylists => 'プレイリストなし';

  @override
  String get favoritesTitle => 'お気に入り';

  @override
  String get tabArtists => 'アーティスト';

  @override
  String get tabAlbums => 'アルバム';

  @override
  String get tabTracks => 'トラック';

  @override
  String get noFavArtists => 'お気に入りのアーティストなし';

  @override
  String get noFavAlbums => 'お気に入りのアルバムなし';

  @override
  String get noFavTracks => 'お気に入りのトラックなし';

  @override
  String get settingsTitle => '設定';

  @override
  String get server => 'サーバー';

  @override
  String get host => 'ホスト';

  @override
  String get port => 'ポート';

  @override
  String get connect => '接続';

  @override
  String get connected => '接続済み';

  @override
  String get disconnected => '未接続';

  @override
  String get audioOutput => 'オーディオ出力';

  @override
  String get audioOutputDesc =>
      '各サーバーゾーンが1つの出力です（ローカルALSA、Direttaレンダラー…）。再生するゾーンを選択してください。';

  @override
  String get noZones => '利用可能なゾーンがありません';

  @override
  String get gapless => 'ギャップレス再生';

  @override
  String get gaplessDesc => 'このレンダラーでトラック間にホワイトノイズ/途切れがある場合は無効にしてください。';

  @override
  String get metadataFields => 'メタデータ項目';

  @override
  String get metadataFieldsDesc => 'ローカルライブラリに表示される情報';

  @override
  String get streamingQuality => 'ストリーミング品質';

  @override
  String get streamingQualityDesc => 'サービス（Qobuz、Tidal…）に要求する周波数/解像度の上限を設定します。';

  @override
  String get freqLimit => '周波数の上限';

  @override
  String get qualityMax => '最高';

  @override
  String get qualityHires => 'ハイレゾ（最大192 kHz）';

  @override
  String get qualityCd => 'CD（44.1 kHz / 16ビット）';

  @override
  String get maxFrequency => '最大周波数';

  @override
  String get maxBitDepth => '最大ビット深度';

  @override
  String get noLimit => '制限なし';

  @override
  String get streamingServices => 'ストリーミングサービス';

  @override
  String get language => '言語';

  @override
  String get systemLanguage => 'システム';

  @override
  String get nothingPlaying => '再生していません';

  @override
  String get visualizer => 'ビジュアライザー';

  @override
  String get cover => 'ジャケット';

  @override
  String get addFavorite => 'お気に入りに追加';

  @override
  String get removeFavorite => 'お気に入りから削除';

  @override
  String favError(String msg) {
    return 'お気に入りに失敗: $msg';
  }

  @override
  String get metadataTitle => 'メタデータ項目';

  @override
  String get metadataSaved => 'メタデータを保存しました';

  @override
  String get localLibrary => 'ローカルライブラリ';

  @override
  String get localLibraryDesc => 'サーバーが音楽を探すフォルダ';

  @override
  String get musicFolders => 'スキャン対象フォルダ';

  @override
  String get addFolder => 'フォルダを追加';

  @override
  String get noFolders => 'フォルダが未設定です';

  @override
  String get runScan => 'ライブラリをスキャン';

  @override
  String get scanning => 'スキャン中…';

  @override
  String get pickFolder => 'フォルダを選択';

  @override
  String get addThisFolder => 'このフォルダを追加';

  @override
  String get createPlaylist => 'プレイリストを作成';

  @override
  String get playlistName => 'プレイリスト名';

  @override
  String get create => '作成';

  @override
  String get addToPlaylist => 'プレイリストに追加';

  @override
  String get newPlaylist => '新規プレイリスト';

  @override
  String get playlistCreated => 'プレイリストを作成しました';

  @override
  String get addedToPlaylist => 'プレイリストに追加しました';

  @override
  String get delete => '削除';

  @override
  String get deletePlaylist => 'プレイリストを削除';

  @override
  String get deletePlaylistConfirm => 'このプレイリストを削除しますか？';

  @override
  String get playlistDeleted => 'プレイリストを削除しました';

  @override
  String get trackRemoved => 'プレイリストから削除しました';

  @override
  String get removeFromPlaylist => 'プレイリストから削除';

  @override
  String get logIn => 'ログイン';

  @override
  String get logOut => 'ログアウト';

  @override
  String get username => 'ユーザー名';

  @override
  String get password => 'パスワード';

  @override
  String get cancel => 'キャンセル';

  @override
  String get noService => 'サービスなし';

  @override
  String loginTo(String service) {
    return '$service にログイン';
  }

  @override
  String get authorizeInBrowser => 'ブラウザでアクセスを許可してください：';

  @override
  String get openAuthPage => '認証ページを開く';

  @override
  String get done => '完了しました';

  @override
  String get disabled => '無効';

  @override
  String get navHome => 'ホーム';

  @override
  String get listeningActivity => '再生アクティビティ';

  @override
  String get mostPlayed => 'よく再生';

  @override
  String playsCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n 回再生',
    );
    return '$_temp0';
  }

  @override
  String get lyrics => '歌詞';

  @override
  String get noLyrics => 'この曲の歌詞はありません';

  @override
  String get syncedLyricsPremium => '同期歌詞にはプレミアムライセンスが必要です — プレーンテキストを表示しています。';

  @override
  String get smartRadio => 'スマートラジオ';

  @override
  String get smartRadioGenerate => 'おまかせ';

  @override
  String get smartRadioHint => '実際によく聴く曲をもとに、ライブラリから新しい選曲を作ります。気分から選ぶこともできます。';

  @override
  String get moodHappy => 'ハッピー';

  @override
  String get moodEnergetic => 'エネルギッシュ';

  @override
  String get moodCalm => '穏やか';

  @override
  String get moodFocus => '集中';

  @override
  String get moodRomantic => 'ロマンティック';

  @override
  String get moodSad => 'メランコリー';

  @override
  String get remoteAccess => 'リモートアクセス';

  @override
  String get remoteAccessDesc =>
      'Tune Bridge リレー経由で、自宅ネットワークの外からこのサーバーに接続します。ペアリングは自宅ネットワークから一度だけ行います。';

  @override
  String get bridgeServerId => 'サーバー ID';

  @override
  String get bridgeToken => 'アクセストークン';

  @override
  String get bridgePair => 'リモートアクセスを有効にする';

  @override
  String get bridgeUnpair => 'ローカルネットワークに戻る';

  @override
  String get bridgeActive => 'リモートアクセス有効';

  @override
  String get bridgeHint => 'どちらの値もサーバーから取得します：設定 → リモートアクセス。';

  @override
  String get discoveryTitle => 'サーバーに接続';

  @override
  String get discoverySection => 'ネットワーク上のサーバー';

  @override
  String get discoverySearching => 'ローカルネットワークを検索中…';

  @override
  String discoveryFoundCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n 台のサーバーが見つかりました',
    );
    return '$_temp0';
  }

  @override
  String get discoveryNone => 'Tune サーバーが見つかりません';

  @override
  String get discoveryNoneHint =>
      'サーバーが起動していること、この端末が同じ Wi-Fi ネットワークにあることを確認してください。';

  @override
  String get discoveryLocalNetworkHint =>
      'ローカルネットワークへのアクセスを拒否した場合、iOS は何も見つけず、何も知らせません。設定 → Tune Remote → ローカルネットワーク で許可してから再検索してください。';

  @override
  String get discoveryDenied => 'ネットワーク検索が拒否されました';

  @override
  String get discoveryDeniedHintIos =>
      '設定 → Tune Remote → ローカルネットワーク でアクセスを許可してから再検索してください。';

  @override
  String get discoveryDeniedHintAndroid =>
      'Android がネットワーク検索を拒否しました。Wi-Fi をオンにし、機内モードを解除してから再検索してください。';

  @override
  String get discoveryRetry => '再検索';

  @override
  String get discoveryManualToggle => 'アドレスを手動で入力';

  @override
  String get discoveryManualIntro =>
      'VPN の内側や別のサブネットにあるサーバーは検出されません。アドレスを入力してください。';
}

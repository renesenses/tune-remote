// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLKo extends AppL {
  AppLKo([String locale = 'ko']) : super(locale);

  @override
  String get navSearch => '검색';

  @override
  String get navPlaylists => '재생목록';

  @override
  String get navFavorites => '즐겨찾기';

  @override
  String get navSettings => '설정';

  @override
  String get loading => '불러오는 중…';

  @override
  String errorWith(String msg) {
    return '오류: $msg';
  }

  @override
  String get notConnected => '설정에서 서버를 구성하세요';

  @override
  String get playAll => '전체 재생';

  @override
  String get noTracks => '트랙 없음';

  @override
  String get searchTitle => '검색';

  @override
  String get searchHint => '제목, 앨범, 아티스트…';

  @override
  String get filterAll => '전체';

  @override
  String get searchEmptyTitle => '제목, 앨범 또는 아티스트 검색';

  @override
  String get searchEmptySub => 'Qobuz · YouTube · 내 라이브러리';

  @override
  String get noResults => '결과 없음';

  @override
  String get sectionArtists => '아티스트';

  @override
  String get sectionAlbums => '앨범';

  @override
  String get sectionPlaylists => '재생목록';

  @override
  String get sectionTracks => '트랙';

  @override
  String get sourceLibrary => '라이브러리';

  @override
  String get playlistsTitle => '재생목록';

  @override
  String get dynamicPlaylists => '동적 재생목록';

  @override
  String get dynamicTag => '동적';

  @override
  String tracksCount(int n) {
    return '$n곡';
  }

  @override
  String maxTracks(int n) {
    return '최대 $n';
  }

  @override
  String get noPlaylists => '재생목록 없음';

  @override
  String get favoritesTitle => '즐겨찾기';

  @override
  String get tabArtists => '아티스트';

  @override
  String get tabAlbums => '앨범';

  @override
  String get tabTracks => '트랙';

  @override
  String get noFavArtists => '즐겨찾는 아티스트 없음';

  @override
  String get noFavAlbums => '즐겨찾는 앨범 없음';

  @override
  String get noFavTracks => '즐겨찾는 트랙 없음';

  @override
  String get settingsTitle => '설정';

  @override
  String get server => '서버';

  @override
  String get host => '호스트';

  @override
  String get port => '포트';

  @override
  String get connect => '연결';

  @override
  String get connected => '연결됨';

  @override
  String get disconnected => '연결 안 됨';

  @override
  String get audioOutput => '오디오 출력';

  @override
  String get audioOutputDesc =>
      '각 서버 존은 하나의 출력입니다(로컬 ALSA, Diretta 렌더러…). 재생할 존을 선택하세요.';

  @override
  String get noZones => '사용 가능한 존 없음';

  @override
  String get gapless => '갭리스 재생';

  @override
  String get gaplessDesc => '이 렌더러에서 트랙 사이에 백색 소음/끊김이 있으면 끄세요.';

  @override
  String get metadataFields => '메타데이터 항목';

  @override
  String get metadataFieldsDesc => '로컬 라이브러리에 표시되는 정보';

  @override
  String get streamingQuality => '스트리밍 품질';

  @override
  String get streamingQualityDesc => '서비스(Qobuz, Tidal…)에 요청하는 주파수/해상도를 제한합니다.';

  @override
  String get freqLimit => '주파수 제한';

  @override
  String get qualityMax => '최고';

  @override
  String get qualityHires => 'Hi-Res(최대 192 kHz)';

  @override
  String get qualityCd => 'CD(44.1 kHz / 16비트)';

  @override
  String get maxFrequency => '최대 주파수';

  @override
  String get maxBitDepth => '최대 비트 심도';

  @override
  String get noLimit => '제한 없음';

  @override
  String get streamingServices => '스트리밍 서비스';

  @override
  String get language => '언어';

  @override
  String get systemLanguage => '시스템';

  @override
  String get nothingPlaying => '재생 중 아님';

  @override
  String get visualizer => '비주얼라이저';

  @override
  String get cover => '커버';

  @override
  String get addFavorite => '즐겨찾기에 추가';

  @override
  String get removeFavorite => '즐겨찾기에서 제거';

  @override
  String favError(String msg) {
    return '즐겨찾기 실패: $msg';
  }

  @override
  String get metadataTitle => '메타데이터 항목';

  @override
  String get metadataSaved => '메타데이터 저장됨';

  @override
  String get localLibrary => '로컬 라이브러리';

  @override
  String get localLibraryDesc => '서버가 음악을 검색하는 폴더';

  @override
  String get musicFolders => '스캔된 폴더';

  @override
  String get addFolder => '폴더 추가';

  @override
  String get noFolders => '구성된 폴더 없음';

  @override
  String get runScan => '라이브러리 스캔';

  @override
  String get scanning => '스캔 중…';

  @override
  String get pickFolder => '폴더 선택';

  @override
  String get addThisFolder => '이 폴더 추가';

  @override
  String get createPlaylist => '재생목록 만들기';

  @override
  String get playlistName => '재생목록 이름';

  @override
  String get create => '만들기';

  @override
  String get addToPlaylist => '재생목록에 추가';

  @override
  String get newPlaylist => '새 재생목록';

  @override
  String get playlistCreated => '재생목록 생성됨';

  @override
  String get addedToPlaylist => '재생목록에 추가됨';

  @override
  String get delete => '삭제';

  @override
  String get deletePlaylist => '재생목록 삭제';

  @override
  String get deletePlaylistConfirm => '이 재생목록을 삭제할까요?';

  @override
  String get playlistDeleted => '재생목록 삭제됨';

  @override
  String get trackRemoved => '재생목록에서 제거됨';

  @override
  String get removeFromPlaylist => '재생목록에서 제거';

  @override
  String get logIn => '로그인';

  @override
  String get logOut => '로그아웃';

  @override
  String get username => '사용자 이름';

  @override
  String get password => '비밀번호';

  @override
  String get cancel => '취소';

  @override
  String get noService => '서비스 없음';

  @override
  String loginTo(String service) {
    return '$service에 로그인';
  }

  @override
  String get authorizeInBrowser => '브라우저에서 액세스를 승인하세요:';

  @override
  String get openAuthPage => '인증 페이지 열기';

  @override
  String get done => '완료했습니다';

  @override
  String get disabled => '비활성화됨';

  @override
  String get navHome => '홈';

  @override
  String get listeningActivity => '청취 활동';

  @override
  String get mostPlayed => '많이 재생';

  @override
  String playsCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n회 재생',
    );
    return '$_temp0';
  }

  @override
  String get lyrics => '가사';

  @override
  String get noLyrics => '이 트랙의 가사가 없습니다';

  @override
  String get syncedLyricsPremium => '동기화 가사는 프리미엄 라이선스가 필요합니다 — 일반 텍스트를 표시합니다.';

  @override
  String get smartRadio => '스마트 라디오';

  @override
  String get smartRadioGenerate => '놀래켜 줘';

  @override
  String get smartRadioHint =>
      '실제로 즐겨 듣는 곡을 바탕으로 라이브러리에서 새 선곡을 만듭니다. 분위기로 고를 수도 있습니다.';

  @override
  String get moodHappy => '행복';

  @override
  String get moodEnergetic => '활기찬';

  @override
  String get moodCalm => '차분한';

  @override
  String get moodFocus => '집중';

  @override
  String get moodRomantic => '로맨틱';

  @override
  String get moodSad => '멜랑콜리';

  @override
  String get remoteAccess => '원격 접속';

  @override
  String get remoteAccessDesc =>
      'Tune Bridge 중계를 통해 집 네트워크 밖에서 이 서버에 접속합니다. 페어링은 집 네트워크에서 한 번만 하면 됩니다.';

  @override
  String get bridgeServerId => '서버 ID';

  @override
  String get bridgeToken => '접속 토큰';

  @override
  String get bridgePair => '원격 접속 사용';

  @override
  String get bridgeUnpair => '로컬 네트워크로 돌아가기';

  @override
  String get bridgeActive => '원격 접속 사용 중';

  @override
  String get bridgeHint => '두 값 모두 서버에서 가져옵니다: 설정 → 원격 접속.';

  @override
  String get discoveryTitle => '서버에 연결';

  @override
  String get discoverySection => '네트워크의 서버';

  @override
  String get discoverySearching => '로컬 네트워크 검색 중…';

  @override
  String discoveryFoundCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '서버 $n대 발견',
    );
    return '$_temp0';
  }

  @override
  String get discoveryNone => 'Tune 서버를 찾을 수 없습니다';

  @override
  String get discoveryNoneHint => '서버가 켜져 있고 이 기기가 같은 Wi-Fi 네트워크에 있는지 확인하세요.';

  @override
  String get discoveryLocalNetworkHint =>
      '로컬 네트워크 접근을 거부하면 iOS는 아무것도 찾지 못하고 알리지도 않습니다. 설정 → Tune Remote → 로컬 네트워크에서 허용한 뒤 다시 검색하세요.';

  @override
  String get discoveryDenied => '네트워크 검색이 거부됨';

  @override
  String get discoveryDeniedHintIos =>
      '설정 → Tune Remote → 로컬 네트워크에서 접근을 허용한 뒤 다시 검색하세요.';

  @override
  String get discoveryDeniedHintAndroid =>
      'Android가 네트워크 검색을 거부했습니다. Wi-Fi를 켜고 비행기 모드를 해제한 뒤 다시 검색하세요.';

  @override
  String get discoveryRetry => '다시 검색';

  @override
  String get discoveryManualToggle => '주소 직접 입력';

  @override
  String get discoveryManualIntro =>
      'VPN 뒤나 다른 서브넷에 있는 서버는 검색되지 않습니다. 주소를 입력하세요.';
}

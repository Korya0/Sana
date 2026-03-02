class ApiConstants {
  ApiConstants._();

  // API URL
  static const String dorarApiUrl = 'https://dorar.net/dorar_api.json';

  // Query Parameters
  static const String queryParamSkey = 'skey';
  static const String queryParamSt = 'st';
  static const String queryParamPage = 'page';
  static const String searchTypeAllWords = 'a';
  static const String keyHadithContent = 'hadithContent';
  static const String keyTh = 'th';
  static const String keyNarrator = 'narrator';
  static const String keyScholar = 'scholar';
  static const String keySource = 'source';
  static const String keyPage = 'page';
  static const String keyJudgment = 'judgment';
  static const String keyAhadith = 'ahadith';
  static const String keyResult = 'result';

  // Nominatim Reverse Geocoding
  static const String nominatimReverseUrl =
      'https://nominatim.openstreetmap.org/reverse';
  static const String queryParamFormat = 'format';
  static const String queryParamLat = 'lat';
  static const String queryParamLon = 'lon';
  static const String queryParamAcceptLanguage = 'accept-language';
  static const String searchFormatJsonv2 = 'jsonv2';

  // Coordinate Keys
  static const String keyLatitude = 'lat';
  static const String keyLongitude = 'lng';
}

class DailyContentKeys {
  const DailyContentKeys._();

  // JSON field keys
  static const String category = 'category';
  static const String dailyHadith = 'dailyHadith';
  static const String dailySunnah = 'dailySunnah';
  static const String header = 'header';
  static const String content = 'content';
  static const String attribution = 'attribution';
  static const String explanation = 'explanation';

  // Category identifiers (used as SharedPreferences key prefixes)
  static const String categoryHadith = 'hadith';
  static const String categorySunnah = 'sunnah';
  static const String categoryAsma = 'asma';
}

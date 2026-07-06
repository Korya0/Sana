class AppAssets {
  const AppAssets._();

  // Audio
  static const String salatAlaNabiSound1 =
      'assets/audio/salat_ala_nabi_sound_1.mp3';

  // Images
  static const String nativeSplash = 'assets/images/native_splash.png';

  // Svgs
  static const String logo = 'assets/svgs/logo.svg';

  // Json
  static const String asmaUlHusna = 'assets/json/asma_ul_husna.json';
  static const String azkar = 'assets/json/azkar.json';
  static const String dailyContent = 'assets/json/daily_content.json';
  static const String prayerStatus = 'assets/json/prayer_status.json';
  static const String religiousEvent = 'assets/json/religious_event.json';
  static const String teachingPrayer = 'assets/json/teaching_prayer.json';

  // Azkar specific
  static const String azkarVersion = 'assets/json/azkar/version.json';
  static const String azkarCategoriesJson = 'assets/json/azkar/categories.json';
  static String azkarCategoryJson(int id) => 'assets/json/azkar/$id.json';
}

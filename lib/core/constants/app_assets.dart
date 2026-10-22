class AppAssets {
  AppAssets._();

  // Svgs
  static const String logo = 'assets/svgs/logo.svg';

  // Azkar
  static const String azkarCategories = 'assets/json/azkar/categories.json';

  /// The category key is also the asset file name: `morning` -> morning.json.
  static String azkarCategory(String key) => 'assets/json/azkar/$key.json';
}

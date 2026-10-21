class AppAssets {
  AppAssets._();

  // Svgs
  static const String logo = 'assets/svgs/logo.svg';

  // Azkar
  static const String azkarCategories = 'assets/json/azkar/categories.json';

  // Azkar category id to asset file name
  static const Map<int, String> azkarCategoryFileNames = <int, String>{
    1: 'after_prayer',
    2: 'morning',
    3: 'evening',
    4: 'sleep',
    5: 'waking_up',
    6: 'ablution',
    7: 'adhan',
    8: 'home',
    9: 'mosque',
    10: 'restroom',
    11: 'food_drink',
    12: 'clothes',
    13: 'fasting',
    14: 'distress_worry',
    15: 'repentance_seeking_forgiveness',
    16: 'praising_allah',
    17: 'marriage',
    18: 'children',
    19: 'sickness',
    20: 'death',
    21: 'funeral',
    22: 'travel',
    23: 'opening_supplication',
  };

  static String azkarCategory(int id) =>
      'assets/json/azkar/${azkarCategoryFileNames[id]}.json';
}

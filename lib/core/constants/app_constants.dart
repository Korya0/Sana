/// Centralized app constants - consolidating all constant values
class AppConstants {
  const AppConstants._();

  // Locale & Formatting
  static const String locale = 'ar';
  static const String timeFormat = 'hh:mm a';

  // App Information
  static const String appName = 'سَـنَـا';

  // URLs
  static const String playStoreUrl =
      'https://play.google.com/store/apps/details?id=com.korya.sana';

  static const String facebookUrl =
      'https://www.facebook.com/profile.php?id=61585568923187';

  static const String tiktokUrl =
      'https://www.tiktok.com/@sana15950?is_from_webapp=1&sender_device=pc';

  // JSON files paths
  static const String dailyHadithsJsonPath = 'assets/json/daily_hadiths.json';
  static const String dailyVersesJsonPath = 'assets/json/daily_verses.json';
  static const String dailySunnahsJsonPath = 'assets/json/daily_sunnahs.json';
}

/// App spacing constants for consistent UI padding/margins
class AppSpacing {
  const AppSpacing._();

  static const double horizontalP18 = 18;
  static const double betweenSections18 = 18;
}

/// App string constants for reusable text
class AppStrings {
  const AppStrings._();

  static const String unknownLocation = 'غير معروف';
}

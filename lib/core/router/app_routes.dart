abstract final class AppRoutes {
  // Splash
  static const String splashPath = '/splash';

  // Main tabs
  static const String homePath = '/home';
  static const String adhkarPath = '/azkar';
  static const String quranPath = '/quran';
  static const String settingsPath = '/settings';

  // Azkar
  static const String azkarCategoryPath = '/azkar/:categoryKey';
  static const String categoryKeyParam = 'categoryKey';
  static const String azkarRemindersPath = '/azkar-reminders';
  static const String customZikrFormPath = '/custom-zikr-form';
  static const String customAzkarListPath = '/custom-azkar-list';
}

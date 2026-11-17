abstract final class AppRoutes {
  // Main tabs
  static const String homeView = '/home';
  static const String adhkarView = '/azkar';
  static const String quranView = '/quran';
  static const String settingsView = '/settings';

  // Azkar tasbeeh
  static const String zikrListView = '/azkar/:categoryKey';
  static const String customAzkarFormView = '/custom-zikr-form';
  static const String customAzkarView = '/custom-azkar-list';
  static const String categoryParam = 'categoryKey';
  static const String tasbeehView = '/tasbeeh';

  // Splash
  static const String splashView = '/splash';
}

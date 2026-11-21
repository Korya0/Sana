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

  // Zakat
  static const String zakatHome = '/zakat';
  static const String zakatCalculate = '/zakat/calculate';
  static const String zakatExplain = '/zakat/explain';
  static const String zakatResult = '/zakat/result';

  // Aliases for compatibility
  static const String zakatHomeView = zakatHome;
  static const String zakatCalculateView = zakatCalculate;
  static const String zakatExplainView = zakatExplain;
  static const String zakatResultView = zakatResult;
}

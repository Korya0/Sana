class AppConstants {
  AppConstants._();

  // Locale
  static const String arLocaleCode = 'ar';

  // Theme
  static const String themeLight = 'light';
  static const String themeDark = 'dark';
  static const String themeSystem = 'system';

  // UI limits
  static const int maxOneLine = 1;
  static const int maxTwoLines = 2;
  static const int maxThreeLines = 3;

  // Touch
  // Unscaled on purpose: this is the accessibility floor, not a design size.
  static const double minTapTarget = 48;

  // Azkar
  static const double azkarCategoryTileAspectRatio = 0.9;
  static const int azkarCategorySkeletonCount = 8;
  static const int azkarListSkeletonCount = 2;
  static const int skeletonZikrRepetitions = 3;
  static const int fontSizeSliderDivisions = 6;

  // Text line heights
  static const double lineHeightQuran = 1.6;
  static const double lineHeightZikr = 1.8;
  static const double lineHeightDialog = 1.5;

  // Animations
  static const Duration hapticGap200ms = Duration(milliseconds: 200);
  static const Duration animationFast200ms = Duration(milliseconds: 200);
  static const Duration animationNormal300ms = Duration(milliseconds: 300);
  static const Duration animationSlow400ms = Duration(milliseconds: 400);
  static const Duration animationSlower500ms = Duration(milliseconds: 500);
  static const Duration toastDuration2s = Duration(seconds: 2);
  static const Duration pressFadeIn70ms = Duration(milliseconds: 70);
  static const Duration pressFadeOut150ms = Duration(milliseconds: 150);
  static const Duration pressMinVisible100ms = Duration(milliseconds: 100);

  // Marquee text
  static const double marqueeSpeedPxPerSecond = 30;
  static const Duration marqueePause1000ms = Duration(seconds: 1);

  // Opacity & scale
  static const double opacityTransparent = 0;
  static const double opacitySubtle = 0.2;
  static const double opacitySoft = 0.3;
  static const double opacityFaint = 0.4;
  static const double opacityMuted = 0.5;
  static const double opacityFull = 1;
  static const double opacityPressed = 0.55;
  static const double opacityDisabled = 0.45;
  static const double scaleCompleted = 0.98;
  static const double scaleNormal = 1;

  // Ratios
  static const double progressStart = 0;
  static const double progressComplete = 1;

  // Azkar behaviour
  static const int counterCompactLimit = 99;
  static const double azkarAutoScrollViewportFraction = 0.45;

  // Elevation
  static const double elevationNone = 0;

  // Input limits
  static const int nameMaxLength = 100;
  static const int emailMaxLength = 254;
  static const int passwordMaxLength = 64;
  static const int phoneMaxLength = 20;
  static const int otpLength = 4;
  static const int passwordWeakLength = 4;
  static const int passwordMediumLength = 8;
}

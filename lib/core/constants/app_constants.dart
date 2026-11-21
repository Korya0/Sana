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
  static const int zikrTextMaxLength = 500;
  static const int zikrVirtueMaxLength = 250;
  static const int targetCountMaxDigits = 4;

  // Touch
  // Unscaled on purpose: this is the accessibility floor, not a design size.
  static const double minTapTarget = 48;

  // Azkar
  static const double azkarCategoryTileAspectRatio = 0.88;
  static const int azkarCategorySkeletonCount = 16;
  static const int azkarListSkeletonCount = 2;
  static const int skeletonZikrRepetitions = 3;
  static const double compactNumberScaleThreshold = 1.3;
  static const Duration customAzkarSkeletonDelay150ms = Duration(
    milliseconds: 150,
  );
  static const int fontSizeSliderDivisions = 6;

  // Tasbeeh
  static const int tasbeehMaxCount = 9999;
  static const int tasbeehTextMaxLength = 500;
  static const int tasbeehBeadCount = 27;

  // Bead arc
  static const double beadArcWidthInset = 5;
  static const double beadArcCenterYRatio = 0.95;
  static const double beadArcRadiusXRatio = 0.42;
  static const double beadArcRadiusYRatio = 0.78;
  static const double beadArcBeadRadiusRatio = 0.9;

  // Text line heights
  static const double lineHeightCompact = 1;
  static const double lineHeightQuran = 1.6;
  static const double lineHeightZikr = 1.8;
  static const double lineHeightDialog = 1.5;

  // Animations
  static const Duration hapticGap200ms = Duration(milliseconds: 200);
  static const Duration animationFast200ms = Duration(milliseconds: 200);
  static const Duration animationNormal300ms = Duration(milliseconds: 300);
  static const Duration animationSlow400ms = Duration(milliseconds: 400);
  static const Duration animationSlower500ms = Duration(milliseconds: 500);
  static const Duration tasbeehGaugeFill1400ms = Duration(milliseconds: 1400);
  static const Duration tasbeehCountUp1500ms = Duration(milliseconds: 1500);
  static const Duration toastDuration2s = Duration(seconds: 2);
  static const Duration pressFadeIn70ms = Duration(milliseconds: 70);
  static const Duration pressFadeOut150ms = Duration(milliseconds: 150);
  static const Duration pressMinVisible100ms = Duration(milliseconds: 100);
  static const Duration tapCooldown120ms = Duration(milliseconds: 120);

  // Reorder auto scroll
  static const double reorderSpeedPxPerSecond = 1200;
  static const Duration reorderTickFallback16ms = Duration(milliseconds: 16);
  static const Duration reorderTickMax50ms = Duration(milliseconds: 50);
  static const double reorderScrollEpsilon = 0.5;

  // Geometry counts
  static const int boxBorderSides = 2;

  // Marquee text
  static const double marqueeSpeedPxPerSecond = 28;
  static const Duration marqueePause2s = Duration(seconds: 2);
  static const double marqueeBlankRatio = 0.1;

  // Opacity & scale
  static const double opacityTransparent = 0;
  static const double opacityGhost = 0.12;
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
  static const double sheetMaxHeightRatio = 0.4;

  // Azkar behaviour
  static const int counterCompactLimit = 99;
  static const double azkarScrollSearchFraction = 0.45;
  static const double azkarCardFocusAlignment = 0.12;
  static const int azkarScrollMaxSteps = 24;

  // Elevation
  static const double elevationNone = 0;

  // Input limits
  static const int nameMaxLength = 100;
  static const int minTextLength = 3;
}

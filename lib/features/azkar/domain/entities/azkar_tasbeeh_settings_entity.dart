class AzkarTasbeehSettingsEntity {
  // Creates entity
  factory AzkarTasbeehSettingsEntity({
    required double fontSize,
    bool hapticFeedbackEnabled = defaultHapticFeedbackEnabled,
    bool volumeButtonCountEnabled = defaultVolumeButtonCountEnabled,
  }) => AzkarTasbeehSettingsEntity._(
    fontSize: clampFontSize(fontSize),
    hapticFeedbackEnabled: hapticFeedbackEnabled,
    volumeButtonCountEnabled: volumeButtonCountEnabled,
  );

  // Creates internal
  const AzkarTasbeehSettingsEntity._({
    required this.fontSize,
    required this.hapticFeedbackEnabled,
    required this.volumeButtonCountEnabled,
  });

  // Font bounds
  static const double minFontSize = 14;
  static const double maxFontSize = 32;
  static const double defaultFontSize = 20;

  // Haptics
  static const bool defaultHapticFeedbackEnabled = true;

  // Volume buttons — enabled on first open on Android.
  static const bool defaultVolumeButtonCountEnabled = true;

  final double fontSize;
  final bool hapticFeedbackEnabled;
  final bool volumeButtonCountEnabled;

  // Clamps size
  static double clampFontSize(double value) =>
      value.clamp(minFontSize, maxFontSize).toDouble();

  // Copies entity
  AzkarTasbeehSettingsEntity copyWith({
    double? fontSize,
    bool? hapticFeedbackEnabled,
    bool? volumeButtonCountEnabled,
  }) => AzkarTasbeehSettingsEntity(
    fontSize: fontSize ?? this.fontSize,
    hapticFeedbackEnabled: hapticFeedbackEnabled ?? this.hapticFeedbackEnabled,
    volumeButtonCountEnabled:
        volumeButtonCountEnabled ?? this.volumeButtonCountEnabled,
  );
}

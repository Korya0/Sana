class AzkarTasbeehSettingsEntity {
  // Creates entity
  factory AzkarTasbeehSettingsEntity({
    required double fontSize,
    bool hapticFeedbackEnabled = defaultHapticFeedbackEnabled,
  }) => AzkarTasbeehSettingsEntity._(
    fontSize: clampFontSize(fontSize),
    hapticFeedbackEnabled: hapticFeedbackEnabled,
  );

  // Creates internal
  const AzkarTasbeehSettingsEntity._({
    required this.fontSize,
    required this.hapticFeedbackEnabled,
  });

  // Font bounds
  static const double minFontSize = 14;
  static const double maxFontSize = 32;
  static const double defaultFontSize = 20;

  // Haptics
  static const bool defaultHapticFeedbackEnabled = true;

  final double fontSize;
  final bool hapticFeedbackEnabled;

  // Clamps size
  static double clampFontSize(double value) =>
      value.clamp(minFontSize, maxFontSize).toDouble();

  // Copies entity
  AzkarTasbeehSettingsEntity copyWith({
    double? fontSize,
    bool? hapticFeedbackEnabled,
  }) => AzkarTasbeehSettingsEntity(
    fontSize: fontSize ?? this.fontSize,
    hapticFeedbackEnabled: hapticFeedbackEnabled ?? this.hapticFeedbackEnabled,
  );
}

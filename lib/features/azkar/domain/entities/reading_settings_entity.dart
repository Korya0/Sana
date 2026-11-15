class ReadingSettingsEntity {
  // Creates entity
  factory ReadingSettingsEntity({
    required double fontSize,
    bool hapticFeedbackEnabled = defaultHapticFeedbackEnabled,
  }) => ReadingSettingsEntity._(
    fontSize: clampFontSize(fontSize),
    hapticFeedbackEnabled: hapticFeedbackEnabled,
  );

  // Creates internal
  const ReadingSettingsEntity._({
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
  ReadingSettingsEntity copyWith({
    double? fontSize,
    bool? hapticFeedbackEnabled,
  }) => ReadingSettingsEntity(
    fontSize: fontSize ?? this.fontSize,
    hapticFeedbackEnabled:
        hapticFeedbackEnabled ?? this.hapticFeedbackEnabled,
  );
}

class ReadingSettingsEntity {
  // Creates entity
  factory ReadingSettingsEntity({required double fontSize}) =>
      ReadingSettingsEntity._(fontSize: clampFontSize(fontSize));

  // Creates internal
  const ReadingSettingsEntity._({required this.fontSize});

  // Font bounds
  static const double minFontSize = 14;
  static const double maxFontSize = 32;
  static const double defaultFontSize = 20;

  final double fontSize;

  // Clamps size
  static double clampFontSize(double value) =>
      value.clamp(minFontSize, maxFontSize).toDouble();

  // Copies entity
  ReadingSettingsEntity copyWith({double? fontSize}) =>
      ReadingSettingsEntity(fontSize: fontSize ?? this.fontSize);
}

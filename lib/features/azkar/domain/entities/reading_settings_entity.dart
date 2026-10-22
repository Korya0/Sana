class ReadingSettingsEntity {
  factory ReadingSettingsEntity({required double fontSize}) =>
      ReadingSettingsEntity._(fontSize: clampFontSize(fontSize));

  const ReadingSettingsEntity._({required this.fontSize});

  // Font bounds
  static const double minFontSize = 14;
  static const double maxFontSize = 32;
  static const double defaultFontSize = 20;

  final double fontSize;

  // Clamps size into bounds
  static double clampFontSize(double value) =>
      value.clamp(minFontSize, maxFontSize).toDouble();

  // Copies with new size
  ReadingSettingsEntity copyWith({double? fontSize}) =>
      ReadingSettingsEntity(fontSize: fontSize ?? this.fontSize);
}

class ReadingSettingsEntity {
  const ReadingSettingsEntity({required this.fontSize});

  final double fontSize;

  // Copies with new size
  ReadingSettingsEntity copyWith({double? fontSize}) =>
      ReadingSettingsEntity(fontSize: fontSize ?? this.fontSize);
}

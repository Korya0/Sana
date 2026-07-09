import 'package:flutter/foundation.dart';
import 'package:sana/features/azkar/data/constants/azkar_constants.dart';

@immutable
class ReadingSettings {
  const ReadingSettings({
    required this.fontSize,
  });

  factory ReadingSettings.defaultSettings() {
    return const ReadingSettings(
      fontSize: AzkarConstants.defaultFontSize,
    );
  }

  final double fontSize;

  ReadingSettings copyWith({
    double? fontSize,
  }) {
    return ReadingSettings(
      fontSize: fontSize ?? this.fontSize,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ReadingSettings && other.fontSize == fontSize;
  }

  @override
  int get hashCode {
    return fontSize.hashCode;
  }
}

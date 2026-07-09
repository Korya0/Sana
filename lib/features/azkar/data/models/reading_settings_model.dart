import 'package:flutter/foundation.dart';
import 'package:sana/features/azkar/data/constants/azkar_constants.dart';

@immutable
class ReadingSettingsModel {
  const ReadingSettingsModel({
    required this.fontSize,
    required this.keepScreenAwake,
    required this.screenReaderEnabled,
  });

  factory ReadingSettingsModel.defaultSettings() {
    return const ReadingSettingsModel(
      fontSize: AzkarConstants.defaultFontSize,
      keepScreenAwake: false,
      screenReaderEnabled: false,
    );
  }

  factory ReadingSettingsModel.fromJson(Map<String, dynamic> json) {
    return ReadingSettingsModel(
      fontSize: (json['fontSize'] as num?)?.toDouble() ??
          AzkarConstants.defaultFontSize,
      keepScreenAwake: json['keepScreenAwake'] as bool? ?? false,
      screenReaderEnabled: json['screenReaderEnabled'] as bool? ?? false,
    );
  }

  final double fontSize;
  final bool keepScreenAwake;
  final bool screenReaderEnabled;

  ReadingSettingsModel copyWith({
    double? fontSize,
    bool? keepScreenAwake,
    bool? screenReaderEnabled,
  }) {
    return ReadingSettingsModel(
      fontSize: fontSize ?? this.fontSize,
      keepScreenAwake: keepScreenAwake ?? this.keepScreenAwake,
      screenReaderEnabled: screenReaderEnabled ?? this.screenReaderEnabled,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fontSize': fontSize,
      'keepScreenAwake': keepScreenAwake,
      'screenReaderEnabled': screenReaderEnabled,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ReadingSettingsModel &&
        other.fontSize == fontSize &&
        other.keepScreenAwake == keepScreenAwake &&
        other.screenReaderEnabled == screenReaderEnabled;
  }

  @override
  int get hashCode {
    return Object.hash(fontSize, keepScreenAwake, screenReaderEnabled);
  }
}

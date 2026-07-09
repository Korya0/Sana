import 'package:flutter/foundation.dart';
import 'package:sana/features/azkar/data/constants/azkar_constants.dart';

@immutable
class ReadingSettingsModel {
  const ReadingSettingsModel({
    required this.fontSize,
  });

  factory ReadingSettingsModel.defaultSettings() {
    return const ReadingSettingsModel(
      fontSize: AzkarConstants.defaultFontSize,
    );
  }

  factory ReadingSettingsModel.fromJson(Map<String, dynamic> json) {
    return ReadingSettingsModel(
      fontSize: (json[AzkarConstants.fontSizeModelKey] as num?)?.toDouble() ??
          AzkarConstants.defaultFontSize,
    );
  }

  final double fontSize;

  ReadingSettingsModel copyWith({
    double? fontSize,
  }) {
    return ReadingSettingsModel(
      fontSize: fontSize ?? this.fontSize,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      AzkarConstants.fontSizeModelKey: fontSize,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ReadingSettingsModel && other.fontSize == fontSize;
  }

  @override
  int get hashCode {
    return fontSize.hashCode;
  }
}

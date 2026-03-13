import 'package:adhan/adhan.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'prayer_display_model.freezed.dart';

@freezed
class PrayerDisplayModel with _$PrayerDisplayModel {
  const factory PrayerDisplayModel({
    required Prayer type,
    required DateTime time,
    required String displayName,
    required bool isCurrent,
    required bool isNext,
    SunnahTimes? sunnahTimes,
    String? hadith,
    Map<String, dynamic>? additionalData,
  }) = _PrayerDisplayModel;
}

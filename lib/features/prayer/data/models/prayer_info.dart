import 'package:adhan/adhan.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'prayer_info.freezed.dart';

@freezed
class PrayerInfo with _$PrayerInfo {
  const factory PrayerInfo({
    required Prayer prayer,
    required DateTime time,
    required String name,
    String? sunnah,
  }) = _PrayerInfo;
}

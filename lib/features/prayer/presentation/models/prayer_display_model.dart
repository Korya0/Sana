import 'package:flutter/foundation.dart';
import 'package:sana/features/prayer/constants/prayer_name_provider.dart';
import 'package:sana/features/prayer/domain/entities/prayer_state_result.dart';
import 'package:sana/features/prayer/domain/entities/prayer_times_entity.dart';
import 'package:sana/features/prayer/domain/entities/prayer_type.dart';
import 'package:sana/features/prayer/domain/entities/sunnah_times_entity.dart';

@immutable
class PrayerDisplayModel {
  const PrayerDisplayModel({
    required this.type,
    required this.time,
    required this.displayName,
    required this.isCurrent,
    required this.isNext,
    this.sunnahTimes,
    this.hadith,
    this.additionalData,
  });

  final PrayerType type;
  final DateTime time;
  final String displayName;
  final bool isCurrent;
  final bool isNext;
  final SunnahTimesEntity? sunnahTimes;
  final String? hadith;
  final Map<String, dynamic>? additionalData;

  static List<PrayerDisplayModel> buildList({
    required PrayerTimesEntity prayerTimes,
    required SunnahTimesEntity sunnahTimes,
    required PrayerStateResult prayerState,
    required DateTime? resolvedNextTime,
    required String locale,
  }) {
    const listTypes = [
      PrayerType.fajr,
      PrayerType.dhuhr,
      PrayerType.asr,
      PrayerType.maghrib,
      PrayerType.isha,
    ];

    return listTypes.map((type) {
      final time = prayerTimes.getTime(type);
      final isNext = type == prayerState.next;

      return PrayerDisplayModel(
        type: type,
        time: (isNext && resolvedNextTime != null) ? resolvedNextTime : time!,
        displayName: PrayerNameProvider.getName(type, locale),
        isCurrent: type == prayerState.current,
        isNext: isNext,
        sunnahTimes: sunnahTimes,
      );
    }).toList();
  }

  PrayerDisplayModel copyWith({
    PrayerType? type,
    DateTime? time,
    String? displayName,
    bool? isCurrent,
    bool? isNext,
    SunnahTimesEntity? sunnahTimes,
    String? hadith,
    Map<String, dynamic>? additionalData,
  }) {
    return PrayerDisplayModel(
      type: type ?? this.type,
      time: time ?? this.time,
      displayName: displayName ?? this.displayName,
      isCurrent: isCurrent ?? this.isCurrent,
      isNext: isNext ?? this.isNext,
      sunnahTimes: sunnahTimes ?? this.sunnahTimes,
      hadith: hadith ?? this.hadith,
      additionalData: additionalData ?? this.additionalData,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! PrayerDisplayModel) return false;
    return type == other.type &&
        time == other.time &&
        displayName == other.displayName &&
        isCurrent == other.isCurrent &&
        isNext == other.isNext &&
        sunnahTimes == other.sunnahTimes &&
        hadith == other.hadith;
  }

  @override
  int get hashCode =>
      type.hashCode ^
      time.hashCode ^
      displayName.hashCode ^
      isCurrent.hashCode ^
      isNext.hashCode ^
      sunnahTimes.hashCode ^
      hadith.hashCode;
}

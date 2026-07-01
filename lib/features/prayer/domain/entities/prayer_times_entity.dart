import 'package:flutter/foundation.dart';
import 'package:sana/features/prayer/domain/entities/prayer_type.dart';

@immutable
class PrayerTimesEntity {
  const PrayerTimesEntity({
    required this.fajr,
    required this.sunrise,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
    required this.date,
  });

  final DateTime fajr;
  final DateTime sunrise;
  final DateTime dhuhr;
  final DateTime asr;
  final DateTime maghrib;
  final DateTime isha;
  final DateTime date;

  DateTime? getTime(PrayerType type) {
    return switch (type) {
      PrayerType.fajr => fajr,
      PrayerType.sunrise => sunrise,
      PrayerType.dhuhr => dhuhr,
      PrayerType.asr => asr,
      PrayerType.maghrib => maghrib,
      PrayerType.isha => isha,
      PrayerType.none => null,
    };
  }

  List<DateTime> get allTimes => [fajr, sunrise, dhuhr, asr, maghrib, isha];

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! PrayerTimesEntity) return false;
    return fajr == other.fajr &&
        sunrise == other.sunrise &&
        dhuhr == other.dhuhr &&
        asr == other.asr &&
        maghrib == other.maghrib &&
        isha == other.isha &&
        date == other.date;
  }

  @override
  int get hashCode =>
      fajr.hashCode ^
      sunrise.hashCode ^
      dhuhr.hashCode ^
      asr.hashCode ^
      maghrib.hashCode ^
      isha.hashCode ^
      date.hashCode;
}

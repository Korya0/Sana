import 'package:sana/features/prayer/data/models/prayer_type.dart';

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
}

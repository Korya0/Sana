// ignore_for_file: avoid_dynamic_calls

import 'dart:convert';
import 'package:adhan/adhan.dart';

class UserPrayerTimesSettings {
  final CalculationMethod method;
  final Madhab madhab;
  final PrayerAdjustments adjustments;

  UserPrayerTimesSettings({
    required this.method,
    required this.madhab,
    required this.adjustments,
  });

  factory UserPrayerTimesSettings.defaultSettings() {
    return UserPrayerTimesSettings(
      method: CalculationMethod.egyptian,
      madhab: Madhab.shafi,
      adjustments: PrayerAdjustments(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'method': method.name,
      'madhab': madhab.name,
      'adjustments': {
        'fajr': adjustments.fajr,
        'sunrise': adjustments.sunrise,
        'dhuhr': adjustments.dhuhr,
        'asr': adjustments.asr,
        'maghrib': adjustments.maghrib,
        'isha': adjustments.isha,
      },
    };
  }

  factory UserPrayerTimesSettings.fromMap(Map<String, dynamic> map) {
    return UserPrayerTimesSettings(
      method: CalculationMethod.values.firstWhere(
        (e) => e.name == map['method'],
        orElse: () => CalculationMethod.egyptian,
      ),
      madhab: Madhab.values.firstWhere(
        (e) => e.name == map['madhab'],
        orElse: () => Madhab.shafi,
      ),
      adjustments: PrayerAdjustments(
        fajr: map['adjustments']['fajr'] ?? 0,
        sunrise: map['adjustments']['sunrise'] ?? 0,
        dhuhr: map['adjustments']['dhuhr'] ?? 0,
        asr: map['adjustments']['asr'] ?? 0,
        maghrib: map['adjustments']['maghrib'] ?? 0,
        isha: map['adjustments']['isha'] ?? 0,
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserPrayerTimesSettings.fromJson(String source) =>
      UserPrayerTimesSettings.fromMap(json.decode(source));
}

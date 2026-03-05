import 'dart:convert';
import 'package:adhan/adhan.dart';
import 'package:sana/core/constants/json_keys.dart';

class UserPrayerTimesSettings {
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

  factory UserPrayerTimesSettings.fromMap(Map<String, dynamic> map) {
    final adjustmentsMap =
        map[JsonKeys.adjustments] as Map<String, dynamic>? ?? {};
    return UserPrayerTimesSettings(
      method: CalculationMethod.values.firstWhere(
        (e) => e.name == map[JsonKeys.method],
        orElse: () => CalculationMethod.egyptian,
      ),
      madhab: Madhab.values.firstWhere(
        (e) => e.name == map[JsonKeys.madhab],
        orElse: () => Madhab.shafi,
      ),
      adjustments: PrayerAdjustments(
        fajr: adjustmentsMap[JsonKeys.fajr] as int? ?? 0,
        sunrise: adjustmentsMap[JsonKeys.sunrise] as int? ?? 0,
        dhuhr: adjustmentsMap[JsonKeys.dhuhr] as int? ?? 0,
        asr: adjustmentsMap[JsonKeys.asr] as int? ?? 0,
        maghrib: adjustmentsMap[JsonKeys.maghrib] as int? ?? 0,
        isha: adjustmentsMap[JsonKeys.isha] as int? ?? 0,
      ),
    );
  }

  factory UserPrayerTimesSettings.fromJson(String source) =>
      UserPrayerTimesSettings.fromMap(
        json.decode(source) as Map<String, dynamic>,
      );
  final CalculationMethod method;
  final Madhab madhab;
  final PrayerAdjustments adjustments;

  Map<String, dynamic> toMap() {
    return {
      JsonKeys.method: method.name,
      JsonKeys.madhab: madhab.name,
      JsonKeys.adjustments: {
        JsonKeys.fajr: adjustments.fajr,
        JsonKeys.sunrise: adjustments.sunrise,
        JsonKeys.dhuhr: adjustments.dhuhr,
        JsonKeys.asr: adjustments.asr,
        JsonKeys.maghrib: adjustments.maghrib,
        JsonKeys.isha: adjustments.isha,
      },
    };
  }

  String toJson() => json.encode(toMap());
}

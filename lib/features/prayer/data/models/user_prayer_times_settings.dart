import 'dart:convert';
import 'package:adhan/adhan.dart';

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
    final adjustmentsMap = map['adjustments'] as Map<String, dynamic>? ?? {};
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
        fajr: adjustmentsMap['fajr'] as int? ?? 0,
        sunrise: adjustmentsMap['sunrise'] as int? ?? 0,
        dhuhr: adjustmentsMap['dhuhr'] as int? ?? 0,
        asr: adjustmentsMap['asr'] as int? ?? 0,
        maghrib: adjustmentsMap['maghrib'] as int? ?? 0,
        isha: adjustmentsMap['isha'] as int? ?? 0,
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

  String toJson() => json.encode(toMap());
}

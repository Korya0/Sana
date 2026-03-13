import 'dart:convert';
import 'package:adhan/adhan.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sana/features/prayer/data/constants/prayer_settings_keys.dart';

part 'user_prayer_times_settings.freezed.dart';

@freezed
class UserPrayerTimesSettings with _$UserPrayerTimesSettings {
  const factory UserPrayerTimesSettings({
    required CalculationMethod method,
    required Madhab madhab,
    required PrayerAdjustments adjustments,
  }) = _UserPrayerTimesSettings;

  const UserPrayerTimesSettings._();

  factory UserPrayerTimesSettings.defaultSettings() {
    return UserPrayerTimesSettings(
      method: CalculationMethod.egyptian,
      madhab: Madhab.shafi,
      adjustments: PrayerAdjustments(),
    );
  }

  factory UserPrayerTimesSettings.fromMap(Map<String, dynamic> map) {
    final adjustmentsMap =
        map[PrayerSettingsKeys.adjustments] as Map<String, dynamic>? ?? {};
    return UserPrayerTimesSettings(
      method: CalculationMethod.values.firstWhere(
        (e) => e.name == map[PrayerSettingsKeys.method],
        orElse: () => CalculationMethod.egyptian,
      ),
      madhab: Madhab.values.firstWhere(
        (e) => e.name == map[PrayerSettingsKeys.madhab],
        orElse: () => Madhab.shafi,
      ),
      adjustments: PrayerAdjustments(
        fajr: adjustmentsMap[PrayerSettingsKeys.fajr] as int? ?? 0,
        sunrise: adjustmentsMap[PrayerSettingsKeys.sunrise] as int? ?? 0,
        dhuhr: adjustmentsMap[PrayerSettingsKeys.dhuhr] as int? ?? 0,
        asr: adjustmentsMap[PrayerSettingsKeys.asr] as int? ?? 0,
        maghrib: adjustmentsMap[PrayerSettingsKeys.maghrib] as int? ?? 0,
        isha: adjustmentsMap[PrayerSettingsKeys.isha] as int? ?? 0,
      ),
    );
  }

  factory UserPrayerTimesSettings.fromRawJson(String source) =>
      UserPrayerTimesSettings.fromMap(
        json.decode(source) as Map<String, dynamic>,
      );

  Map<String, dynamic> toMap() {
    return {
      PrayerSettingsKeys.method: method.name,
      PrayerSettingsKeys.madhab: madhab.name,
      PrayerSettingsKeys.adjustments: {
        PrayerSettingsKeys.fajr: adjustments.fajr,
        PrayerSettingsKeys.sunrise: adjustments.sunrise,
        PrayerSettingsKeys.dhuhr: adjustments.dhuhr,
        PrayerSettingsKeys.asr: adjustments.asr,
        PrayerSettingsKeys.maghrib: adjustments.maghrib,
        PrayerSettingsKeys.isha: adjustments.isha,
      },
    };
  }

  String toJsonString() => json.encode(toMap());
}

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:sana/features/prayer/constants/prayer_settings_keys.dart';
import 'package:sana/features/prayer/data/models/prayer_calculation_settings.dart';

@immutable
class PrayerAdjustmentsEntity {
  const PrayerAdjustmentsEntity({
    this.fajr = 0,
    this.sunrise = 0,
    this.dhuhr = 0,
    this.asr = 0,
    this.maghrib = 0,
    this.isha = 0,
  });

  final int fajr;
  final int sunrise;
  final int dhuhr;
  final int asr;
  final int maghrib;
  final int isha;

  PrayerAdjustmentsEntity copyWith({
    int? fajr,
    int? sunrise,
    int? dhuhr,
    int? asr,
    int? maghrib,
    int? isha,
  }) {
    return PrayerAdjustmentsEntity(
      fajr: fajr ?? this.fajr,
      sunrise: sunrise ?? this.sunrise,
      dhuhr: dhuhr ?? this.dhuhr,
      asr: asr ?? this.asr,
      maghrib: maghrib ?? this.maghrib,
      isha: isha ?? this.isha,
    );
  }

  Map<String, int> toMap() {
    return {
      PrayerSettingsKeys.fajr: fajr,
      PrayerSettingsKeys.sunrise: sunrise,
      PrayerSettingsKeys.dhuhr: dhuhr,
      PrayerSettingsKeys.asr: asr,
      PrayerSettingsKeys.maghrib: maghrib,
      PrayerSettingsKeys.isha: isha,
    };
  }
}

@immutable
class UserPrayerTimesSettings {
  const UserPrayerTimesSettings({
    required this.method,
    required this.madhab,
    required this.adjustments,
  });

  factory UserPrayerTimesSettings.defaultSettings() {
    return const UserPrayerTimesSettings(
      method: CalculationMethodEntity.egyptian,
      madhab: MadhabEntity.shafi,
      adjustments: PrayerAdjustmentsEntity(),
    );
  }

  factory UserPrayerTimesSettings.fromMap(Map<String, dynamic> map) {
    final adjustmentsMap =
        map[PrayerSettingsKeys.adjustments] as Map<String, dynamic>? ?? {};
    return UserPrayerTimesSettings(
      method: CalculationMethodEntity.values.firstWhere(
        (e) => e.name == map[PrayerSettingsKeys.method],
        orElse: () => CalculationMethodEntity.egyptian,
      ),
      madhab: MadhabEntity.values.firstWhere(
        (e) => e.name == map[PrayerSettingsKeys.madhab],
        orElse: () => MadhabEntity.shafi,
      ),
      adjustments: PrayerAdjustmentsEntity(
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

  final CalculationMethodEntity method;
  final MadhabEntity madhab;
  final PrayerAdjustmentsEntity adjustments;

  Map<String, dynamic> toMap() {
    return {
      PrayerSettingsKeys.method: method.name,
      PrayerSettingsKeys.madhab: madhab.name,
      PrayerSettingsKeys.adjustments: adjustments.toMap(),
    };
  }

  String toJsonString() => json.encode(toMap());

  UserPrayerTimesSettings copyWith({
    CalculationMethodEntity? method,
    MadhabEntity? madhab,
    PrayerAdjustmentsEntity? adjustments,
  }) {
    return UserPrayerTimesSettings(
      method: method ?? this.method,
      madhab: madhab ?? this.madhab,
      adjustments: adjustments ?? this.adjustments,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserPrayerTimesSettings &&
          runtimeType == other.runtimeType &&
          method == other.method &&
          madhab == other.madhab &&
          adjustments == other.adjustments;

  @override
  int get hashCode => method.hashCode ^ madhab.hashCode ^ adjustments.hashCode;
}

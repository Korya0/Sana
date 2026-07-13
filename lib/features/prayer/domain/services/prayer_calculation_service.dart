import 'package:adhan/adhan.dart';
import 'package:sana/features/prayer/domain/entities/coordinates_entity.dart';
import 'package:sana/features/prayer/domain/entities/prayer_calculation_settings_entity.dart';
import 'package:sana/features/prayer/domain/entities/prayer_times_entity.dart';
import 'package:sana/features/prayer/domain/entities/prayer_type.dart';
import 'package:sana/features/prayer/domain/entities/user_prayer_times_settings_entity.dart';

/// Pure domain service that wraps the adhan astronomical library.
///
/// Consumers depend on [PrayerCalculationService] instead of the adhan
/// library directly, keeping domain entities and library types decoupled.
class PrayerCalculationService {
  const PrayerCalculationService();

  /// Calculates prayer times for the given coordinates, date, and settings.
  PrayerTimesEntity calculatePrayerTimes({
    required CoordinatesModel coordinates,
    required DateTime date,
    required CalculationMethodEntity method,
    required MadhabEntity madhab,
    required PrayerAdjustmentsEntity adjustments,
  }) {
    final adhanCoords = Coordinates(coordinates.latitude, coordinates.longitude);
    final params = _mapCalculationMethod(method).getParameters()
      ..madhab = _mapMadhab(madhab)
      ..adjustments = _toAdhanAdjustments(adjustments);

    final times = PrayerTimes(
      adhanCoords,
      DateComponents.from(date),
      params,
    );

    return PrayerTimesEntity(
      fajr: times.fajr,
      sunrise: times.sunrise,
      dhuhr: times.dhuhr,
      asr: times.asr,
      maghrib: times.maghrib,
      isha: times.isha,
      date: date,
    );
  }

  /// Resolves the time for a specific prayer, checking if it has passed today.
  DateTime? timeForPrayer({
    required PrayerTimesEntity prayerTimes,
    required PrayerType prayer,
    required CoordinatesModel coordinates,
    required CalculationMethodEntity method,
    required MadhabEntity madhab,
    required PrayerAdjustmentsEntity adjustments,
    required DateTime baseDate,
    required DateTime now,
  }) {
    final adhanCoords = Coordinates(coordinates.latitude, coordinates.longitude);
    final params = _mapCalculationMethod(method).getParameters()
      ..madhab = _mapMadhab(madhab)
      ..adjustments = _toAdhanAdjustments(adjustments);

    final times = PrayerTimes(
      adhanCoords,
      DateComponents.from(baseDate),
      params,
    );

    final nextTime = times.timeForPrayer(_toAdhanType(prayer));

    if (nextTime != null && nextTime.isBefore(now)) {
      final tomorrow = baseDate.add(const Duration(days: 1));
      final tomorrowTimes = PrayerTimes(
        adhanCoords,
        DateComponents.from(tomorrow),
        params,
      );
      return tomorrowTimes.timeForPrayer(_toAdhanType(prayer));
    }

    return nextTime;
  }

  CalculationMethod _mapCalculationMethod(CalculationMethodEntity method) {
    return CalculationMethod.values.firstWhere(
      (e) => e.name == method.nameInAdhan,
      orElse: () => CalculationMethod.egyptian,
    );
  }

  Madhab _mapMadhab(MadhabEntity madhab) {
    return Madhab.values.firstWhere(
      (e) => e.name == madhab.nameInAdhan,
      orElse: () => Madhab.shafi,
    );
  }

  PrayerAdjustments _toAdhanAdjustments(PrayerAdjustmentsEntity adj) {
    return PrayerAdjustments(
      fajr: adj.fajr,
      sunrise: adj.sunrise,
      dhuhr: adj.dhuhr,
      asr: adj.asr,
      maghrib: adj.maghrib,
      isha: adj.isha,
    );
  }

  Prayer _toAdhanType(PrayerType type) {
    return switch (type) {
      PrayerType.fajr => Prayer.fajr,
      PrayerType.sunrise => Prayer.sunrise,
      PrayerType.dhuhr => Prayer.dhuhr,
      PrayerType.asr => Prayer.asr,
      PrayerType.maghrib => Prayer.maghrib,
      PrayerType.isha => Prayer.isha,
      PrayerType.none => Prayer.none,
    };
  }
}

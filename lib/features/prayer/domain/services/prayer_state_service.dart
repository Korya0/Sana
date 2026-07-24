import 'package:adhan/adhan.dart';
import 'package:sana/features/prayer/domain/entities/coordinates_entity.dart';
import 'package:sana/features/prayer/domain/entities/prayer_calculation_settings_entity.dart';
import 'package:sana/features/prayer/domain/entities/prayer_state_result.dart';
import 'package:sana/features/prayer/domain/entities/prayer_times_entity.dart';
import 'package:sana/features/prayer/domain/entities/prayer_type.dart';
import 'package:sana/features/prayer/domain/entities/sunnah_times_entity.dart';
import 'package:sana/features/prayer/domain/entities/user_prayer_times_settings_entity.dart';
import 'package:sana/features/prayer/calculators/prayer_time_status_calculator.dart';

/// Interface for prayer state calculation — pure business logic.
abstract interface class PrayerStateService {
  PrayerStateResult calculateState({
    required PrayerTimesEntity prayerTimes,
    required DateTime date,
  });

  DateTime? resolveNextTime({
    required PrayerStateResult state,
    required UserPrayerTimesSettings settings,
    required DateTime baseDate,
    required DateTime now,
    CoordinatesModel? coords,
  });

  SunnahTimesEntity calculateSunnah(PrayerTimesEntity prayerTimes);
}

/// Pure business logic implementation of prayer state calculations.
/// Uses the adhan library for astronomical calculations.
class PrayerStateServiceImpl implements PrayerStateService {
  const PrayerStateServiceImpl();

  @override
  PrayerStateResult calculateState({
    required PrayerTimesEntity prayerTimes,
    required DateTime date,
  }) {
    final current = _calculateCurrentPrayer(prayerTimes, date);
    final next = _calculateNextPrayer(prayerTimes, date);

    final isMainCurrent =
        current != PrayerType.none && current != PrayerType.sunrise;
    final activePrayer = isMainCurrent ? current : next;

    final sunnahTimes = calculateSunnah(prayerTimes);
    final statusId = PrayerTimeStatusCalculator.getStatusId(
      prayerTimes: prayerTimes,
      sunnahTimes: sunnahTimes,
      now: date,
    );

    return PrayerStateResult(
      current: current,
      next: next,
      activePrayer: activePrayer,
      statusId: statusId,
    );
  }

  @override
  DateTime? resolveNextTime({
    required PrayerStateResult state,
    required UserPrayerTimesSettings settings,
    required DateTime baseDate,
    required DateTime now,
    CoordinatesModel? coords,
  }) {
    if (state.next == PrayerType.none) return null;

    final adhanNext = _toAdhanType(state.next);
    // Default to Cairo coordinates if none provided
    final adhanCoords = Coordinates(
      coords?.latitude ?? 30.033333,
      coords?.longitude ?? 31.233334,
    );
    final params = _mapCalculationMethod(settings.method).getParameters()
      ..madhab = _mapMadhab(settings.madhab)
      ..adjustments = _mapAdjustments(settings.adjustments);

    final times = PrayerTimes(
      adhanCoords,
      DateComponents.from(baseDate),
      params,
    );
    final nextTime = times.timeForPrayer(adhanNext);

    if (nextTime != null && nextTime.isBefore(now)) {
      final tomorrow = baseDate.add(const Duration(days: 1));
      final tomorrowTimes = PrayerTimes(
        adhanCoords,
        DateComponents.from(tomorrow),
        params,
      );
      return tomorrowTimes.timeForPrayer(adhanNext);
    }

    return nextTime;
  }

  @override
  SunnahTimesEntity calculateSunnah(PrayerTimesEntity prayerTimes) {
    final nextFajr = prayerTimes.fajr.add(const Duration(hours: 24));
    final nightDuration = nextFajr.difference(prayerTimes.isha);
    final halfNight = nightDuration ~/ 2;
    final twoThirdsNight = Duration(
      seconds: (nightDuration.inSeconds * 2 / 3).round(),
    );

    return SunnahTimesEntity(
      middleOfTheNight: prayerTimes.isha.add(halfNight),
      lastThirdOfTheNight: prayerTimes.isha.add(twoThirdsNight),
    );
  }

  PrayerType _calculateCurrentPrayer(PrayerTimesEntity pt, DateTime now) {
    if (now.isBefore(pt.fajr)) return PrayerType.none;
    if (now.isBefore(pt.sunrise)) return PrayerType.fajr;
    if (now.isBefore(pt.dhuhr)) return PrayerType.sunrise;
    if (now.isBefore(pt.asr)) return PrayerType.dhuhr;
    if (now.isBefore(pt.maghrib)) return PrayerType.asr;
    if (now.isBefore(pt.isha)) return PrayerType.maghrib;
    return PrayerType.isha;
  }

  PrayerType _calculateNextPrayer(PrayerTimesEntity pt, DateTime now) {
    if (now.isBefore(pt.fajr)) return PrayerType.fajr;
    if (now.isBefore(pt.dhuhr)) return PrayerType.dhuhr;
    if (now.isBefore(pt.asr)) return PrayerType.asr;
    if (now.isBefore(pt.maghrib)) return PrayerType.maghrib;
    if (now.isBefore(pt.isha)) return PrayerType.isha;
    return PrayerType.fajr;
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

  CalculationMethod _mapCalculationMethod(CalculationMethodEntity method) {
    return CalculationMethod.values.firstWhere(
      (e) => e.name == method.name,
      orElse: () => CalculationMethod.egyptian,
    );
  }

  Madhab _mapMadhab(MadhabEntity madhab) {
    return Madhab.values.firstWhere(
      (e) => e.name == madhab.name,
      orElse: () => Madhab.shafi,
    );
  }

  PrayerAdjustments _mapAdjustments(PrayerAdjustmentsEntity adjustments) {
    return PrayerAdjustments(
      fajr: adjustments.fajr,
      sunrise: adjustments.sunrise,
      dhuhr: adjustments.dhuhr,
      asr: adjustments.asr,
      maghrib: adjustments.maghrib,
      isha: adjustments.isha,
    );
  }
}

import 'package:adhan/adhan.dart';
import 'package:sana/features/prayer/data/models/prayer_state_result.dart';
import 'package:sana/features/prayer/data/services/prayer_times_service.dart';
import 'package:sana/features/prayer/utils/prayer_time_status_calculator.dart';

/// Service responsible for calculating the current and next prayer states.
/// Decouples logic from [PrayerTimesService].
class PrayerStateService {
  const PrayerStateService();

  /// Calculates the current prayer state result including current, next,
  /// and spiritual status ID.
  PrayerStateResult calculateState({
    required PrayerTimes prayerTimes,
    required DateTime date,
  }) {
    final currentPrayer = prayerTimes.currentPrayer();
    var nextPrayer = prayerTimes.nextPrayer();

    // Fix: If next prayer is none (after Isha), the next prayer is Fajr.
    if (nextPrayer == Prayer.none) {
      nextPrayer = Prayer.fajr;
    }

    // Determine the "active" prayer name (current if valid, otherwise next)
    final activePrayer = currentPrayer != Prayer.none
        ? currentPrayer
        : nextPrayer;

    // Status calculation (Virtues of the hour)
    final sunnahTimes = SunnahTimes(prayerTimes);
    final statusId = PrayerTimeStatusCalculator.getStatusId(
      prayerTimes: prayerTimes,
      sunnahTimes: sunnahTimes,
      now: date,
    );

    return PrayerStateResult(
      current: currentPrayer,
      next: nextPrayer,
      activePrayer: activePrayer,
      statusId: statusId,
    );
  }

  /// Resolves the actual [DateTime] for the next prayer, handling edge cases
  /// like the transition from Isha to next day's Fajr.
  DateTime? resolveNextTime({
    required PrayerStateResult state,
    required Coordinates coords,
    required CalculationParameters params,
    required DateTime baseDate,
    required DateTime now,
  }) {
    if (state.next == Prayer.none) return null;

    final times = PrayerTimes(coords, DateComponents.from(baseDate), params);
    final nextTime = _getPrayerTime(state.next, from: times);

    // If next prayer time has already passed today (e.g. after Isha, looking for tomorrow's Fajr)
    // or if the prayer library returns a time from earlier today.
    if (nextTime != null && nextTime.isBefore(now)) {
      final tomorrow = baseDate.add(const Duration(days: 1));
      final tomorrowTimes = PrayerTimes(
        coords,
        DateComponents.from(tomorrow),
        params,
      );
      return _getPrayerTime(state.next, from: tomorrowTimes);
    }

    return nextTime;
  }

  DateTime? _getPrayerTime(Prayer prayer, {required PrayerTimes from}) {
    switch (prayer) {
      case Prayer.fajr:
        return from.fajr;
      case Prayer.sunrise:
        return from.sunrise;
      case Prayer.dhuhr:
        return from.dhuhr;
      case Prayer.asr:
        return from.asr;
      case Prayer.maghrib:
        return from.maghrib;
      case Prayer.isha:
        return from.isha;
      case Prayer.none:
        return null;
    }
  }
}

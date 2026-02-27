import 'package:adhan/adhan.dart';
import 'package:sana/features/prayer/data/models/user_prayer_times_settings.dart';

class PrayerTimesService {
  const PrayerTimesService();

  PrayerTimes calculatePrayerTimes({
    required Coordinates coords,
    required UserPrayerTimesSettings settings,
    required DateTime dateTime,
  }) {
    final params = settings.method.getParameters()
      ..madhab = settings.madhab
      ..adjustments = settings.adjustments;

    final dateComponents = DateComponents.from(dateTime);

    return PrayerTimes(coords, dateComponents, params);
  }

  SunnahTimes calculateSunnahTimes({required PrayerTimes prayerTimes}) {
    return SunnahTimes(prayerTimes);
  }

  Prayer getCurrentPrayer(PrayerTimes prayerTimes) {
    final current = prayerTimes.currentPrayer();
    return current == Prayer.none ? Prayer.isha : current;
  }

  Prayer getNextPrayer(PrayerTimes prayerTimes, {required DateTime now}) {
    final next = prayerTimes.nextPrayerByDateTime(now);

    if (next == Prayer.sunrise) {
      return Prayer.dhuhr;
    }

    return next == Prayer.none ? Prayer.fajr : next;
  }

  DateTime getNextPrayerTime(
    PrayerTimes prayerTimes, {
    required DateTime now,
  }) {
    final nextPrayer = getNextPrayer(prayerTimes, now: now);

    DateTime nextTime;

    switch (nextPrayer) {
      case Prayer.fajr:
        nextTime = prayerTimes.fajr;
        if (now.isAfter(prayerTimes.fajr)) {
          nextTime = prayerTimes.fajr.add(const Duration(days: 1));
        }

      case Prayer.sunrise:
        nextTime = prayerTimes.sunrise;
        if (now.isAfter(prayerTimes.sunrise)) {
          nextTime = prayerTimes.sunrise.add(const Duration(days: 1));
        }

      case Prayer.dhuhr:
        nextTime = prayerTimes.dhuhr;
        if (now.isAfter(prayerTimes.dhuhr)) {
          nextTime = prayerTimes.dhuhr.add(const Duration(days: 1));
        }

      case Prayer.asr:
        nextTime = prayerTimes.asr;
        if (now.isAfter(prayerTimes.asr)) {
          nextTime = prayerTimes.asr.add(const Duration(days: 1));
        }

      case Prayer.maghrib:
        nextTime = prayerTimes.maghrib;
        if (now.isAfter(prayerTimes.maghrib)) {
          nextTime = prayerTimes.maghrib.add(const Duration(days: 1));
        }

      case Prayer.isha:
        nextTime = prayerTimes.isha;
        if (now.isAfter(prayerTimes.isha)) {
          nextTime = prayerTimes.isha.add(const Duration(days: 1));
        }

      case Prayer.none:
        return prayerTimes.fajr.add(const Duration(days: 1));
    }

    return nextTime;
  }

  DateTime getPreviousPrayerTime(
    PrayerTimes prayerTimes, {
    required DateTime now,
  }) {
    final nextPrayer = getNextPrayer(prayerTimes, now: now);

    // Determine previous prayer based on the next one
    Prayer previousPrayer;
    switch (nextPrayer) {
      case Prayer.fajr:
        previousPrayer = Prayer.isha;
      case Prayer.sunrise:
        previousPrayer = Prayer.fajr;
      case Prayer.dhuhr:
        previousPrayer = Prayer.sunrise;
      case Prayer.asr:
        previousPrayer = Prayer.dhuhr;
      case Prayer.maghrib:
        previousPrayer = Prayer.asr;
      case Prayer.isha:
        previousPrayer = Prayer.maghrib;
      case Prayer.none:
        previousPrayer = Prayer.fajr;
    }

    DateTime previousTime;
    switch (previousPrayer) {
      case Prayer.fajr:
        previousTime = prayerTimes.fajr;
      case Prayer.sunrise:
        previousTime = prayerTimes.sunrise;
      case Prayer.dhuhr:
        previousTime = prayerTimes.dhuhr;
      case Prayer.asr:
        previousTime = prayerTimes.asr;
      case Prayer.maghrib:
        previousTime = prayerTimes.maghrib;
      case Prayer.isha:
        previousTime = prayerTimes.isha;
      case Prayer.none:
        previousTime = prayerTimes.fajr;
    }

    if (previousTime.isAfter(now)) {
      previousTime = previousTime.subtract(const Duration(days: 1));
    }

    return previousTime;
  }

  PrayerState calculatePrayerStateWithDetails({
    required PrayerTimes prayerTimes,
    required DateTime now,
  }) {
    var currentPrayerType = Prayer.none;
    var nextPrayerType = Prayer.none;
    DateTime? nextPrayerTime;

    final prayerTypes = [
      Prayer.fajr,
      Prayer.dhuhr,
      Prayer.asr,
      Prayer.maghrib,
      Prayer.isha,
    ];

    // Check each prayer to find where 'now' fits
    for (var i = 0; i < prayerTypes.length; i++) {
      final prayer = prayerTypes[i];
      final time = getPrayerTime(prayerTimes, prayer);

      if (now.isBefore(time)) {
        nextPrayerType = prayer;
        nextPrayerTime = time;
        if (i > 0) {
          currentPrayerType = prayerTypes[i - 1];
        } else {
          currentPrayerType = Prayer.isha;
        }
        break;
      }
    }

    // If no next prayer found (after Isha), next is tomorrow Fajr
    if (nextPrayerType == Prayer.none) {
      currentPrayerType = Prayer.isha;
      nextPrayerType = Prayer.fajr;
    }

    return PrayerState(
      currentPrayer: currentPrayerType,
      nextPrayer: nextPrayerType,
      nextPrayerTime: nextPrayerTime,
    );
  }

  DateTime getPrayerTime(PrayerTimes prayerTimes, Prayer prayer) {
    switch (prayer) {
      case Prayer.fajr:
        return prayerTimes.fajr;
      case Prayer.sunrise:
        return prayerTimes.sunrise;
      case Prayer.dhuhr:
        return prayerTimes.dhuhr;
      case Prayer.asr:
        return prayerTimes.asr;
      case Prayer.maghrib:
        return prayerTimes.maghrib;
      case Prayer.isha:
        return prayerTimes.isha;
      case Prayer.none:
        // Returning a fixed epoch or some fallback instead of now to stay pure
        return DateTime.fromMillisecondsSinceEpoch(0);
    }
  }
}

class PrayerState {
  PrayerState({
    required this.currentPrayer,
    required this.nextPrayer,
    this.nextPrayerTime,
  });
  final Prayer currentPrayer;
  final Prayer nextPrayer;
  final DateTime? nextPrayerTime;
}

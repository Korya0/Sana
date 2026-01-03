import 'package:adhan/adhan.dart';
import 'package:sana/core/services/sharedpref/pref_keys.dart';
import 'package:sana/core/services/sharedpref/shared_pref.dart';
import 'package:sana/features/prayer/data/models/user_prayer_times_settings.dart';

class PrayerTimesService {
  final SharedPref sharedPref;

  PrayerTimesService({required this.sharedPref});

  Coordinates getCoordinates() {
    // Default to Cairo, Egypt if no location found
    final lat = sharedPref.getDouble(PrefKeys.latitude) ?? 30.033333;
    final lng = sharedPref.getDouble(PrefKeys.longitude) ?? 31.233334;
    return Coordinates(lat, lng);
  }

  PrayerTimes calculatePrayerTimes({
    required Coordinates coords,
    required UserPrayerTimesSettings settings,
    required DateTime dateTime,
  }) {
    final params = settings.method.getParameters()
      ..madhab = settings.madhab
      ..adjustments = settings.adjustments;

    final dt = dateTime;
    final dateComponents = DateComponents.from(dt);

    return PrayerTimes(coords, dateComponents, params);
  }

  SunnahTimes calculateSunnahTimes({required PrayerTimes prayerTimes}) {
    return SunnahTimes(prayerTimes);
  }

  Prayer getCurrentPrayer(PrayerTimes prayerTimes) {
    final current = prayerTimes.currentPrayer();
    return current == Prayer.none ? Prayer.isha : current;
  }

  Prayer getNextPrayer(PrayerTimes prayerTimes, {required DateTime time}) {
    final now = time;
    final next = prayerTimes.nextPrayerByDateTime(now);

    if (next == Prayer.sunrise) {
      return Prayer.dhuhr;
    }

    return next == Prayer.none ? Prayer.fajr : next;
  }

  DateTime getNextPrayerTime(
    PrayerTimes prayerTimes, {
    required DateTime time,
  }) {
    final now = time;
    final nextPrayer = getNextPrayer(prayerTimes, time: now);

    DateTime nextTime;

    switch (nextPrayer) {
      case Prayer.fajr:
        nextTime = prayerTimes.fajr;
        // If current time is after today's Fajr and the next prayer is theoretically Fajr,
        // it effectively means tomorrow's Fajr.
        // However, standard adhan logic usually returns the *next* occurrence.
        // If 'now' is 9 PM, Fajr (today) is past. Next Fajr is tomorrow.
        if (now.isAfter(prayerTimes.fajr)) {
          nextTime = prayerTimes.fajr.add(const Duration(days: 1));
        }
        break;

      case Prayer.sunrise:
        nextTime = prayerTimes.sunrise;
        // Assuming sunrise is only 'next' if we haven't filtered it out or if we want to show it.
        // Based on user request to remove sunrise from 'next', this might not be hit if getNextPrayer skips it.
        if (now.isAfter(prayerTimes.sunrise)) {
          nextTime = prayerTimes.sunrise.add(const Duration(days: 1));
        }
        break;

      case Prayer.dhuhr:
        nextTime = prayerTimes.dhuhr;
        if (now.isAfter(prayerTimes.dhuhr)) {
          nextTime = prayerTimes.dhuhr.add(const Duration(days: 1));
        }
        break;

      case Prayer.asr:
        nextTime = prayerTimes.asr;
        if (now.isAfter(prayerTimes.asr)) {
          nextTime = prayerTimes.asr.add(const Duration(days: 1));
        }
        break;

      case Prayer.maghrib:
        nextTime = prayerTimes.maghrib;
        if (now.isAfter(prayerTimes.maghrib)) {
          nextTime = prayerTimes.maghrib.add(const Duration(days: 1));
        }
        break;

      case Prayer.isha:
        nextTime = prayerTimes.isha;
        if (now.isAfter(prayerTimes.isha)) {
          nextTime = prayerTimes.isha.add(const Duration(days: 1));
        }
        break;

      case Prayer.none:
        // Should not happen if we map 'none' to Fajr/Isha in getNextPrayer
        nextTime = prayerTimes.isha;
        break;
    }

    // Safety fallback for 'none' or edge cases
    if (nextPrayer == Prayer.none) {
      // If none, usually means end of day, so next is tomorrow Fajr?
      // getNextPrayer handles this usually.
      return prayerTimes.fajr.add(const Duration(days: 1));
    }

    return nextTime;
  }

  DateTime getPreviousPrayerTime(
    PrayerTimes prayerTimes, {
    required DateTime time,
  }) {
    final now = time;
    final nextPrayer = getNextPrayer(prayerTimes, time: now);

    // Determine previous prayer based on the next one
    Prayer previousPrayer;
    switch (nextPrayer) {
      case Prayer.fajr:
        previousPrayer = Prayer.isha;
        break;
      case Prayer.sunrise:
        previousPrayer = Prayer.fajr;
        break;
      case Prayer.dhuhr:
        previousPrayer =
            Prayer.sunrise; // Or Fajr? Usually Sunrise to Dhuhr sector.
        break;
      case Prayer.asr:
        previousPrayer = Prayer.dhuhr;
        break;
      case Prayer.maghrib:
        previousPrayer = Prayer.asr;
        break;
      case Prayer.isha:
        previousPrayer = Prayer.maghrib;
        break;
      default:
        previousPrayer = Prayer.fajr;
    }

    DateTime previousTime;
    switch (previousPrayer) {
      case Prayer.fajr:
        previousTime = prayerTimes.fajr;
        break;
      case Prayer.sunrise:
        previousTime = prayerTimes.sunrise;
        break;
      case Prayer.dhuhr:
        previousTime = prayerTimes.dhuhr;
        break;
      case Prayer.asr:
        previousTime = prayerTimes.asr;
        break;
      case Prayer.maghrib:
        previousTime = prayerTimes.maghrib;
        break;
      case Prayer.isha:
        previousTime = prayerTimes.isha;
        break;
      case Prayer.none:
        previousTime = prayerTimes.fajr;
        break;
    }

    if (previousTime.isAfter(now)) {
      previousTime = previousTime.subtract(const Duration(days: 1));
    }

    return previousTime;
  }

  PrayerState calculatePrayerStateWithDetails(
    PrayerTimes prayerTimes,
    DateTime now,
  ) {
    Prayer currentPrayerType = Prayer.none;
    Prayer nextPrayerType = Prayer.none;
    DateTime? nextPrayerTime;

    final prayerTypes = [
      Prayer.fajr,
      Prayer.dhuhr,
      Prayer.asr,
      Prayer.maghrib,
      Prayer.isha,
    ];

    // Check each prayer to find where 'now' fits
    for (int i = 0; i < prayerTypes.length; i++) {
      final prayer = prayerTypes[i];
      final time = getPrayerTime(prayerTimes, prayer);

      if (now.isBefore(time)) {
        nextPrayerType = prayer;
        nextPrayerTime = time;
        if (i > 0) {
          currentPrayerType = prayerTypes[i - 1];
        } else {
          // If Fajr is next, current is late night (Isha of previously)
          // Effectively we consider it Isha
          currentPrayerType = Prayer.isha;
        }
        break;
      }
    }

    // If no next prayer found (after Isha), next is tomorrow Fajr
    if (nextPrayerType == Prayer.none) {
      currentPrayerType = Prayer.isha;
      nextPrayerType = Prayer.fajr;
      // The caller acts on nextPrayerTime being null or needs to calculate tomorrow's Fajr
      // We will leave nextPrayerTime null here to let the caller handle tomorrow's calculation
      // OR we can return null to signal "check tomorrow"
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
        return DateTime.now();
    }
  }
}

class PrayerState {
  final Prayer currentPrayer;
  final Prayer nextPrayer;
  final DateTime? nextPrayerTime;

  PrayerState({
    required this.currentPrayer,
    required this.nextPrayer,
    this.nextPrayerTime,
  });
}

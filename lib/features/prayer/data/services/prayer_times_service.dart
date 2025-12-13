import 'package:adhan/adhan.dart';
import 'package:sana/features/prayer/data/models/user_prayer_times_settings.dart';

class PrayerTimesService {
  PrayerTimesService();

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

  Prayer getNextPrayer(PrayerTimes prayerTimes, {DateTime? time}) {
    final now = time ?? DateTime.now();
    final next = prayerTimes.nextPrayerByDateTime(now);
    return next == Prayer.none ? Prayer.fajr : next;
  }

  Duration getCountdownToNextPrayer(PrayerTimes prayerTimes, {DateTime? time}) {
    final now = time ?? DateTime.now();
    final nextPrayer = getNextPrayer(prayerTimes, time: now);

    DateTime nextTime;

    switch (nextPrayer) {
      case Prayer.fajr:
        nextTime = prayerTimes.fajr;
        if (now.isAfter(prayerTimes.fajr)) {
          nextTime = prayerTimes.fajr.add(const Duration(days: 1));
        }
        break;

      case Prayer.sunrise:
        nextTime = prayerTimes.sunrise;
        break;

      case Prayer.dhuhr:
        nextTime = prayerTimes.dhuhr;
        break;

      case Prayer.asr:
        nextTime = prayerTimes.asr;
        break;

      case Prayer.maghrib:
        nextTime = prayerTimes.maghrib;
        break;

      case Prayer.isha:
      case Prayer.none:
        nextTime = prayerTimes.isha;
        if (now.isAfter(prayerTimes.isha)) {
          nextTime = prayerTimes.isha.add(const Duration(days: 1));
        }
        break;
    }

    final remaining = nextTime.difference(now);
    return remaining.isNegative ? Duration.zero : remaining;
  }
}

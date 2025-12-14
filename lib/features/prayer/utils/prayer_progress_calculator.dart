import 'package:adhan/adhan.dart';
import 'package:sana/features/prayer/presentation/cubit/prayer_times_cubit.dart';

double calculateFillProgress(PrayerTimesState state) {
  if (state.countdownNextPrayer.isEmpty || state.prayerTimes == null) {
    return 0.0;
  }

  try {
    final parts = state.countdownNextPrayer.split(':');
    if (parts.length != 3) return 0.0;

    final remainingDuration = Duration(
      hours: int.parse(parts[0]),
      minutes: int.parse(parts[1]),
      seconds: int.parse(parts[2]),
    );

    final now = DateTime.now();
    final nextPrayerTime = now.add(remainingDuration);

    Prayer? previousPrayer;
    if (state.currentPrayer != null && state.currentPrayer != Prayer.none) {
      previousPrayer = state.currentPrayer;
    } else {
      switch (state.nextPrayer) {
        case Prayer.fajr:
          previousPrayer = Prayer.isha;
          break;
        case Prayer.sunrise:
          previousPrayer = Prayer.fajr;
          break;
        case Prayer.dhuhr:
          previousPrayer = Prayer.sunrise;
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
    }

    DateTime? previousPrayerTime;
    if (previousPrayer != null) {
      if (state.nextPrayer == Prayer.dhuhr &&
          previousPrayer == Prayer.sunrise) {
        previousPrayerTime = state.prayerTimes!.sunrise;
      } else {
        previousPrayerTime = state.prayerTimes!.timeForPrayer(previousPrayer);
      }
    }

    if (previousPrayerTime == null) return 0.0;
    if (previousPrayerTime.isAfter(nextPrayerTime)) {
      previousPrayerTime = previousPrayerTime.subtract(const Duration(days: 1));
    }

    final totalInterval = nextPrayerTime
        .difference(previousPrayerTime)
        .inSeconds;
    final elapsed = now.difference(previousPrayerTime).inSeconds;

    if (totalInterval <= 0) return 0.0;

    double progress = elapsed / totalInterval;
    return progress.clamp(0.0, 1.0);
  } catch (e) {
    return 0.0;
  }
}

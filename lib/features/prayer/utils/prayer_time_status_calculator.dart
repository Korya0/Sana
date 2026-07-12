import 'package:sana/features/prayer/constants/prayer_constants.dart';
import 'package:sana/features/prayer/domain/entities/prayer_times_entity.dart';
import 'package:sana/features/prayer/domain/entities/sunnah_times_entity.dart';

class PrayerTimeStatusCalculator {
  static String getStatusId({
    required PrayerTimesEntity prayerTimes,
    required SunnahTimesEntity sunnahTimes,
    required DateTime now,
  }) {
    if (now.isAfter(prayerTimes.fajr) && now.isBefore(prayerTimes.sunrise)) {
      return 'fajr_after';
    }

    final sunriseEnd = prayerTimes.sunrise.add(PrayerConstants.sunriseEndOffset15m);
    if (now.isAfter(prayerTimes.sunrise) && now.isBefore(sunriseEnd)) {
      return 'sunrise_time';
    }

    final zenithStart = prayerTimes.dhuhr.subtract(PrayerConstants.gracePeriod10m);
    if (now.isAfter(zenithStart) && now.isBefore(prayerTimes.dhuhr)) {
      return 'dhuhr_before';
    }

    final sunsetPrep = prayerTimes.maghrib.subtract(
      PrayerConstants.sunriseEndOffset15m,
    );
    if (now.isAfter(prayerTimes.asr) && now.isBefore(sunsetPrep)) {
      return 'asr_after';
    }

    if (now.isAfter(sunsetPrep) && now.isBefore(prayerTimes.maghrib)) {
      return 'maghrib_before';
    }

    final prayers = [
      prayerTimes.fajr,
      prayerTimes.dhuhr,
      prayerTimes.asr,
      prayerTimes.maghrib,
      prayerTimes.isha,
    ];
    for (final prayerTime in prayers) {
      final diff = now.difference(prayerTime);
      if (diff.inSeconds >= 0 && diff.inMinutes <= 20) {
        return 'between_azan_iqama';
      }
    }

    if (now.isAfter(sunnahTimes.lastThirdOfTheNight) ||
        now.isBefore(prayerTimes.fajr)) {
      return 'last_third_night';
    }

    final dhuhaStart = prayerTimes.sunrise.add(PrayerConstants.dhuhaStartOffset20m);
    final dhuhaEnd = prayerTimes.dhuhr.subtract(PrayerConstants.sunriseEndOffset15m);
    if (now.isAfter(dhuhaStart) && now.isBefore(dhuhaEnd)) {
      return 'dhuha_time';
    }

    return 'default_dhikr';
  }
}

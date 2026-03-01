import 'package:adhan/adhan.dart';

class PrayerTimeStatusCalculator {
  static String getStatusId({
    required PrayerTimes prayerTimes,
    required SunnahTimes sunnahTimes,
    required DateTime now,
  }) {
    // 1. نهي بعد الفجر
    if (now.isAfter(prayerTimes.fajr) && now.isBefore(prayerTimes.sunrise)) {
      return 'fajr_after';
    }

    // 2. نهي عند الشروق
    final sunriseEnd = prayerTimes.sunrise.add(const Duration(minutes: 15));
    if (now.isAfter(prayerTimes.sunrise) && now.isBefore(sunriseEnd)) {
      return 'sunrise_time';
    }

    // 3. نهي قبل الظهر
    final zenithStart = prayerTimes.dhuhr.subtract(const Duration(minutes: 10));
    if (now.isAfter(zenithStart) && now.isBefore(prayerTimes.dhuhr)) {
      return 'dhuhr_before';
    }

    // 4. نهي بعد العصر
    final sunsetPrep = prayerTimes.maghrib.subtract(
      const Duration(minutes: 15),
    );
    if (now.isAfter(prayerTimes.asr) && now.isBefore(sunsetPrep)) {
      return 'asr_after';
    }

    // 5. نهي عند الغروب
    if (now.isAfter(sunsetPrep) && now.isBefore(prayerTimes.maghrib)) {
      return 'maghrib_before';
    }

    // 6. وقت إجابة الدعاء
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

    // 7. فضل قيام الليل
    if (now.isAfter(sunnahTimes.lastThirdOfTheNight) ||
        now.isBefore(prayerTimes.fajr)) {
      return 'last_third_night';
    }

    // 8. وقت صلاة الضحى
    final dhuhaStart = prayerTimes.sunrise.add(const Duration(minutes: 20));
    final dhuhaEnd = prayerTimes.dhuhr.subtract(const Duration(minutes: 15));
    if (now.isAfter(dhuhaStart) && now.isBefore(dhuhaEnd)) {
      return 'dhuha_time';
    }

    // Default: ذكر الله
    return 'default_dhikr';
  }
}

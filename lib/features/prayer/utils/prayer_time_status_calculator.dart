import 'package:adhan/adhan.dart';

class PrayerTimeStatus {
  const PrayerTimeStatus({required this.status, required this.description});
  final String status;
  final String description;
}

class PrayerTimeStatusCalculator {
  static PrayerTimeStatus getStatus(PrayerTimes prayerTimes, DateTime now) {
    final sunnahTimes = SunnahTimes(prayerTimes);
    final isFriday = now.weekday == DateTime.friday;

    // 1. Last Third of Night (Istijabah)
    if (now.isAfter(sunnahTimes.lastThirdOfTheNight) ||
        now.isBefore(prayerTimes.fajr)) {
      return const PrayerTimeStatus(
        status: 'جوف الليل (وقت استجابة)',
        description:
            'ينزل ربنا تبارك وتعالى كل ليلة إلى السماء الدنيا فيقول: هل من داع فأستجيب له؟',
      );
    }

    // 2. Before Fajr (Istighfar)
    final thirtyMinsBeforeFajr = prayerTimes.fajr.subtract(
      const Duration(minutes: 30),
    );
    if (now.isAfter(thirtyMinsBeforeFajr) && now.isBefore(prayerTimes.fajr)) {
      return const PrayerTimeStatus(
        status: 'وقت السحر (استغفار)',
        description: 'وَبِالْأَسْحَارِ هُمْ يَسْتَغْفِرُونَ',
      );
    }

    // 3. Between Azan and Iqama (General logic: first 15 mins after any azan except maybe fajr/maghrib)
    // For simplicity, we can check if it's within 15 mins after Fajr, Dhuhr, Asr, Maghrib, Isha
    final prayers = [
      prayerTimes.fajr,
      prayerTimes.dhuhr,
      prayerTimes.asr,
      prayerTimes.maghrib,
      prayerTimes.isha,
    ];
    for (final prayerTime in prayers) {
      final diff = now.difference(prayerTime);
      if (diff.inSeconds >= 0 && diff.inMinutes <= 15) {
        return const PrayerTimeStatus(
          status: 'بين الأذان والإقامة',
          description: 'الدعاء لا يرد بين الأذان والإقامة',
        );
      }
    }

    // 4. Makruh Times (Simplified)
    // After Fajr until Sunrise
    if (now.isAfter(prayerTimes.fajr) && now.isBefore(prayerTimes.sunrise)) {
      return const PrayerTimeStatus(
        status: 'وقت الأذكار (بعد الفجر)',
        description:
            'من صلى الغداة في جماعة ثم قعد يذكر الله حتى تطلع الشمس...',
      );
    }

    // Near sunset (Last 15 mins before Maghrib)
    final fifteenMinsBeforeMaghrib = prayerTimes.maghrib.subtract(
      const Duration(minutes: 15),
    );
    if (now.isAfter(fifteenMinsBeforeMaghrib) &&
        now.isBefore(prayerTimes.maghrib)) {
      if (isFriday) {
        return const PrayerTimeStatus(
          status: 'آخر ساعة من الجمعة',
          description:
              'ساعة استجابة لا يوافقها عبد مسلم يسأل الله شيئا إلا أعطاه إياه',
        );
      }
    }

    // 5. Friday Specific
    if (isFriday &&
        now.isAfter(prayerTimes.sunrise) &&
        now.isBefore(prayerTimes.dhuhr)) {
      return const PrayerTimeStatus(
        status: 'يوم الجمعة',
        description: 'أكثروا من الصلاة عليَّ يوم الجمعة وليلة الجمعة',
      );
    }

    return const PrayerTimeStatus(
      status: 'ذكر الله تعالى',
      description: 'ألا بذكر الله تطمئن القلوب',
    );
  }
}

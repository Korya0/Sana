import 'package:adhan/adhan.dart';

class PrayerTimeStatus {
  const PrayerTimeStatus({
    required this.status,
    required this.description,
    this.source,
  });
  final String status;
  final String description;
  final String? source;
}

class PrayerTimeStatusCalculator {
  static PrayerTimeStatus getStatus({
    required PrayerTimes prayerTimes,
    required SunnahTimes sunnahTimes,
    required DateTime now,
  }) {
    // 1. Prohibited Prayer Times (Rising and Setting Sun)
    final sunriseEnd = prayerTimes.sunrise.add(const Duration(minutes: 15));
    final sunsetStart = prayerTimes.maghrib.subtract(
      const Duration(minutes: 15),
    );

    if ((now.isAfter(prayerTimes.sunrise) && now.isBefore(sunriseEnd)) ||
        (now.isAfter(sunsetStart) && now.isBefore(prayerTimes.maghrib))) {
      return const PrayerTimeStatus(
        status: 'أوقات النهي عن الصلاة',
        description:
            'سَمِعْتُ النبيَّ صَلَّى اللهُ عليه وسلَّمَ يَنْهَى عِنِ الصَّلَاةِ عِنْدَ طُلُوعِ الشَّمْسِ، وعِنْدَ غُرُوبِهَا.',
        source:
            'الراوي : عبدالله بن عمر | المحدث : البخاري | المصدر : صحيح البخاري',
      );
    }

    // 2. Between Azan and Iqama (Istijabah)
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
        return const PrayerTimeStatus(
          status: 'بين الأذان والإقامة',
          description: 'الدعاءُ لا يُرَدُّ بين الأذانِ و الإقامةِ.',
          source:
              'الراوي : أنس بن مالك | المحدث : السيوطي | المصدر : الجامع الصغير',
        );
      }
    }

    // 3. Jawf al-Layl (Best Prayer after Obligatory)
    if (now.isAfter(sunnahTimes.lastThirdOfTheNight) ||
        now.isBefore(prayerTimes.fajr)) {
      return const PrayerTimeStatus(
        status: 'جوف الليل',
        description:
            'سُئِلَ [أي النبي صلى الله عليه وسلم]: أَيُّ الصَّلَاةِ أَفْضَلُ بَعْدَ المَكْتُوبَةِ؟ وَأَيُّ الصِّيَامِ أَفْضَلُ بَعْدَ شَهْرِ رَمَضَانَ؟ فَقالَ: أَفْضَلُ الصَّلَاةِ بَعْدَ الصَّلَاةِ المَكْتُوبَةِ الصَّلَاةُ في جَوْفِ اللَّيْلِ، وَأَفْضَلُ الصِّيَامِ بَعْدَ شَهْرِ رَمَضَانَ صِيَامُ شَهْرِ اللهِ المُحَرَّمِ.',
        source: 'الراوي : أبو هريرة | المحدث : مسلم | المصدر : صحيح مسلم',
      );
    }

    // 4. Dhuha Prayer Time
    final dhuhaStart = prayerTimes.sunrise.add(const Duration(minutes: 20));
    final dhuhaEnd = prayerTimes.dhuhr.subtract(const Duration(minutes: 15));
    if (now.isAfter(dhuhaStart) && now.isBefore(dhuhaEnd)) {
      return const PrayerTimeStatus(
        status: 'وقت صلاة الضحى',
        description:
            'أَوْصَانِي خَلِيلِي بثَلَاثٍ لا أدَعُهُنَّ حتَّى أمُوتَ: صَوْمِ ثَلَاثَةِ أيَّامٍ مِن كُلِّ شَهْرٍ، وصَلَاةِ الضُّحَى، ونَوْمٍ علَى وِتْرٍ.',
        source: 'الراوي : أبو هريرة | المحدث : البخاري | المصدر : صحيح البخاري',
      );
    }

    // 5. Default: Dhikr (All other times)
    return const PrayerTimeStatus(
      status: 'ذكر الله تعالى',
      description:
          'سَبْعَةٌ يُظِلُّهُمُ اللَّهُ: رَجُلٌ ذَكَرَ اللَّهَ فَفاضَتْ عَيْناهُ.',
      source: 'الراوي : أبو هريرة | المحدث : البخاري | المصدر : صحيح البخاري',
    );
  }
}

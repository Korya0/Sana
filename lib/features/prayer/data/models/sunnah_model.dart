import 'package:sana/features/prayer/data/models/prayer_type.dart';

class PrayerSunnah {
  const PrayerSunnah({
    required this.hadith,
    this.rakats,
    this.timing,
  });

  final SunnahHadith hadith;
  final String? rakats;
  final String? timing;

  PrayerSunnah copyWith({
    SunnahHadith? hadith,
    String? rakats,
    String? timing,
  }) {
    return PrayerSunnah(
      hadith: hadith ?? this.hadith,
      rakats: rakats ?? this.rakats,
      timing: timing ?? this.timing,
    );
  }
}

class SunnahHadith {
  const SunnahHadith({
    required this.text,
    required this.narrator,
  });

  final String text;
  final String narrator;

  SunnahHadith copyWith({
    String? text,
    String? narrator,
  }) {
    return SunnahHadith(
      text: text ?? this.text,
      narrator: narrator ?? this.narrator,
    );
  }
}

class SunnahData {
  static const Map<PrayerType, PrayerSunnah> prayers = {
    PrayerType.fajr: PrayerSunnah(
      hadith: SunnahHadith(
        text: 'ركعتا الفجرِ خيرٌ من الدُّنيا وما فيها.',
        narrator:
            'الراوي : عائشة أم المؤمنين | المحدث : الألباني | المصدر : صحيح الترمذي | الصفحة أو الرقم : 416',
      ),
      rakats: 'ركعتان',
      timing: 'قبل الصلاة',
    ),
    PrayerType.dhuhr: PrayerSunnah(
      hadith: SunnahHadith(
        text:
            'كان النبيُّ صلى الله عليه وسلم : يصلِّي قبلَ الظهرِ أربعًا ، وبعدَها ركعتيْن.',
        narrator:
            'الراوي : علي بن أبي طالب | المحدث : الترمذي | المصدر : سنن الترمذي | الصفحة أو الرقم : 424',
      ),
      rakats: '4 ركعات قبل ، 2 ركعة بعد',
      timing: 'قبل وبعد الصلاة',
    ),
    PrayerType.asr: PrayerSunnah(
      hadith: SunnahHadith(
        text:
            'كُنَّا مع بُرَيْدَةَ في غَزْوَةٍ في يَومٍ ذِي غَيْمٍ، فَقَالَ: بَكِّرُوا بصَلَاةِ العَصْرِ؛ فإنَّ النبيَّ صَلَّى اللهُ عليه وسلَّمَ قَالَ: مَن تَرَكَ صَلَاةَ العَصْرِ فقَدْ حَبِطَ عَمَلُهُ.',
        narrator:
            'الراوي : بريدة بن الحصيب الأسلمي | المحدث : البخاري | المصدر : صحيح البخاري | خلاصة حكم المحدث : [صحيح]',
      ),
    ),
    PrayerType.maghrib: PrayerSunnah(
      hadith: SunnahHadith(
        text:
            'كانَ النَّبيُّ صلَّى الله عليْهِ وسلَّمَ يصلِّي المغربَ ، ثمَّ يرجعُ إلى بيتي , فيصلِّي رَكعتين.',
        narrator:
            'الراوي : عائشة أم المؤمنين | المحدث : الألباني | المصدر : صحيح ابن ماجه | الصفحة أو الرقم : 963',
      ),
      rakats: 'ركعتان',
      timing: 'بعد الصلاة',
    ),
    PrayerType.isha: PrayerSunnah(
      hadith: SunnahHadith(
        text:
            'صَلَّيْتُ مع رَسولِ اللهِ صَلَّى اللَّهُ عليه وسلَّمَ قَبْلَ الظُّهْرِ سَجْدَتَيْنِ، وَبَعْدَهَا سَجْدَتَيْنِ، وَبَعْدَ المَغْرِبِ سَجْدَتَيْنِ، وَبَعْدَ العِشَاءِ سَجْدَتَيْنِ.',
        narrator:
            'الراوي : عبدالله بن عمر | المحدث : مسلم | المصدر : صحيح مسلم | الصفحة أو الرقم : 729',
      ),
      rakats: 'ركعتان',
      timing: 'بعد الصلاة',
    ),
  };
}

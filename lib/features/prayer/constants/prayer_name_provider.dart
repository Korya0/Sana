import 'package:sana/core/constants/constants.dart';
import 'package:sana/features/prayer/data/models/prayer_type.dart';

class PrayerNameProvider {
  const PrayerNameProvider._();

  static String getName(PrayerType prayer, String locale) {
    if (locale == 'ar') {
      return _getArabicName(prayer);
    }
    return _getEnglishName(prayer);
  }

  static String _getArabicName(PrayerType prayer) {
    return switch (prayer) {
      PrayerType.fajr => AppStrings.fajr,
      PrayerType.sunrise => AppStrings.sunrise,
      PrayerType.dhuhr => AppStrings.dhuhr,
      PrayerType.asr => AppStrings.asr,
      PrayerType.maghrib => AppStrings.maghrib,
      PrayerType.isha => AppStrings.isha,
      PrayerType.none => '',
    };
  }

  static String _getEnglishName(PrayerType prayer) {
    return switch (prayer) {
      PrayerType.fajr => 'Fajr',
      PrayerType.sunrise => 'Sunrise',
      PrayerType.dhuhr => 'Dhuhr',
      PrayerType.asr => 'Asr',
      PrayerType.maghrib => 'Maghrib',
      PrayerType.isha => 'Isha',
      PrayerType.none => '',
    };
  }
}

import 'package:adhan/adhan.dart';

/// Helper class to provide localized prayer names
class PrayerNameProvider {
  const PrayerNameProvider._();

  /// Returns the localized name for a prayer based on locale
  /// Currently supports 'ar' (Arabic) and defaults to 'en' (English)
  static String getName(Prayer prayer, String locale) {
    if (locale == 'ar') {
      return _getArabicName(prayer);
    }
    return _getEnglishName(prayer);
  }

  static String _getArabicName(Prayer prayer) {
    switch (prayer) {
      case Prayer.fajr:
        return 'الفجر';
      case Prayer.sunrise:
        return 'الشروق';
      case Prayer.dhuhr:
        return 'الظهر';
      case Prayer.asr:
        return 'العصر';
      case Prayer.maghrib:
        return 'المغرب';
      case Prayer.isha:
        return 'العشاء';
      case Prayer.none:
        return '';
    }
  }

  static String _getEnglishName(Prayer prayer) {
    switch (prayer) {
      case Prayer.fajr:
        return 'Fajr';
      case Prayer.sunrise:
        return 'Sunrise';
      case Prayer.dhuhr:
        return 'Dhuhr';
      case Prayer.asr:
        return 'Asr';
      case Prayer.maghrib:
        return 'Maghrib';
      case Prayer.isha:
        return 'Isha';
      case Prayer.none:
        return '';
    }
  }
}

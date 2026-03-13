class ReligiousEventDisplayNames {
  const ReligiousEventDisplayNames._();

  static String getName(String title) {
    switch (title) {
      case 'startHijriYear':
        return 'رأس السنة الهجرية';
      case 'reminderToFastAshura':
        return 'صيام عاشوراء (تذكير)';
      case 'ashura':
        return 'يوم عاشوراء';
      case 'ramadhan':
        return 'شهر رمضان';
      case 'nightOfQadir':
        return 'ليالي القدر';
      case 'EidAl-Fitr':
        return 'عيد الفطر المبارك';
      case 'sexShawwal':
        return 'صيام الست من شوال';
      case 'arafah':
        return 'يوم عرفة';
      case 'tenDaysOfDhul-Hijjah':
        return 'عشر من ذي الحجة';
      case 'EidAl-Adha':
        return 'عيد الأضحى المبارك';
      default:
        return title;
    }
  }
}

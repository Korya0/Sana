import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';

class AppDateFormatter {
  /// Gregorian Short → 11/12/2014
  static String gregorianShort(DateTime date) =>
      '${_two(date.day)}/${_two(date.month)}/${date.year}';

  /// Gregorian Full → الخميس، 11 ديسمبر 2014
  static String gregorianFull(DateTime date, String locale) =>
      DateFormat.yMMMMEEEEd(locale).format(date);

  /// Hijri Short → 20/08/1445
  static String hijriShort(HijriCalendar hijri) =>
      '${_two(hijri.hDay)}/${_two(hijri.hMonth)}/${hijri.hYear}';

  /// Hijri Full → 20 ربيع الأول 1445
  static String hijriFull(HijriCalendar hijri) {
    final monthName = hijri.getLongMonthName(); // دائماً بالعربي
    return '${hijri.hDay} $monthName ${hijri.hYear}';
  }

  /// Helpers
  static String _two(int value) => value.toString().padLeft(2, '0');
}

import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';

class AppDateFormatter {
  AppDateFormatter._();

  /// Gregorian Full → الخميس، 11 ديسمبر 2014
  static String gregorianFull(DateTime date, String locale) =>
      DateFormat.yMMMMEEEEd(locale).format(date);

  /// Hijri Full → 20 ربيع الأول 1445
  static String hijriFull(HijriCalendar hijri) {
    // getLongMonthName returns the month name based on the internal state of HijriCalendar
    final monthName = hijri.getLongMonthName();
    return '${hijri.hDay} $monthName ${hijri.hYear}';
  }
}

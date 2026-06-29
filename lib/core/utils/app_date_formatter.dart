import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';

extension GregorianFormatting on DateTime {
  /// Gregorian Full → الخميس، 11 ديسمبر 2014
  String toGregorianFull(String locale) =>
      DateFormat.yMMMMEEEEd(locale).format(this);
}

extension HijriFormatting on HijriCalendar {
  /// Hijri Full → 20 ربيع الأول 1445
  String toHijriFull() {
    final monthName = getLongMonthName();
    return '$hDay $monthName $hYear';
  }
}

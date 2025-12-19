import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';

/// AppDate
class AppDate {
  final DateTime gregorian;
  final HijriCalendar hijri;

  /// Default → DateTime.now()
  AppDate({DateTime? date})
    : gregorian = date ?? DateTime.now(),
      hijri = HijriCalendar.fromDate(date ?? DateTime.now());

  /// Short Gregorian → 11/12/2014
  String get gregorianShort {
    return '${_two(gregorian.day)}/${_two(gregorian.month)}/${gregorian.year}';
  }

  /// Full Gregorian → الخميس، 11 ديسمبر 2014
  String gregorianFull({String locale = 'ar'}) {
    return DateFormat.yMMMMEEEEd(locale).format(gregorian);
  }

  /// Short Hijri → 20/08/1445
  String get hijriShort {
    return '${_two(hijri.hDay)}/${_two(hijri.hMonth)}/${hijri.hYear}';
  }

  /// Full Hijri → 20 ربيع الأول 1445
  String hijriFull({String locale = 'ar'}) {
    final monthName = hijri.getLongMonthName();
    return '${hijri.hDay} $monthName ${hijri.hYear}';
  }

  /// Helpers
  static String _two(int value) => value.toString().padLeft(2, '0');
}

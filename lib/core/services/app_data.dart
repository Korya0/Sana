import 'package:hijri/hijri_calendar.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class AppDate {
  final DateTime gregorian;
  final HijriCalendar hijri;

  AppDate({DateTime? date})
    : gregorian = date ?? DateTime.now(),
      hijri = HijriCalendar.fromDate(date ?? DateTime.now());

  /// الميلادي طويل: الخميس, 11 ديسمبر 2014
  String gregorianFullString({String locale = 'ar'}) {
    initializeDateFormatting(locale);
    return DateFormat.yMMMMEEEEd(locale).format(gregorian);
  }

  /// هجري طويل: 20 ربيع الأول 1445
  String hijriFullString() {
    final monthName = hijri.getLongMonthName();
    return "${hijri.hDay} $monthName ${hijri.hYear}";
  }

  /// هجري قصير: 20/08/1445
  String get hijriShortString =>
      "${hijri.hDay.toString().padLeft(2, '0')}/${hijri.hMonth.toString().padLeft(2, '0')}/${hijri.hYear}";

  /// الميلادي قصير: 11/12/2014
  String get gregorianShortString =>
      "${gregorian.day.toString().padLeft(2, '0')}/${gregorian.month.toString().padLeft(2, '0')}/${gregorian.year}";
}

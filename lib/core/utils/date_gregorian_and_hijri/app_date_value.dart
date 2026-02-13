import 'package:hijri/hijri_calendar.dart';

class AppDateValue {
  final DateTime gregorian;
  final HijriCalendar hijri;

  AppDateValue({DateTime? date})
    : gregorian = date ?? DateTime.now(),
      hijri = HijriCalendar.fromDate(date ?? DateTime.now());
}

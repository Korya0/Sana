import 'package:hijri/hijri_calendar.dart';

class AppDateValue {

  AppDateValue({DateTime? date})
    : gregorian = date ?? DateTime.now(),
      hijri = HijriCalendar.fromDate(date ?? DateTime.now());
  final DateTime gregorian;
  final HijriCalendar hijri;
}

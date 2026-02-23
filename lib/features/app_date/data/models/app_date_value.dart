import 'package:equatable/equatable.dart';
import 'package:hijri/hijri_calendar.dart';

class AppDateValue extends Equatable {
  AppDateValue({DateTime? date})
    : gregorian = date ?? DateTime.now(),
      hijri = HijriCalendar.fromDate(date ?? DateTime.now());

  final DateTime gregorian;
  final HijriCalendar hijri;

  @override
  List<Object?> get props => [gregorian, hijri];
}

import 'package:equatable/equatable.dart';
import 'package:hijri/hijri_calendar.dart';

class AppDateValue extends Equatable {
  AppDateValue({
    DateTime? date,
    this.adjustment = 0,
    this.isManual = false,
  }) : gregorian = date ?? DateTime.now(),
       hijri = _calculateHijri(date ?? DateTime.now(), adjustment);

  final DateTime gregorian;
  final HijriCalendar hijri;
  final int adjustment;
  final bool isManual;

  static HijriCalendar _calculateHijri(DateTime date, int adj) {
    return HijriCalendar.fromDate(date.add(Duration(days: adj)));
  }

  AppDateValue copyWith({
    DateTime? date,
    int? adjustment,
    bool? isManual,
  }) {
    return AppDateValue(
      date: date ?? gregorian,
      adjustment: adjustment ?? this.adjustment,
      isManual: isManual ?? this.isManual,
    );
  }

  @override
  List<Object?> get props => [gregorian, hijri, adjustment, isManual];
}

import 'package:equatable/equatable.dart';
import 'package:hijri/hijri_calendar.dart';

class AppDateValue extends Equatable {
  factory AppDateValue({DateTime? date, int adjustment = 0}) {
    final effectiveDate = date ?? DateTime.now();
    return AppDateValue._(
      gregorian: effectiveDate,
      hijri: _calculateHijri(effectiveDate, adjustment),
      adjustment: adjustment,
    );
  }

  const AppDateValue._({
    required this.gregorian,
    required this.hijri,
    required this.adjustment,
  });

  final DateTime gregorian;
  final HijriCalendar hijri;
  final int adjustment;

  static HijriCalendar _calculateHijri(DateTime date, int adj) {
    return HijriCalendar.fromDate(date.add(Duration(days: adj)));
  }

  AppDateValue copyWith({DateTime? date, int? adjustment}) {
    return AppDateValue(
      date: date ?? gregorian,
      adjustment: adjustment ?? this.adjustment,
    );
  }

  @override
  List<Object?> get props => [
    gregorian,
    hijri.hDay,
    hijri.hMonth,
    hijri.hYear,
    adjustment,
  ];
}

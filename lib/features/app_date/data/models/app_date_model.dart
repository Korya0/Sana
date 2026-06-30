import 'package:hijri/hijri_calendar.dart';

class AppHijriDate {
  const AppHijriDate({
    required this.year,
    required this.month,
    required this.day,
    required this.monthName,
  });

  final int year;
  final int month;
  final int day;
  final String monthName;

  String toHijriFull() {
    return '$day $monthName $year';
  }
}

class AppDateModel {
  const AppDateModel({
    required this.gregorian,
    required this.hijri,
    required this.adjustment,
  });

  factory AppDateModel.now({int adjustment = 0}) {
    final date = DateTime.now();
    return AppDateModel.fromDate(date, adjustment: adjustment);
  }

  factory AppDateModel.fromDate(DateTime date, {int adjustment = 0}) {
    final hDate = HijriCalendar.fromDate(date.add(Duration(days: adjustment)));
    return AppDateModel(
      gregorian: date,
      hijri: AppHijriDate(
        year: hDate.hYear,
        month: hDate.hMonth,
        day: hDate.hDay,
        monthName: hDate.getLongMonthName(),
      ),
      adjustment: adjustment,
    );
  }

  final DateTime gregorian;
  final AppHijriDate hijri;
  final int adjustment;

  int get hijriMonthId => (hijri.year * 100) + hijri.month;

  AppDateModel copyWith({
    DateTime? gregorian,
    AppHijriDate? hijri,
    int? adjustment,
  }) {
    return AppDateModel(
      gregorian: gregorian ?? this.gregorian,
      hijri: hijri ?? this.hijri,
      adjustment: adjustment ?? this.adjustment,
    );
  }
}

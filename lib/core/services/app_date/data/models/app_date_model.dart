import 'package:hijri/hijri_calendar.dart';

class AppDateModel {
  const AppDateModel({
    required this.gregorian,
    required this.hijri,
    required this.adjustment,
  });

  factory AppDateModel.now({int adjustment = 0}) {
    final date = DateTime.now();
    return AppDateModel(
      gregorian: date,
      hijri: HijriCalendar.fromDate(date.add(Duration(days: adjustment))),
      adjustment: adjustment,
    );
  }

  factory AppDateModel.fromDate(DateTime date, {int adjustment = 0}) {
    return AppDateModel(
      gregorian: date,
      hijri: HijriCalendar.fromDate(date.add(Duration(days: adjustment))),
      adjustment: adjustment,
    );
  }
  final DateTime gregorian;
  final HijriCalendar hijri;
  final int adjustment;

  AppDateModel copyWith({
    DateTime? gregorian,
    HijriCalendar? hijri,
    int? adjustment,
  }) {
    return AppDateModel(
      gregorian: gregorian ?? this.gregorian,
      hijri: hijri ?? this.hijri,
      adjustment: adjustment ?? this.adjustment,
    );
  }
}

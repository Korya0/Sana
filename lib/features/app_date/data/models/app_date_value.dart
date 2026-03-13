import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hijri/hijri_calendar.dart';

part 'app_date_value.freezed.dart';

@freezed
class AppDateValue with _$AppDateValue {
  const factory AppDateValue({
    required DateTime gregorian,
    required HijriCalendar hijri,
    required int adjustment,
  }) = _AppDateValue;

  factory AppDateValue.now({int adjustment = 0}) {
    final date = DateTime.now();
    return AppDateValue(
      gregorian: date,
      hijri: HijriCalendar.fromDate(date.add(Duration(days: adjustment))),
      adjustment: adjustment,
    );
  }

  factory AppDateValue.fromDate(DateTime date, {int adjustment = 0}) {
    return AppDateValue(
      gregorian: date,
      hijri: HijriCalendar.fromDate(date.add(Duration(days: adjustment))),
      adjustment: adjustment,
    );
  }
}

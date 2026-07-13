import 'package:sana/features/app_date/data/models/app_date_model.dart';
import 'package:sana/features/prayer/domain/entities/religious_event_entity.dart';

/// Calculates the number of days between a current Hijri date and a religious event
/// in a future month of the same year.
class CalculateDaysBetweenHijriDatesUseCase {
  const CalculateDaysBetweenHijriDatesUseCase();

  static const int _minDaysInHijriMonth = 29;

  int call(AppHijriDate current, ReligiousEventEntity event) {
    final monthDiff = event.month - current.month;
    return (_minDaysInHijriMonth - current.day) +
        ((monthDiff - 1) * _minDaysInHijriMonth) +
        event.days.first;
  }
}

/// Calculates the number of days from a current Hijri date to a religious event
/// that occurs in a future year.
class CalculateDaysToNextYearEventUseCase {
  const CalculateDaysToNextYearEventUseCase();

  static const int _minDaysInHijriMonth = 29;
  static const int _monthsInHijriYear = 12;

  int call(AppHijriDate current, ReligiousEventEntity event) {
    final monthsLeftThisYear = _monthsInHijriYear - current.month;
    final monthsInNextYear = event.month - 1;
    return (_minDaysInHijriMonth - current.day) +
        (monthsLeftThisYear * _minDaysInHijriMonth) +
        (monthsInNextYear * _minDaysInHijriMonth) +
        event.days.first;
  }
}

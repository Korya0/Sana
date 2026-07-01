import 'package:sana/features/app_date/data/models/app_date_model.dart';
import 'package:sana/features/prayer/domain/entities/religious_event_entity.dart';

/// UseCase: هل المناسبة الدينية تحدث اليوم؟
/// (المنطق الذي كان في ReligiousEventModel.isOccurring)
class IsReligiousEventOccurringUseCase {
  const IsReligiousEventOccurringUseCase();

  bool call(ReligiousEventEntity event, AppHijriDate hijri) {
    return hijri.month == event.month && event.days.contains(hijri.day);
  }
}

/// UseCase: هل المناسبة الدينية لم تأتِ بعد في الشهر/السنة الحالية؟
/// (المنطق الذي كان في ReligiousEventModel.isAfter)
class IsReligiousEventAfterUseCase {
  const IsReligiousEventAfterUseCase();

  bool call(ReligiousEventEntity event, AppHijriDate hijri) {
    if (event.month > hijri.month) return true;
    if (event.month == hijri.month &&
        event.days.isNotEmpty &&
        event.days.first > hijri.day) {
      return true;
    }
    return false;
  }
}

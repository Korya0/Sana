import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:sana/core/constants/constants.dart';
import 'package:sana/core/utils/utils.dart';
import 'package:sana/features/app_date/data/models/app_date_model.dart';
import 'package:sana/features/prayer/domain/entities/religious_event_entity.dart';
import 'package:sana/features/prayer/domain/use_cases/calculate_days_between_hijri_dates_use_case.dart';
import 'package:sana/features/prayer/domain/use_cases/religious_event_use_cases.dart';

abstract interface class IReligiousEventsService {
  Future<void> init();
  Future<ReligiousEventEntity?> getEventForDate(AppHijriDate hijri);
}

List<ReligiousEventEntity> _parseReligiousEventsJson(String jsonString) {
  final jsonData = json.decode(jsonString) as Map<String, dynamic>;
  final list = jsonData['data'] as List<dynamic>;
  return list.map((e) {
    final map = e as Map<String, dynamic>;
    final hadithList = map['hadith'] as List<dynamic>?;
    Map<String, dynamic>? firstHadith;
    if (hadithList != null && hadithList.isNotEmpty) {
      firstHadith = hadithList[0] as Map<String, dynamic>;
    }
    return ReligiousEventEntity(
      id: map['id'] as int,
      title: map['title'] as String,
      month: map['month'] as int,
      days: List<int>.from(map['day'] as List<dynamic>),
      hadithText: firstHadith?['hadith'] as String?,
      bookInfo: firstHadith?['bookInfo'] as String?,
    );
  }).toList();
}

class ReligiousEventsServiceImpl implements IReligiousEventsService {
  ReligiousEventsServiceImpl();

  List<ReligiousEventEntity>? _cachedEvents;

  static const int _maxDaysInHijriYear = 366;
  static const int _upcomingEventThreshold = 7;

  // Use Cases مُعرَّفة مرة واحدة — لا حاجة لإنشاء instance جديدة في كل استدعاء
  static const _isOccurring = IsReligiousEventOccurringUseCase();

  @override
  Future<void> init() async {
    if (_cachedEvents != null) return;
    try {
      final jsonString = await rootBundle.loadString(AppAssets.religiousEvent);
      _cachedEvents = await compute<String, List<ReligiousEventEntity>>(
        _parseReligiousEventsJson,
        jsonString,
      );
      AppLogger.debug('Loaded ${_cachedEvents?.length} religious events');
    } on Object catch (e, stack) {
      unawaited(
        AppLogger.reportToFirebase(
          'Error loading religious events',
          error: e,
          stackTrace: stack,
        ),
      );
      _cachedEvents = [];
    }
  }

  @override
  Future<ReligiousEventEntity?> getEventForDate(AppHijriDate hijri) async {
    if (_cachedEvents == null || _cachedEvents!.isEmpty) return null;

    try {
      // البحث عن مناسبة تحدث اليوم
      final todayEvent = _cachedEvents!
          .where((event) => _isOccurring(event, hijri))
          .firstOrNull;

      if (todayEvent != null) return todayEvent;

      // إن لم يكن اليوم مناسبة، نبحث عن الأقرب قادمة
      ReligiousEventEntity? closestEvent;
      var minDays = _maxDaysInHijriYear;

      for (final event in _cachedEvents!) {
        final eventStartDay = event.days.first;
        final eventMonth = event.month;

        int daysDifference;
        if (eventMonth == hijri.month) {
          if (eventStartDay > hijri.day) {
            daysDifference = eventStartDay - hijri.day;
          } else {
            daysDifference = _calculateDaysToNextYearEvent(hijri, event);
          }
        } else if (eventMonth > hijri.month) {
          daysDifference = _calculateDaysInBetween(hijri, event);
        } else {
          daysDifference = _calculateDaysToNextYearEvent(hijri, event);
        }

        if (daysDifference < minDays) {
          minDays = daysDifference;
          closestEvent = event;
        }
      }

      if (closestEvent != null && minDays <= _upcomingEventThreshold) {
        AppLogger.debug(
          'ReligiousEventsService: Show upcoming event in $minDays days: ${closestEvent.title}',
        );
        return closestEvent;
      }

      return null;
    } on Object catch (e, stack) {
      unawaited(
        AppLogger.localError(
          'ReligiousEventsService: Error in getEventForDate',
          error: e,
          stackTrace: stack,
        ),
      );
      return null;
    }
  }

  int _calculateDaysInBetween(
    AppHijriDate current,
    ReligiousEventEntity event,
  ) {
    return const CalculateDaysBetweenHijriDatesUseCase()(current, event);
  }

  int _calculateDaysToNextYearEvent(
    AppHijriDate current,
    ReligiousEventEntity event,
  ) {
    return const CalculateDaysToNextYearEventUseCase()(current, event);
  }
}

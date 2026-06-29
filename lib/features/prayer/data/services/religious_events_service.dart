import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:sana/core/constants/constants.dart';
import 'package:sana/core/utils/utils.dart';
import 'package:sana/features/prayer/data/models/religious_event_model.dart';

export 'package:sana/features/prayer/data/models/religious_event_model.dart';

abstract class IReligiousEventsService {
  Future<void> init();
  Future<ReligiousEventModel?> getEventForDate(HijriCalendar hijri);
}

List<ReligiousEventModel> _parseReligiousEventsJson(String jsonString) {
  final jsonData = json.decode(jsonString) as Map<String, dynamic>;
  final list = jsonData['data'] as List<dynamic>;
  return list
      .map((e) => ReligiousEventModel.fromJson(e as Map<String, dynamic>))
      .toList();
}

class ReligiousEventsServiceImpl implements IReligiousEventsService {
  ReligiousEventsServiceImpl();

  List<ReligiousEventModel>? _cachedEvents;

  static const int _maxDaysInHijriYear = 366;
  static const int _upcomingEventThreshold = 7;
  static const int _minDaysInHijriMonth = 29;
  static const int _monthsInHijriYear = 12;

  @override
  Future<void> init() async {
    if (_cachedEvents != null) return;
    try {
      final jsonString = await rootBundle.loadString(
        AppAssets.religiousEvent,
      );
      _cachedEvents = await compute<String, List<ReligiousEventModel>>(
        _parseReligiousEventsJson,
        jsonString,
      );
      AppLogger.debug('Loaded ${_cachedEvents?.length} religious events');
    } on Exception catch (e, stack) {
      unawaited(
        AppLogger.error(
          'Error loading religious events',
          error: e,
          stackTrace: stack,
        ),
      );
      _cachedEvents = [];
    }
  }

  @override
  Future<ReligiousEventModel?> getEventForDate(HijriCalendar hijri) async {
    if (_cachedEvents == null || _cachedEvents!.isEmpty) return null;

    try {
      final todayEvent = _cachedEvents!
          .where((event) => event.isOccurring(hijri))
          .firstOrNull;

      if (todayEvent != null) {
        return todayEvent;
      }

      ReligiousEventModel? closestEvent;
      var minDays = _maxDaysInHijriYear;

      for (final event in _cachedEvents!) {
        final eventStartDay = event.days.first;
        final eventMonth = event.month;

        int daysDifference;
        if (eventMonth == hijri.hMonth) {
          if (eventStartDay > hijri.hDay) {
            daysDifference = eventStartDay - hijri.hDay;
          } else {
            daysDifference = _calculateDaysToNextYearEvent(hijri, event);
          }
        } else if (eventMonth > hijri.hMonth) {
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
    } on Exception catch (e, stack) {
      unawaited(
        AppLogger.error(
          'ReligiousEventsService: Error in getEventForDate',
          error: e,
          stackTrace: stack,
        ),
      );
      return null;
    }
  }

  int _calculateDaysInBetween(
    HijriCalendar current,
    ReligiousEventModel event,
  ) {
    final monthDiff = event.month - current.hMonth;
    return (_minDaysInHijriMonth - current.hDay) + 
           ((monthDiff - 1) * _minDaysInHijriMonth) + 
           event.days.first;
  }

  int _calculateDaysToNextYearEvent(
    HijriCalendar current,
    ReligiousEventModel event,
  ) {
    final monthsLeftThisYear = _monthsInHijriYear - current.hMonth;
    final monthsInNextYear = event.month - 1;
    return (_minDaysInHijriMonth - current.hDay) +
        (monthsLeftThisYear * _minDaysInHijriMonth) +
        (monthsInNextYear * _minDaysInHijriMonth) +
        event.days.first;
  }
}

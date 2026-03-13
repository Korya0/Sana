import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:sana/core/constants/generated/assets.gen.dart';
import 'package:sana/core/utils/app_logger.dart';
import 'package:sana/features/prayer/data/models/religious_event_model.dart';

export 'package:sana/features/prayer/data/models/religious_event_model.dart';

class ReligiousEventsService {
  ReligiousEventsService();

  List<ReligiousEventModel>? _cachedEvents;

  Future<void> init() async {
    if (_cachedEvents != null) return;
    try {
      final jsonString = await rootBundle.loadString(
        Assets.json.religiousEvent,
      );
      final jsonData = json.decode(jsonString) as Map<String, dynamic>;
      final list = jsonData['data'] as List<dynamic>;
      _cachedEvents = list
          .map((e) => ReligiousEventModel.fromJson(e as Map<String, dynamic>))
          .toList();
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

  Future<ReligiousEventModel?> getEventForDate(HijriCalendar hijri) async {
    if (_cachedEvents == null || _cachedEvents!.isEmpty) return null;

    try {
      // 1. Check if there's an event TODAY (or currently occurring)
      // This covers multi-day events like Ramadan or Eid
      final todayEvent = _cachedEvents!
          .where((event) => event.isOccurring(hijri))
          .firstOrNull;

      if (todayEvent != null) {
        return todayEvent;
      }

      // 2. Find the CLOSEST UPCOMING event
      // We need to check all events and find the one with the smallest distance
      ReligiousEventModel? closestEvent;
      var minDays = 366; // More than a Hijri year

      for (final event in _cachedEvents!) {
        final eventStartDay = event.days.first;
        final eventMonth = event.month;

        int daysDifference;
        if (eventMonth == hijri.hMonth) {
          if (eventStartDay > hijri.hDay) {
            daysDifference = eventStartDay - hijri.hDay;
          } else {
            // Event in the same month but already passed, belongs to next year
            daysDifference = _calculateDaysToNextYearEvent(hijri, event);
          }
        } else if (eventMonth > hijri.hMonth) {
          daysDifference = _calculateDaysInBetween(hijri, event);
        } else {
          // Event month is before current month, so it's next year
          daysDifference = _calculateDaysToNextYearEvent(hijri, event);
        }

        if (daysDifference < minDays) {
          minDays = daysDifference;
          closestEvent = event;
        }
      }

      // 3. Only return the upcoming event if it's within the next 7 days
      if (closestEvent != null && minDays <= 7) {
        AppLogger.debug(
          'ReligiousEventsService: Show upcoming event in $minDays days: ${closestEvent.title}',
        );
        return closestEvent;
      }

      return null; // No event today and no upcoming events within 7 days
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

  /// Calculates days from [current] to an [event] in the same or future month of the same year
  int _calculateDaysInBetween(
    HijriCalendar current,
    ReligiousEventModel event,
  ) {
    // A simplified estimation for Hijri months (averaging 29.5 days)
    // For 7-day threshold, a simple month-based calculation is sufficient and safe
    final monthDiff = event.month - current.hMonth;
    // Estimated days: (remaining days in current month) + (full months in between) + (days in event month)
    // We'll use 29 as a safe minimum for Hijri month length to avoid showing things too late
    return (29 - current.hDay) + ((monthDiff - 1) * 29) + event.days.first;
  }

  /// Calculates days to an event that will happen in the next Hijri year
  int _calculateDaysToNextYearEvent(
    HijriCalendar current,
    ReligiousEventModel event,
  ) {
    final monthsLeftThisYear = 12 - current.hMonth;
    final monthsInNextYear = event.month - 1;
    return (29 - current.hDay) +
        (monthsLeftThisYear * 29) +
        (monthsInNextYear * 29) +
        event.days.first;
  }
}

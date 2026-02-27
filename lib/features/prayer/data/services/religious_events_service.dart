import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:sana/core/utils/app_logger.dart';
import 'package:sana/features/prayer/domain/models/religious_event_model.dart';

export 'package:sana/features/prayer/domain/models/religious_event_model.dart';

class ReligiousEventsService {
  ReligiousEventsService();

  List<ReligiousEventModel>? _cachedEvents;

  Future<void> init() async {
    if (_cachedEvents != null) return;
    try {
      final jsonString = await rootBundle.loadString(
        'assets/json/religious_event.json',
      );
      final jsonData = json.decode(jsonString) as Map<String, dynamic>;
      final list = jsonData['data'] as List<dynamic>;
      _cachedEvents = list
          .map((e) => ReligiousEventModel.fromJson(e as Map<String, dynamic>))
          .toList();
      AppLogger.debug('Loaded ${_cachedEvents?.length} religious events');
    } catch (e) {
      AppLogger.error('Error loading religious events', error: e);
      _cachedEvents = [];
    }
  }

  ReligiousEventModel? getEventForDate(HijriCalendar hijri) {
    if (_cachedEvents == null) {
      AppLogger.debug(
        'ReligiousEventsService: Cache is empty, check init order',
      );
      return null;
    }
    if (_cachedEvents!.isEmpty) {
      AppLogger.debug('ReligiousEventsService: Cache loaded but empty');
      return null;
    }

    try {
      // 1. Check if there's an event TODAY
      final todayEvent = _cachedEvents!
          .where((event) => event.isOccurring(hijri))
          .firstOrNull;
      if (todayEvent != null) {
        AppLogger.debug(
          'ReligiousEventsService: Found today event: ${todayEvent.title}',
        );
        return todayEvent;
      }

      // 2. If not, find the CLOSEST UPCOMING event in the current month
      final eventsThisMonth = _cachedEvents!
          .where((e) => e.month == hijri.hMonth && e.days.first > hijri.hDay)
          .toList();
      if (eventsThisMonth.isNotEmpty) {
        eventsThisMonth.sort((a, b) => a.days.first.compareTo(b.days.first));
        AppLogger.debug(
          'ReligiousEventsService: Found upcoming in month: ${eventsThisMonth.first.title}',
        );
        return eventsThisMonth.first;
      }

      // 3. Look for the first event in future months
      final futureMonthEvents = _cachedEvents!
          .where((e) => e.month > hijri.hMonth)
          .toList();
      if (futureMonthEvents.isNotEmpty) {
        futureMonthEvents.sort((a, b) => a.month.compareTo(b.month));
        AppLogger.debug(
          'ReligiousEventsService: Found upcoming in future month: ${futureMonthEvents.first.title}',
        );
        return futureMonthEvents.first;
      }

      // 4. Wrap around to the first event of the next Hijri year
      final wrapAroundEvents = List<ReligiousEventModel>.from(_cachedEvents!);
      wrapAroundEvents.sort((a, b) => a.month.compareTo(b.month));
      AppLogger.debug(
        'ReligiousEventsService: Wrapping around to: ${wrapAroundEvents.firstOrNull?.title}',
      );
      return wrapAroundEvents.firstOrNull;
    } catch (e) {
      AppLogger.error(
        'ReligiousEventsService: Error in getEventForDate',
        error: e,
      );
      return null;
    }
  }
}

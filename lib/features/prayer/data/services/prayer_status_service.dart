import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:sana/core/constants/generated/assets.gen.dart';
import 'package:sana/core/utils/app_logger.dart';
import 'package:sana/features/prayer/data/models/prayer_time_status.dart';

List<PrayerTimeStatus> _parsePrayerStatusJson(String jsonString) {
  final jsonData = json.decode(jsonString) as Map<String, dynamic>;
  final list = jsonData['data'] as List<dynamic>;
  return list
      .map((e) => PrayerTimeStatus.fromJson(e as Map<String, dynamic>))
      .toList();
}

class PrayerStatusService {
  PrayerStatusService();

  final Map<String, PrayerTimeStatus> _cachedStatuses = {};

  Future<void> init() async {
    if (_cachedStatuses.isNotEmpty) return;
    try {
      final jsonString = await rootBundle.loadString(
        Assets.json.prayerStatus,
      );
      final statuses = await compute<String, List<PrayerTimeStatus>>(
        _parsePrayerStatusJson,
        jsonString,
      );

      for (final status in statuses) {
        _cachedStatuses[status.id] = status;
      }
      AppLogger.debug('Loaded ${_cachedStatuses.length} prayer statuses');
    } on Exception catch (e, stack) {
      unawaited(
        AppLogger.error(
          'Error loading prayer statuses from JSON',
          error: e,
          stackTrace: stack,
        ),
      );
    }
  }

  PrayerTimeStatus? getStatusById(String id) {
    return _cachedStatuses[id];
  }
}

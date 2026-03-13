import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:sana/core/constants/generated/assets.gen.dart';
import 'package:sana/core/utils/app_logger.dart';
import 'package:sana/features/prayer/data/models/prayer_time_status.dart';

class PrayerStatusService {
  PrayerStatusService();

  final Map<String, PrayerTimeStatus> _cachedStatuses = {};

  Future<void> init() async {
    if (_cachedStatuses.isNotEmpty) return;
    try {
      final jsonString = await rootBundle.loadString(
        Assets.json.prayerStatus,
      );
      final jsonData = json.decode(jsonString) as Map<String, dynamic>;
      final list = jsonData['data'] as List<dynamic>;
      for (final e in list) {
        final status = PrayerTimeStatus.fromJson(e as Map<String, dynamic>);
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

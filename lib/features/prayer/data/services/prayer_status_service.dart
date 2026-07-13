import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:sana/core/constants/constants.dart';
import 'package:sana/core/utils/utils.dart';
import 'package:sana/features/prayer/domain/entities/prayer_time_status.dart';

abstract interface class IPrayerStatusService {
  Future<void> init();
  PrayerTimeStatus? getStatusById(String id);
}

List<PrayerTimeStatus> _parsePrayerStatusJson(String jsonString) {
  final jsonData = json.decode(jsonString) as Map<String, dynamic>;
  final list = jsonData['data'] as List<dynamic>;
  return list
      .map((e) => PrayerTimeStatus.fromJson(e as Map<String, dynamic>))
      .toList();
}

class PrayerStatusServiceImpl implements IPrayerStatusService {
  PrayerStatusServiceImpl();

  final Map<String, PrayerTimeStatus> _cachedStatuses = {};

  @override
  Future<void> init() async {
    if (_cachedStatuses.isNotEmpty) return;
    try {
      final jsonString = await rootBundle.loadString(
        AppAssets.prayerStatus,
      );
      final statuses = await compute<String, List<PrayerTimeStatus>>(
        _parsePrayerStatusJson,
        jsonString,
      );

      for (final status in statuses) {
        _cachedStatuses[status.id] = status;
      }
      AppLogger.debug('Loaded ${_cachedStatuses.length} prayer statuses');
    } on Object catch (e, stack) {
      unawaited(
        AppLogger.reportToFirebase(
          'Error loading prayer statuses from JSON',
          error: e,
          stackTrace: stack,
        ),
      );
    }
  }

  @override
  PrayerTimeStatus? getStatusById(String id) {
    return _cachedStatuses[id];
  }
}

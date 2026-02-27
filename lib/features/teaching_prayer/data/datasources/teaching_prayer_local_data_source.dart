import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:sana/core/constants/app_assets.dart';
import 'package:sana/core/utils/app_logger.dart';
import 'package:sana/features/teaching_prayer/data/models/teaching_prayer_model.dart';

class TeachingPrayerLocalDataSource {
  List<TeachingPrayerSection>? _cachedSections;

  Future<List<TeachingPrayerSection>> getSections() async {
    if (_cachedSections != null) {
      return _cachedSections!;
    }

    try {
      final jsonString = await rootBundle.loadString(
        AppAssetsJson.teachingPrayer,
      );

      final jsonList = json.decode(jsonString) as List<dynamic>;

      _cachedSections = jsonList
          .map((e) => TeachingPrayerSection.fromJson(e as Map<String, dynamic>))
          .toList();

      return _cachedSections!;
    } on Exception catch (e) {
      await AppLogger.error('Error loading Teaching Prayer JSON', error: e);
      return [];
    }
  }
}

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:sana/features/teaching_prayer/data/models/teaching_prayer_model.dart';

class TeachingPrayerLocalDataSource {
  static List<TeachingPrayerSection>? _cachedSections;

  static Future<List<TeachingPrayerSection>> getSections() async {
    if (_cachedSections != null) {
      return _cachedSections!;
    }

    try {
      final jsonString = await rootBundle.loadString(
        'assets/json/teaching_prayer.json',
      );
      final jsonList = json.decode(jsonString) as List<dynamic>;

      // Note: The JSON content might contain raw strings that were previously
      // interpolated with dynamic values (like Sunnah prayer times).
      // However, when we generated the JSON, we essentially "baked in" the values
      // present at generation time (or just the variable names if we didn't execute it).
      // But passing through `jsonEncode` in the test with `SunnahData` access
      // meant the values were evaluated.
      // If we want them to remain dynamic, we would need to store placeholders like
      // "{FAJR_TIME}" and replace them here.
      // Given the previous code used `${SunnahData.prayers['الفجر']!.timing}` directly in the string,
      // the `generate_others_json_test.dart` evaluated those variables at runtime.
      // So the JSON file contains "05:00 AM" (or whatever the time was/is).
      // Since SunnahData is hardcoded constant data, this is perfectly fine.
      // The JSON has the correct static text now.

      _cachedSections = jsonList
          .map((e) => TeachingPrayerSection.fromJson(e as Map<String, dynamic>))
          .toList();

      return _cachedSections!;
    } on Exception catch (e) {
      debugPrint('Error loading Teaching Prayer JSON: $e');
      return [];
    }
  }
}

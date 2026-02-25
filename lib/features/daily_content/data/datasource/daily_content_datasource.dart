import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:sana/features/daily_content/data/models/daily_content_model.dart';

class DailyContentDataSource {
  static const String _jsonPath = 'assets/data/daily_content.json';

  // Cache to avoid multiple I/O and parsing operations
  static Map<String, List<DailyContentModel>>? _cachedContent;

  static Future<Map<String, List<DailyContentModel>>> loadDailyContent() async {
    if (_cachedContent != null) return _cachedContent!;

    final jsonString = await rootBundle.loadString(_jsonPath);
    final jsonData = json.decode(jsonString) as Map<String, dynamic>;

    final hadithList = (jsonData['dailyHadith'] as List<dynamic>)
        .map((item) => DailyContentModel.fromJson(item as Map<String, dynamic>))
        .toList();

    final sunnahList = (jsonData['dailySunnah'] as List<dynamic>)
        .map((item) => DailyContentModel.fromJson(item as Map<String, dynamic>))
        .toList();

    _cachedContent = {'dailyHadith': hadithList, 'dailySunnah': sunnahList};
    return _cachedContent!;
  }
}

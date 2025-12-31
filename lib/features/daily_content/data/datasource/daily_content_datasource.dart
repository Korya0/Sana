import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:sana/features/daily_content/data/models/daily_content_model.dart';

class DailyContentDataSource {
  static const String _jsonPath = 'assets/data/daily_content.json';

  static Future<Map<String, List<DailyContentModel>>> loadDailyContent() async {
    final jsonString = await rootBundle.loadString(_jsonPath);
    final jsonData = json.decode(jsonString) as Map<String, dynamic>;

    final hadithList = (jsonData['dailyHadith'] as List<dynamic>)
        .map((item) => DailyContentModel.fromJson(item as Map<String, dynamic>))
        .toList();

    final sunnahList = (jsonData['dailySunnah'] as List<dynamic>)
        .map((item) => DailyContentModel.fromJson(item as Map<String, dynamic>))
        .toList();

    return {'dailyHadith': hadithList, 'dailySunnah': sunnahList};
  }
}

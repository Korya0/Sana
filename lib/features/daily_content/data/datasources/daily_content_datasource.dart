import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:sana/core/constants/app_assets.dart';
import 'package:sana/core/constants/json_keys.dart';
import 'package:sana/features/daily_content/data/models/daily_content_model.dart';

class DailyContentDataSource {
  static const String _jsonPath = AppAssetsJson.dailyContent;

  // Cache to avoid multiple I/O and parsing operations
  static Map<String, List<DailyContentModel>>? _cachedContent;

  static Future<Map<String, List<DailyContentModel>>> loadDailyContent() async {
    if (_cachedContent != null) return _cachedContent!;

    final jsonString = await rootBundle.loadString(_jsonPath);
    final jsonData = json.decode(jsonString) as Map<String, dynamic>;

    final hadithList = (jsonData[JsonKeys.dailyHadith] as List<dynamic>)
        .map(
          (item) => DailyContentModel.fromJson(
            item as Map<String, dynamic>,
            DailyContentType.hadith,
          ),
        )
        .toList();

    final sunnahList = (jsonData[JsonKeys.dailySunnah] as List<dynamic>)
        .map(
          (item) => DailyContentModel.fromJson(
            item as Map<String, dynamic>,
            DailyContentType.sunnah,
          ),
        )
        .toList();

    _cachedContent = {
      JsonKeys.dailyHadith: hadithList,
      JsonKeys.dailySunnah: sunnahList,
    };
    return _cachedContent!;
  }
}

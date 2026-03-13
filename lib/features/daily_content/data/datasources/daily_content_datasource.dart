import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:sana/core/constants/generated/assets.gen.dart';
import 'package:sana/core/utils/app_logger.dart';
import 'package:sana/features/daily_content/data/constants/daily_content_keys.dart';
import 'package:sana/features/daily_content/data/models/daily_content_model.dart';

class DailyContentDataSource {
  static final String _jsonPath = Assets.json.dailyContent;

  // Cache to avoid multiple I/O and parsing operations
  static Map<String, List<DailyContentModel>>? _cachedContent;

  static Future<Map<String, List<DailyContentModel>>> loadDailyContent() async {
    if (_cachedContent != null) return _cachedContent!;

    try {
      final jsonString = await rootBundle.loadString(_jsonPath);
      final jsonData = json.decode(jsonString) as Map<String, dynamic>;

      final hadithList =
          (jsonData[DailyContentKeys.dailyHadith] as List<dynamic>)
              .map(
                (item) => DailyContentModel.fromJson(
                  item as Map<String, dynamic>,
                  DailyContentType.hadith,
                ),
              )
              .toList();

      final sunnahList =
          (jsonData[DailyContentKeys.dailySunnah] as List<dynamic>)
              .map(
                (item) => DailyContentModel.fromJson(
                  item as Map<String, dynamic>,
                  DailyContentType.sunnah,
                ),
              )
              .toList();

      _cachedContent = {
        DailyContentKeys.dailyHadith: hadithList,
        DailyContentKeys.dailySunnah: sunnahList,
      };
      return _cachedContent!;
    } on Exception catch (e, stack) {
      unawaited(
        AppLogger.error('LoadDailyContent Error', error: e, stackTrace: stack),
      );
      return {};
    }
  }
}

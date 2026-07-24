import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:sana/core/constants/constants.dart';
import 'package:sana/core/utils/utils.dart';
import 'package:sana/features/daily_content/constants/daily_content_keys.dart';
import 'package:sana/features/daily_content/data/models/daily_content_model.dart';

Map<String, List<DailyContentModel>> _parseDailyContentJson(String jsonString) {
  final jsonData = json.decode(jsonString) as Map<String, dynamic>;

  final hadithList = (jsonData[DailyContentKeys.dailyHadith] as List<dynamic>)
      .map(
        (item) => DailyContentModel.fromJson(
          item as Map<String, dynamic>,
          DailyContentType.hadith,
        ),
      )
      .toList();

  final sunnahList = (jsonData[DailyContentKeys.dailySunnah] as List<dynamic>)
      .map(
        (item) => DailyContentModel.fromJson(
          item as Map<String, dynamic>,
          DailyContentType.sunnah,
        ),
      )
      .toList();

  return {
    DailyContentKeys.dailyHadith: hadithList,
    DailyContentKeys.dailySunnah: sunnahList,
  };
}

abstract interface class DailyContentDataSource {
  Future<Map<String, List<DailyContentModel>>> loadDailyContent();
}

class DailyContentDataSourceImpl implements DailyContentDataSource {
  static const String _jsonPath = AppAssets.dailyContent;

  // Cache to avoid multiple I/O and parsing operations
  Map<String, List<DailyContentModel>>? _cachedContent;

  @override
  Future<Map<String, List<DailyContentModel>>> loadDailyContent() async {
    if (_cachedContent != null) return _cachedContent!;

    try {
      final jsonString = await rootBundle.loadString(_jsonPath);
      _cachedContent =
          await compute<String, Map<String, List<DailyContentModel>>>(
            _parseDailyContentJson,
            jsonString,
          );
      return _cachedContent!;
    } on Object catch (e, stack) {
      unawaited(
        AppLogger.error(
          'LoadDailyContent Error',
          error: e,
          stackTrace: stack,
        ),
      );
      return {};
    }
  }
}

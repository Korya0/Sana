import 'dart:async';
import 'dart:convert';
import 'package:sana/features/azkar/data/datasources/i_azkar_local_data_source.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:sana/core/constants/constants.dart';
import 'package:sana/core/utils/utils.dart';
import 'package:sana/features/azkar/data/models/azkar_category_model.dart';

List<AzkarCategoryModel> _parseAzkarJson(String jsonString) {
  final decoded = json.decode(jsonString) as List<dynamic>;
  return decoded.map((item) {
    final map = item as Map<String, dynamic>;
    return AzkarCategoryModel.fromJson(map);
  }).toList();
}

class AzkarLocalDataSource implements IAzkarLocalDataSource {
  // Cache to avoid repeated I/O and parsing
  static List<AzkarCategoryModel>? _cachedCategories;

  @override
  Future<List<AzkarCategoryModel>> getAllCategories() async {
    if (_cachedCategories != null && _cachedCategories!.isNotEmpty) {
      return _cachedCategories!;
    }

    try {
      final jsonString = await rootBundle.loadString(AppAssets.azkar);
      final allCategories = await compute<String, List<AzkarCategoryModel>>(
        _parseAzkarJson,
        jsonString,
      );

      // Priority IDs for sorting
      final priorityIds = {'2', '3', '5', '4', '1'};

      final sortedList = <AzkarCategoryModel>[];
      final othersList = <AzkarCategoryModel>[];

      // Single pass partitioning for better performance
      final categoryMap = {for (final cat in allCategories) cat.id: cat};

      for (final id in priorityIds) {
        if (categoryMap.containsKey(id)) {
          sortedList.add(categoryMap[id]!);
        }
      }

      for (final cat in allCategories) {
        if (!priorityIds.contains(cat.id)) {
          othersList.add(cat);
        }
      }

      _cachedCategories = [...sortedList, ...othersList];
      return _cachedCategories!;
    } on Exception catch (e, stackTrace) {
      unawaited(
        AppLogger.reportToFirebase(
          'Critical: Error loading or parsing Azkar JSON',
          error: e,
          stackTrace: stackTrace,
        ),
      );
      return [];
    }
  }
}

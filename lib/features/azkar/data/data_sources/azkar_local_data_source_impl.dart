import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:sana/core/constants/app_assets.dart';
import 'package:sana/features/azkar/data/data_sources/azkar_local_data_source.dart';
import 'package:sana/features/azkar/data/models/azkar_category_model.dart';
import 'package:sana/features/azkar/data/models/zikr_model.dart';

class AzkarLocalDataSourceImpl implements AzkarLocalDataSource {
  const AzkarLocalDataSourceImpl();

  // Loads categories
  @override
  Future<List<AzkarCategoryModel>> getCategories() async {
    final data = await _loadJsonList(AppAssets.azkarCategories);
    return data
        .map(
          (item) => AzkarCategoryModel.fromJson(item as Map<String, dynamic>),
        )
        .toList();
  }

  // Loads azkar
  @override
  Future<List<ZikrModel>> getAzkarByCategory(String categoryKey) async {
    final data = await _loadJsonList(AppAssets.azkarCategory(categoryKey));
    return data
        .map((item) => ZikrModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  // Loads JSON list
  Future<List<dynamic>> _loadJsonList(String path) async {
    final raw = await rootBundle.loadString(path);
    return json.decode(raw) as List<dynamic>;
  }
}

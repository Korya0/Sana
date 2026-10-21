import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:sana/core/constants/app_assets.dart';
import 'package:sana/features/azkar/data/data_sources/azkar_local_data_source.dart';
import 'package:sana/features/azkar/data/models/category_model.dart';
import 'package:sana/features/azkar/data/models/zikr_model.dart';

class AzkarLocalDataSourceImpl implements AzkarLocalDataSource {
  const AzkarLocalDataSourceImpl();

  // Loads all categories
  @override
  Future<List<CategoryModel>> getCategories() async {
    final data = await _loadJsonList(AppAssets.azkarCategories);
    return data
        .map((item) => CategoryModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  // Loads category azkar
  @override
  Future<List<ZikrModel>> getAzkarByCategory(int categoryId) async {
    final data = await _loadJsonList(AppAssets.azkarCategory(categoryId));
    return data
        .map((item) => ZikrModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  // Reads asset JSON
  Future<List<dynamic>> _loadJsonList(String path) async {
    final raw = await rootBundle.loadString(path);
    return json.decode(raw) as List<dynamic>;
  }
}

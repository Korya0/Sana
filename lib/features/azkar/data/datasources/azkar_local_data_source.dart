import 'dart:async';
import 'dart:convert';
import 'package:sana/features/azkar/data/datasources/i_azkar_local_data_source.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:sana/core/constants/constants.dart';

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
  List<AzkarCategoryModel>? _cachedCategories;

  @override
  Future<List<AzkarCategoryModel>> getAllCategories() async {
    if (_cachedCategories != null && _cachedCategories!.isNotEmpty) {
      return _cachedCategories!;
    }

    final jsonString = await rootBundle.loadString(AppAssets.azkar);
    final allCategories = await compute<String, List<AzkarCategoryModel>>(
      _parseAzkarJson,
      jsonString,
    );

    _cachedCategories = allCategories;
    return _cachedCategories!;
  }
}

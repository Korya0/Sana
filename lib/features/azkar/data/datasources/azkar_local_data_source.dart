import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:sana/features/azkar/data/models/azkar_category_model.dart';

class AzkarLocalDataSource {
  Future<List<AzkarCategoryModel>> getAllCategories() async {
    try {
      final String jsonString = await rootBundle.loadString(
        'assets/json/adhkar.json',
      );
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((json) => AzkarCategoryModel.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }
}

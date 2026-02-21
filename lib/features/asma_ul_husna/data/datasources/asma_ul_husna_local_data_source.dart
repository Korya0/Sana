import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:sana/features/asma_ul_husna/data/models/asmaul_husna_model.dart';

class AsmaUlHusnaLocalDataSource {
  static List<AsmaulHusnaModel>? _cachedNames;

  static Future<List<AsmaulHusnaModel>> getNames() async {
    if (_cachedNames != null) {
      return _cachedNames!;
    }

    try {
      final jsonString = await rootBundle.loadString(
        'assets/json/asma_ul_husna.json',
      );
      final jsonList = json.decode(jsonString) as List<dynamic>;

      _cachedNames = jsonList
          .map((e) => AsmaulHusnaModel.fromJson(e as Map<String, dynamic>))
          .toList();

      return _cachedNames!;
    } on Exception catch (e) {
      debugPrint('Error loading Asma Ul Husna JSON: $e');
      return [];
    }
  }
}

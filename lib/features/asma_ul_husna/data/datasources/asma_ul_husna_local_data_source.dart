import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:sana/core/constants/app_assets.dart';
import 'package:sana/core/utils/app_logger.dart';
import 'package:sana/features/asma_ul_husna/data/models/asmaul_husna_model.dart';

class AsmaUlHusnaLocalDataSource {
  static List<AsmaulHusnaModel>? _cachedNames;

  static Future<List<AsmaulHusnaModel>> getNames() async {
    if (_cachedNames != null) {
      return _cachedNames!;
    }

    try {
      final jsonString = await rootBundle.loadString(
        AppAssetsJson.asmaUlHusna,
      );

      final jsonList = json.decode(jsonString) as List<dynamic>;

      _cachedNames = jsonList
          .map((e) => AsmaulHusnaModel.fromJson(e as Map<String, dynamic>))
          .toList();

      return _cachedNames!;
    } on Exception catch (e) {
      AppLogger.error('Error loading Asma Ul Husna JSON', error: e);
      return [];
    }
  }
}

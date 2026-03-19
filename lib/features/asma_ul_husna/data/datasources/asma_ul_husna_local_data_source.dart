import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:sana/core/constants/generated/assets.gen.dart';
import 'package:sana/core/utils/app_logger.dart';
import 'package:sana/features/asma_ul_husna/data/models/asmaul_husna_model.dart';

List<AsmaulHusnaModel> _parseAsmaUlHusnaJson(String jsonString) {
  final decoded = json.decode(jsonString) as List<dynamic>;
  return decoded
      .map((e) => AsmaulHusnaModel.fromJson(e as Map<String, dynamic>))
      .toList();
}

class AsmaUlHusnaLocalDataSource {
  static List<AsmaulHusnaModel>? _cachedNames;

  static Future<List<AsmaulHusnaModel>> getNames() async {
    if (_cachedNames != null) {
      return _cachedNames!;
    }

    try {
      final jsonString = await rootBundle.loadString(
        Assets.json.asmaUlHusna,
      );

      _cachedNames = await compute<String, List<AsmaulHusnaModel>>(
        _parseAsmaUlHusnaJson,
        jsonString,
      );

      return _cachedNames!;
    } on Exception catch (e, stackTrace) {
      unawaited(
        AppLogger.error(
          'Error loading Asma Ul Husna JSON',
          error: e,
          stackTrace: stackTrace,
        ),
      );
      return [];
    }
  }
}

import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
// FontAwesome removed
import 'package:sana/core/constants/generated/assets.gen.dart';
import 'package:sana/core/utils/app_logger.dart';
import 'package:sana/features/azkar/constants/azkar_keys.dart';
import 'package:sana/features/azkar/data/models/azkar_category_model.dart';
import 'package:solar_icons/solar_icons.dart';

const Map<String, IconData> _categoryIcons = {
  '1': FlutterIslamicIcons.solidTasbihHand,
  '2': SolarIconsBold.sunrise,
  '3': SolarIconsBold.sunfog,
  '4': SolarIconsBold.sleeping,
  '5': SolarIconsBold.alarm,
  '6': Icons.shower,
  '7': FlutterIslamicIcons.mosque,
  '8': SolarIconsBold.home,
  '9': FlutterIslamicIcons.solidMosque,
  '10': Icons.bathtub,
  '11': Icons.restaurant,
  '12': Icons.checkroom,
  '13': FlutterIslamicIcons.ramadan,
  '14': Icons.sentiment_dissatisfied_outlined,
  '15': FlutterIslamicIcons.prayingPerson,
  '16': FlutterIslamicIcons.tasbih3,
  '17': Icons.favorite,
  '18': Icons.child_care,
  '19': SolarIconsBold.medicalKit,
  '20': FlutterIslamicIcons.solidAllah,
  '21': Icons.heart_broken,
  '22': Icons.flight,
  '23': FlutterIslamicIcons.solidPrayingPerson,
};

List<AzkarCategoryModel> _parseAzkarJson(String jsonString) {
  final decoded = json.decode(jsonString) as List<dynamic>;
  return decoded.map((item) {
    final map = item as Map<String, dynamic>;
    final id = map[AzkarKeys.id].toString();
    return AzkarCategoryModel.fromJson(map, icon: _categoryIcons[id]);
  }).toList();
}

class AzkarLocalDataSource {
  // Cache to avoid repeated I/O and parsing
  static List<AzkarCategoryModel>? _cachedCategories;

  Future<List<AzkarCategoryModel>> getAllCategories() async {
    if (_cachedCategories != null && _cachedCategories!.isNotEmpty) {
      return _cachedCategories!;
    }

    try {
      final jsonString = await rootBundle.loadString(Assets.json.azkar);
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
        AppLogger.error(
          'Critical: Error loading or parsing Azkar JSON',
          error: e,
          stackTrace: stackTrace,
        ),
      );
      return [];
    }
  }
}

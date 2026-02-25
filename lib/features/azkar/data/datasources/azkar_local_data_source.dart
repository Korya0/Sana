import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sana/core/constants/app_assets.dart';
import 'package:sana/core/utils/app_logger.dart';
import 'package:sana/features/azkar/data/models/azkar_category_model.dart';
import 'package:solar_icons/solar_icons.dart';

class AzkarLocalDataSource {
  static const Map<String, IconData> _categoryIcons = {
    '1': FlutterIslamicIcons.solidTasbihHand,
    '2': SolarIconsBold.sunrise,
    '3': SolarIconsBold.sunfog,
    '4': FontAwesomeIcons.bed,
    '5': SolarIconsBold.alarm,
    '6': FontAwesomeIcons.shower,
    '7': FontAwesomeIcons.mosque,
    '8': FontAwesomeIcons.house,
    '9': FlutterIslamicIcons.solidMosque,
    '10': FontAwesomeIcons.bath,
    '11': FontAwesomeIcons.utensils,
    '12': Icons.checkroom,
    '13': FlutterIslamicIcons.ramadan,
    '14': Icons.sentiment_dissatisfied_outlined,
    '15': FontAwesomeIcons.personPraying,
    '16': FlutterIslamicIcons.tasbih3,
    '17': FontAwesomeIcons.ring,
    '18': FontAwesomeIcons.child,
    '19': FontAwesomeIcons.hospital,
    '20': FlutterIslamicIcons.solidAllah,
    '21': FontAwesomeIcons.heartCrack,
    '22': FontAwesomeIcons.plane,
    '23': FlutterIslamicIcons.solidPrayingPerson,
  };

  // Cache to avoid repeated I/O and parsing
  List<AzkarCategoryModel>? _cachedCategories;

  Future<List<AzkarCategoryModel>> getAllCategories() async {
    if (_cachedCategories != null) return _cachedCategories!;

    try {
      final jsonString = await rootBundle.loadString(AppAssetsJson.azkar);
      final jsonList = json.decode(jsonString) as List<dynamic>;

      final allCategories = jsonList.map((e) {
        final map = e as Map<String, dynamic>;
        final id = map['id'].toString();
        return AzkarCategoryModel.fromJson(map, icon: _categoryIcons[id]);
      }).toList();

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
    } catch (e) {
      AppLogger.error(
        'Critical: Error loading or parsing Azkar JSON',
        error: e,
      );
      return [];
    }
  }
}

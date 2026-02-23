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
  static final Map<String, IconData> _categoryIcons = {
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

  // Cache
  List<AzkarCategoryModel>? _cachedCategories;

  Future<List<AzkarCategoryModel>> getAllCategories() async {
    if (_cachedCategories != null) {
      return _cachedCategories!;
    }

    try {
      final jsonString = await rootBundle.loadString(AppAssetsJson.azkar);

      final jsonList = json.decode(jsonString) as List<dynamic>;

      final allCategories = jsonList.map((e) {
        final map = e as Map<String, dynamic>;
        final id = map['id'] as String;
        final icon = _categoryIcons[id];
        return AzkarCategoryModel.fromJson(map, icon: icon);
      }).toList();

      // Custom Order: Morning (2), Evening (3), Waking (5), Sleep (4), After Prayer (1)
      final customOrder = ['2', '3', '5', '4', '1'];

      final sortedList = <AzkarCategoryModel>[];
      final remainingList = <AzkarCategoryModel>[];

      // Add custom ordered items
      for (final id in customOrder) {
        try {
          final item = allCategories.firstWhere((e) => e.id == id);
          sortedList.add(item);
        } on FormatException catch (_) {
          // Item might not exist in JSON, ignore
        }
      }

      // Add remaining items
      for (final item in allCategories) {
        if (!customOrder.contains(item.id)) {
          remainingList.add(item);
        }
      }

      // Concatenate
      _cachedCategories = [...sortedList, ...remainingList];

      return _cachedCategories!;
    } on Exception catch (e) {
      AppLogger.error('Error loading Azkar JSON', error: e);
      return [];
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:sana/features/azkar/data/constants/azkar_keys.dart';
import 'package:sana/features/azkar/data/models/zikr_model.dart';
import 'package:sana/features/home/data/models/category_model.dart';

class AzkarCategoryModel extends CategoryModel {
  AzkarCategoryModel({
    required this.id,
    required this.category,
    required this.array,
    required this.icon,
  });

  factory AzkarCategoryModel.fromJson(
    Map<String, dynamic> json, {
    IconData? icon,
  }) {
    final thikrArray = json[AzkarKeys.array] as List<dynamic>;
    final items = thikrArray
        .map((item) => ZikrModel.fromJson(item as Map<String, dynamic>))
        .toList();

    return AzkarCategoryModel(
      id: json[AzkarKeys.id] as String,
      category: json[AzkarKeys.category] as String,
      array: items,
      icon: icon ?? FlutterIslamicIcons.solidPrayer,
    );
  }
  @override
  final String id;
  final String category;
  final List<ZikrModel> array;
  final IconData icon;

  Map<String, dynamic> toJson() {
    return {
      AzkarKeys.id: id,
      AzkarKeys.category: category,
      AzkarKeys.array: array.map((e) => e.toJson()).toList(),
    };
  }
}

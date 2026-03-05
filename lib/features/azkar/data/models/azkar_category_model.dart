import 'package:flutter/material.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:sana/core/constants/json_keys.dart';
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
    final thikrArray = json[JsonKeys.array] as List<dynamic>;
    final items = thikrArray
        .map((item) => ZikrModel.fromJson(item as Map<String, dynamic>))
        .toList();

    return AzkarCategoryModel(
      id: json[JsonKeys.id] as String,
      category: json[JsonKeys.category] as String,
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
      JsonKeys.id: id,
      JsonKeys.category: category,
      JsonKeys.array: array.map((e) => e.toJson()).toList(),
    };
  }
}

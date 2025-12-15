import 'package:flutter/material.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:sana/features/azkar/data/models/zikr_model.dart';
import 'package:sana/features/home/data/model/category_model.dart';

class AzkarCategoryModel extends CategoryModel {
  @override
  final String id;
  final String category;
  final List<ZikrModel> array;
  final IconData icon;

  AzkarCategoryModel({
    required this.id,
    required this.category,
    required this.array,
    required this.icon,
  });

  factory AzkarCategoryModel.fromJson(Map<String, dynamic> json) {
    final List<dynamic> thikrArray = json['array'] as List<dynamic>;
    final List<ZikrModel> items = thikrArray
        .map((item) => ZikrModel.fromJson(item as Map<String, dynamic>))
        .toList();

    return AzkarCategoryModel(
      id: json['id'] as String,
      category: json['category'] as String,
      array: items,
      icon: FlutterIslamicIcons.solidPrayer,
    );
  }
}

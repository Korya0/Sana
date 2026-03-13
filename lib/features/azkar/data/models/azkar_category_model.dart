import 'package:flutter/material.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sana/features/azkar/data/constants/azkar_keys.dart';
import 'package:sana/features/azkar/data/models/zikr_model.dart';
import 'package:sana/features/home/data/models/category_model.dart';

part 'azkar_category_model.freezed.dart';

@freezed
class AzkarCategoryModel with _$AzkarCategoryModel implements CategoryModel {
  const factory AzkarCategoryModel({
    required String id,
    required String category,
    required List<ZikrModel> array,
    required IconData icon,
  }) = _AzkarCategoryModel;

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
}

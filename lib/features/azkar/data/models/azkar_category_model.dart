import 'package:sana/features/azkar/constants/azkar_keys.dart';
import 'package:sana/features/azkar/data/models/zikr_model.dart';
import 'package:sana/features/azkar/domain/entities/azkar_category_entity.dart';

class AzkarCategoryModel extends AzkarCategoryEntity {
  const AzkarCategoryModel({
    required super.id,
    required super.category,
    required super.array,
  });

  factory AzkarCategoryModel.fromJson(Map<String, dynamic> json) {
    final thikrArray = json[AzkarKeys.array] as List<dynamic>;
    final items = thikrArray
        .map((item) => ZikrModel.fromJson(item as Map<String, dynamic>))
        .toList();

    return AzkarCategoryModel(
      id: json[AzkarKeys.id] as String,
      category: json[AzkarKeys.category] as String,
      array: items,
    );
  }
}

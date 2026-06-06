import 'package:sana/features/azkar/constants/azkar_keys.dart';
import 'package:sana/features/azkar/data/models/zikr_model.dart';

class AzkarCategoryModel {
  const AzkarCategoryModel({
    required this.id,
    required this.category,
    required this.array,
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
  final String id;
  final String category;
  final List<ZikrModel> array;

  AzkarCategoryModel copyWith({
    String? id,
    String? category,
    List<ZikrModel>? array,
  }) {
    return AzkarCategoryModel(
      id: id ?? this.id,
      category: category ?? this.category,
      array: array ?? this.array,
    );
  }
}

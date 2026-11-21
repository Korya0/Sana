import 'package:sana/core/utils/app_validators.dart';
import 'package:sana/features/azkar/data/constants/azkar_constants.dart';
import 'package:sana/features/azkar/data/models/zikr_model.dart';
import 'package:sana/features/azkar/domain/entities/custom_category_entity.dart';

class CustomCategoryModel extends CustomCategoryEntity {
  // Creates model
  const CustomCategoryModel({
    required super.id,
    required super.name,
    required super.azkar,
    super.createdAt,
  });

  // Parses JSON
  factory CustomCategoryModel.fromJson(Map<String, dynamic> json) {
    final rawAzkar = json[azkarItemsKey];
    final rawName = json[azkarNameKey];
    final rawCreatedAt = json[azkarCreatedAtKey];
    return CustomCategoryModel(
      id: (json[azkarIdKey] as String?) ?? '',
      name: rawName is String
          ? AppValidators.collapseWhitespace(rawName)
          : '',
      azkar: rawAzkar is List<dynamic>
          ? rawAzkar
              .whereType<Map<String, dynamic>>()
              .map(ZikrModel.fromJson)
              .toList()
          : const [],
      createdAt: rawCreatedAt is String ? DateTime.tryParse(rawCreatedAt) : null,
    );
  }

  // Maps entity
  factory CustomCategoryModel.fromEntity(CustomCategoryEntity entity) =>
      CustomCategoryModel(
        id: entity.id,
        name: entity.name,
        azkar: entity.azkar
            .map((z) => z is ZikrModel ? z : ZikrModel.fromEntity(z))
            .toList(),
        createdAt: entity.createdAt,
      );

  // Serializes JSON
  Map<String, dynamic> toJson() => {
    azkarIdKey: id,
    azkarNameKey: name,
    azkarItemsKey: azkar
        .map((z) => (z is ZikrModel ? z : ZikrModel.fromEntity(z)).toJson())
        .toList(),
    if (createdAt != null) azkarCreatedAtKey: createdAt!.toIso8601String(),
  };
}

import 'package:sana/features/azkar/data/constants/azkar_constants.dart';
import 'package:sana/features/azkar/domain/entities/azkar_category_entity.dart';

class AzkarCategoryModel extends AzkarCategoryEntity {
  // Creates model
  const AzkarCategoryModel({
    required super.key,
    required super.title,
    required super.cardTitle,
  });

  // Parses JSON
  factory AzkarCategoryModel.fromJson(Map<String, dynamic> json) {
    final title = json[azkarTitleKey] as String;

    return AzkarCategoryModel(
      key: json[azkarKeyKey] as String,
      title: title,
      cardTitle: json[azkarCardTitleKey] as String? ?? title,
    );
  }
}

import 'package:sana/features/azkar/data/constants/azkar_constants.dart';
import 'package:sana/features/azkar/domain/entities/category_entity.dart';

class CategoryModel extends CategoryEntity {
  const CategoryModel({
    required super.key,
    required super.title,
    required super.cardTitle,
  });

  // Parses category JSON
  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    final title = json[azkarTitleKey] as String;

    return CategoryModel(
      key: json[azkarKeyKey] as String,
      title: title,
      cardTitle: json[azkarCardTitleKey] as String? ?? title,
    );
  }
}

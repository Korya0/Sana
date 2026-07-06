import 'package:sana/features/azkar/data/constants/azkar_constants.dart';
import 'package:sana/features/azkar/domain/entities/category_entity.dart';

class CategoryModel extends CategoryEntity {
  const CategoryModel({
    required super.id,
    required super.title,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json[AzkarConstants.idKey] as int,
      title: json[AzkarConstants.titleKey] as String,
    );
  }

  CategoryEntity toEntity() {
    return CategoryEntity(
      id: id,
      title: title,
    );
  }
}

import 'package:sana/core/error/result.dart';
import 'package:sana/features/azkar/domain/entities/custom_category_entity.dart';

abstract interface class CustomAzkarRepository {
  Future<Result<List<CustomCategoryEntity>>> getCustomCategories();

  Future<Result<void>> saveCustomCategory(CustomCategoryEntity category);

  Future<Result<void>> deleteCustomCategory(String id);

  Future<Result<CustomCategoryEntity?>> getCustomCategoryById(String id);
}


import 'package:sana/core/error/result.dart';
import 'package:sana/features/azkar/domain/entities/custom_category_entity.dart';

abstract interface class CustomAzkarRepository {
  // Loads categories
  Future<Result<List<CustomCategoryEntity>>> getCustomCategories();

  // Saves category
  Future<Result<void>> saveCustomCategory(CustomCategoryEntity category);

  // Deletes category
  Future<Result<void>> deleteCustomCategory(String id);

  // Finds category
  Future<Result<CustomCategoryEntity?>> getCustomCategoryById(String id);
}

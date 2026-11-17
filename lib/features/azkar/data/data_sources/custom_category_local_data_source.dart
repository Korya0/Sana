import 'package:sana/features/azkar/data/models/custom_category_model.dart';

abstract interface class CustomCategoryLocalDataSource {
  // Loads categories
  Future<List<CustomCategoryModel>> getCustomCategories();

  // Saves category
  Future<void> saveCustomCategory(CustomCategoryModel category);

  // Deletes category
  Future<void> deleteCustomCategory(String id);

  // Finds category
  Future<CustomCategoryModel?> getCustomCategoryById(String id);
}

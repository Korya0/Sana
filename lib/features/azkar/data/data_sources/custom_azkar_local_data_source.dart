import 'package:sana/features/azkar/data/models/custom_category_model.dart';

abstract interface class CustomAzkarLocalDataSource {
  Future<List<CustomCategoryModel>> getCustomCategories();

  Future<void> saveCustomCategory(CustomCategoryModel category);

  Future<void> deleteCustomCategory(String id);

  Future<CustomCategoryModel?> getCustomCategoryById(String id);
}


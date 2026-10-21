import 'package:sana/features/azkar/data/models/category_model.dart';
import 'package:sana/features/azkar/data/models/zikr_model.dart';

abstract interface class AzkarLocalDataSource {
  // Loads all categories
  Future<List<CategoryModel>> getCategories();

  // Loads category azkar
  Future<List<ZikrModel>> getAzkarByCategory(int categoryId);
}

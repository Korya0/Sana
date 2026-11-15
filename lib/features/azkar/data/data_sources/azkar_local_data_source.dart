import 'package:sana/features/azkar/data/models/azkar_category_model.dart';
import 'package:sana/features/azkar/data/models/zikr_model.dart';

abstract interface class AzkarLocalDataSource {
  // Loads categories
  Future<List<AzkarCategoryModel>> getCategories();

  // Loads azkar
  Future<List<ZikrModel>> getAzkarByCategory(String categoryKey);
}

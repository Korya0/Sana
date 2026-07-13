import 'package:sana/features/azkar/data/models/category_model.dart';
import 'package:sana/features/azkar/data/models/zikr_model.dart';

abstract interface class IAzkarLocalDataSource {
  Future<void> ensureDatabaseReady();
  Future<List<CategoryModel>> getCategories();
  Future<List<ZikrModel>> getAzkarByCategory(int categoryId);
}

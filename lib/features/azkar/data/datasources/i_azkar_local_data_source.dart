import 'package:sana/features/azkar/data/models/azkar_category_model.dart';

abstract class IAzkarLocalDataSource {
  Future<List<AzkarCategoryModel>> getAllCategories();
}

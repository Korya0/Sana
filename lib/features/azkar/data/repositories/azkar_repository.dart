import 'package:sana/features/azkar/data/datasource/azkar_local_data_source.dart';
import 'package:sana/features/azkar/data/models/azkar_category_model.dart';

abstract class IAzkarRepository {
  Future<List<AzkarCategoryModel>> getAllCategories();
  Future<AzkarCategoryModel?> getItemById(String id);
}

class AzkarRepository implements IAzkarRepository {
  final AzkarLocalDataSource _dataSource;

  AzkarRepository(this._dataSource);

  @override
  Future<List<AzkarCategoryModel>> getAllCategories() async {
    return await _dataSource.getAllCategories();
  }

  @override
  Future<AzkarCategoryModel?> getItemById(String id) async {
    final categories = await getAllCategories();
    try {
      return categories.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }
}

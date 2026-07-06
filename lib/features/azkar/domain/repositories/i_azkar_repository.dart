import 'package:sana/core/networking/result.dart';
import 'package:sana/features/azkar/domain/entities/category_entity.dart';
import 'package:sana/features/azkar/domain/entities/zikr_entity.dart';

abstract class IAzkarRepository {
  Future<Result<List<CategoryEntity>>> getCategories();
  Future<Result<List<ZikrEntity>>> getAzkarByCategory(int categoryId);
}

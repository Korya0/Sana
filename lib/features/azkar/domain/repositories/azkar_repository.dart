import 'package:sana/core/network/result.dart';
import 'package:sana/features/azkar/domain/entities/category_entity.dart';
import 'package:sana/features/azkar/domain/entities/zikr_entity.dart';

abstract interface class AzkarRepository {
  Future<Result<List<CategoryEntity>>> getCategories();
  Future<Result<List<ZikrEntity>>> getAzkarByCategory(int categoryId);
}

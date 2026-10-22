import 'package:sana/core/error/result.dart';
import 'package:sana/features/azkar/domain/entities/category_entity.dart';
import 'package:sana/features/azkar/domain/entities/zikr_entity.dart';

abstract interface class AzkarRepository {
  // Loads all categories
  Future<Result<List<CategoryEntity>>> getCategories();

  // Loads category azkar
  Future<Result<List<ZikrEntity>>> getAzkarByCategory(String categoryKey);
}

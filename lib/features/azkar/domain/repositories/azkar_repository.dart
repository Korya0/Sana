import 'package:sana/core/error/result.dart';
import 'package:sana/features/azkar/domain/entities/azkar_category_entity.dart';
import 'package:sana/features/azkar/domain/entities/zikr_entity.dart';

abstract interface class AzkarRepository {
  // Loads categories
  Future<Result<List<AzkarCategoryEntity>>> getCategories();

  // Loads azkar
  Future<Result<List<ZikrEntity>>> getZikrsByCategory(String categoryKey);
}

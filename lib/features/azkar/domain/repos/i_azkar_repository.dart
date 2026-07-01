import 'package:sana/core/networking/result.dart';
import 'package:sana/features/azkar/domain/entities/azkar_category_entity.dart';

abstract class IAzkarRepository {
  Future<Result<List<AzkarCategoryEntity>>> getAllCategories();
  Future<Result<AzkarCategoryEntity>> getItemById(String id);
}

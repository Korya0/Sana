import 'package:sana/core/error/result.dart';
import 'package:sana/features/azkar/domain/entities/custom_category_entity.dart';
import 'package:sana/features/azkar/domain/repositories/custom_category_repository.dart';

class GetCustomCategoriesUseCase {
  // Creates use case
  GetCustomCategoriesUseCase(this._repository);

  final CustomCategoryRepository _repository;

  // Loads categories
  Future<Result<List<CustomCategoryEntity>>> call() =>
      _repository.getCustomCategories();
}

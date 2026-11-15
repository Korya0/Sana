import 'package:sana/core/error/result.dart';
import 'package:sana/features/azkar/domain/entities/azkar_category_entity.dart';
import 'package:sana/features/azkar/domain/repositories/azkar_repository.dart';

class GetAzkarCategoriesUseCase {
  // Creates use case
  GetAzkarCategoriesUseCase(this._repository);

  final AzkarRepository _repository;

  // Loads categories
  Future<Result<List<AzkarCategoryEntity>>> call() =>
      _repository.getCategories();
}

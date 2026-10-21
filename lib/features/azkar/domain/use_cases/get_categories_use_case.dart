import 'package:sana/core/error/result.dart';
import 'package:sana/features/azkar/domain/entities/category_entity.dart';
import 'package:sana/features/azkar/domain/repositories/azkar_repository.dart';

class GetCategoriesUseCase {
  GetCategoriesUseCase(this._repository);

  final AzkarRepository _repository;

  // Loads all categories
  Future<Result<List<CategoryEntity>>> call() => _repository.getCategories();
}

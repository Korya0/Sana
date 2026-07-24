import 'package:sana/core/network/result.dart';
import 'package:sana/features/azkar/domain/entities/category_entity.dart';
import 'package:sana/features/azkar/domain/repositories/azkar_repository.dart';

class GetCategoriesUseCase {
  GetCategoriesUseCase(this.repository);
  final AzkarRepository repository;

  Future<Result<List<CategoryEntity>>> call() {
    return repository.getCategories();
  }
}

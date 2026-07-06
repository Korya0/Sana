import 'package:sana/core/networking/result.dart';
import 'package:sana/features/azkar/domain/entities/category_entity.dart';
import 'package:sana/features/azkar/domain/repositories/i_azkar_repository.dart';

class GetCategoriesUseCase {
  GetCategoriesUseCase(this.repository);
  final IAzkarRepository repository;

  Future<Result<List<CategoryEntity>>> call() {
    return repository.getCategories();
  }
}

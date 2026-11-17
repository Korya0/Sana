import 'package:sana/core/error/result.dart';
import 'package:sana/features/azkar/domain/repositories/custom_category_repository.dart';

class DeleteCustomCategoryUseCase {
  // Creates use case
  DeleteCustomCategoryUseCase(this._repository);

  final CustomCategoryRepository _repository;

  // Deletes category
  Future<Result<void>> call(String id) => _repository.deleteCustomCategory(id);
}

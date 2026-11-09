import 'package:sana/core/error/result.dart';
import 'package:sana/features/azkar/domain/repositories/custom_azkar_repository.dart';

class DeleteCustomCategoryUseCase {
  DeleteCustomCategoryUseCase(this._repository);

  final CustomAzkarRepository _repository;

  // Deletes a custom category by id
  Future<Result<void>> call(String id) => _repository.deleteCustomCategory(id);
}


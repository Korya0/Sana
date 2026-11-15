import 'package:sana/core/error/result.dart';
import 'package:sana/features/azkar/domain/entities/custom_category_entity.dart';
import 'package:sana/features/azkar/domain/repositories/custom_azkar_repository.dart';

class SaveCustomCategoryUseCase {
  // Creates use case
  SaveCustomCategoryUseCase(this._repository);

  final CustomAzkarRepository _repository;

  // Saves category
  Future<Result<void>> call(CustomCategoryEntity category) =>
      _repository.saveCustomCategory(category);
}

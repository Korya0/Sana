import 'package:sana/core/error/result.dart';
import 'package:sana/features/azkar/domain/repositories/tasbeeh_repository.dart';

class DeleteTasbeehItemUseCase {
  // Creates use case
  const DeleteTasbeehItemUseCase(this._repository);

  final TasbeehRepository _repository;

  // Runs use case
  Future<Result<void>> call(String id) => _repository.deleteTasbeehItem(id);
}

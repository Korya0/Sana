import 'package:sana/core/error/result.dart';
import 'package:sana/features/azkar/domain/entities/tasbeeh_item_entity.dart';
import 'package:sana/features/azkar/domain/repositories/tasbeeh_repository.dart';

class SaveTasbeehItemUseCase {
  // Creates use case
  const SaveTasbeehItemUseCase(this._repository);

  final TasbeehRepository _repository;

  // Runs use case
  Future<Result<void>> call(TasbeehItemEntity item) =>
      _repository.saveItem(item);
}

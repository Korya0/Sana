import 'package:sana/core/error/result.dart';
import 'package:sana/features/azkar/domain/entities/tasbeeh_item_entity.dart';
import 'package:sana/features/azkar/domain/repositories/tasbeeh_repository.dart';

class GetTasbeehItemsUseCase {
  // Creates use case
  const GetTasbeehItemsUseCase(this._repository);

  final TasbeehRepository _repository;

  // Runs use case
  Future<Result<List<TasbeehItemEntity>>> call() =>
      _repository.getTasbeehItems();
}

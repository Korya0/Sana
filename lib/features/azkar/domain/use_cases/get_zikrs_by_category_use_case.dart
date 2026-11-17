import 'package:sana/core/error/result.dart';
import 'package:sana/features/azkar/domain/entities/zikr_entity.dart';
import 'package:sana/features/azkar/domain/repositories/azkar_repository.dart';

class GetZikrsByCategoryUseCase {
  // Creates use case
  GetZikrsByCategoryUseCase(this._repository);

  final AzkarRepository _repository;

  // Loads azkar
  Future<Result<List<ZikrEntity>>> call(String categoryKey) =>
      _repository.getZikrsByCategory(categoryKey);
}

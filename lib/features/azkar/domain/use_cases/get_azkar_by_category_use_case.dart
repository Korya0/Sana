import 'package:sana/core/error/result.dart';
import 'package:sana/features/azkar/domain/entities/zikr_entity.dart';
import 'package:sana/features/azkar/domain/repositories/azkar_repository.dart';

class GetAzkarByCategoryUseCase {
  GetAzkarByCategoryUseCase(this._repository);

  final AzkarRepository _repository;

  // Loads category azkar
  Future<Result<List<ZikrEntity>>> call(int categoryId) =>
      _repository.getAzkarByCategory(categoryId);
}

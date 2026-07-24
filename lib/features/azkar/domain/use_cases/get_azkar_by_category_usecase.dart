import 'package:sana/core/network/result.dart';
import 'package:sana/features/azkar/domain/entities/zikr_entity.dart';
import 'package:sana/features/azkar/domain/repositories/azkar_repository.dart';

class GetAzkarByCategoryUseCase {
  GetAzkarByCategoryUseCase(this.repository);
  final AzkarRepository repository;

  Future<Result<List<ZikrEntity>>> call(int categoryId) {
    return repository.getAzkarByCategory(categoryId);
  }
}

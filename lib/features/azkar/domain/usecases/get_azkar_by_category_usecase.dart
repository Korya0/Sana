import 'package:sana/core/networking/result.dart';
import 'package:sana/features/azkar/domain/entities/zikr_entity.dart';
import 'package:sana/features/azkar/domain/repositories/i_azkar_repository.dart';

class GetAzkarByCategoryUseCase {
  GetAzkarByCategoryUseCase(this.repository);
  final IAzkarRepository repository;

  Future<Result<List<ZikrEntity>>> call(int categoryId) {
    return repository.getAzkarByCategory(categoryId);
  }
}

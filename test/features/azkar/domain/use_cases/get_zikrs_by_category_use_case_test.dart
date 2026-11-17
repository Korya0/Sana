import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/error/result.dart';
import 'package:sana/features/azkar/domain/entities/azkar_category_entity.dart';
import 'package:sana/features/azkar/domain/entities/zikr_entity.dart';
import 'package:sana/features/azkar/domain/repositories/azkar_repository.dart';
import 'package:sana/features/azkar/domain/use_cases/get_zikrs_by_category_use_case.dart';

void main() {
  test('forwards the category key and returns its azkar', () async {
    final repository = _FakeRepository(
      azkar: const [ZikrEntity(id: 1, text: 'سبحان الله', count: 33)],
    );

    final result = await GetZikrsByCategoryUseCase(repository)('morning');

    final success = result as Success<List<ZikrEntity>>;
    expect(success.data.single.text, 'سبحان الله');
    expect(repository.lastKey, 'morning');
  });
}

class _FakeRepository implements AzkarRepository {
  _FakeRepository({required this.azkar});

  final List<ZikrEntity> azkar;
  String? lastKey;

  @override
  Future<Result<List<ZikrEntity>>> getZikrsByCategory(
    String categoryKey,
  ) async {
    lastKey = categoryKey;
    return Result.success(azkar);
  }

  @override
  Future<Result<List<AzkarCategoryEntity>>> getCategories() async =>
      const Result.success([]);
}

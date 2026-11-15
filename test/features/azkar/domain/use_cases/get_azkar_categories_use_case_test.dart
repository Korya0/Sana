import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/error/result.dart';
import 'package:sana/features/azkar/domain/entities/azkar_category_entity.dart';
import 'package:sana/features/azkar/domain/entities/zikr_entity.dart';
import 'package:sana/features/azkar/domain/repositories/azkar_repository.dart';
import 'package:sana/features/azkar/domain/use_cases/get_azkar_categories_use_case.dart';

void main() {
  test('loads categories from the repository', () async {
    const categories = [
      AzkarCategoryEntity(
        key: 'morning',
        title: 'أذكار الصباح',
        cardTitle: 'الصباح',
      ),
    ];
    final repository = _FakeRepository(categories: categories);

    final result = await GetAzkarCategoriesUseCase(repository)();

    final success = result as Success<List<AzkarCategoryEntity>>;
    expect(success.data.single.key, 'morning');
    expect(repository.categoryCalls, 1);
  });
}

class _FakeRepository implements AzkarRepository {
  _FakeRepository({required this.categories});

  final List<AzkarCategoryEntity> categories;
  int categoryCalls = 0;

  @override
  Future<Result<List<AzkarCategoryEntity>>> getCategories() async {
    categoryCalls++;
    return Result.success(categories);
  }

  @override
  Future<Result<List<ZikrEntity>>> getAzkarByCategory(
    String categoryKey,
  ) async => const Result.success([]);
}

import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/error/result.dart';
import 'package:sana/features/azkar/domain/entities/custom_category_entity.dart';
import 'package:sana/features/azkar/domain/repositories/custom_category_repository.dart';
import 'package:sana/features/azkar/domain/use_cases/get_custom_categories_use_case.dart';

void main() {
  test('loads custom categories from the repository', () async {
    const categories = [
      CustomCategoryEntity(id: 'custom_1', name: 'قسمي', azkar: []),
    ];
    final repository = _FakeRepository(categories: categories);

    final result = await GetCustomCategoriesUseCase(repository)();

    final success = result as Success<List<CustomCategoryEntity>>;
    expect(success.data.single.id, 'custom_1');
    expect(repository.getCalls, 1);
  });
}

class _FakeRepository implements CustomCategoryRepository {
  _FakeRepository({required this.categories});

  final List<CustomCategoryEntity> categories;
  int getCalls = 0;

  @override
  Future<Result<List<CustomCategoryEntity>>> getCustomCategories() async {
    getCalls++;
    return Result.success(categories);
  }

  @override
  Future<Result<void>> deleteCustomCategory(String id) async =>
      const Result.success(null);

  @override
  Future<Result<CustomCategoryEntity?>> getCustomCategoryById(
    String id,
  ) async => const Result.success(null);

  @override
  Future<Result<void>> saveCustomCategory(
    CustomCategoryEntity category,
  ) async => const Result.success(null);
}

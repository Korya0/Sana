import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/error/result.dart';
import 'package:sana/features/azkar/domain/entities/custom_category_entity.dart';
import 'package:sana/features/azkar/domain/repositories/custom_azkar_repository.dart';
import 'package:sana/features/azkar/domain/use_cases/save_custom_category_use_case.dart';

void main() {
  test('saves the category through the repository', () async {
    final repository = _FakeRepository();
    const category = CustomCategoryEntity(
      id: 'custom_1',
      name: 'قسمي',
      azkar: [],
    );

    final result = await SaveCustomCategoryUseCase(repository)(category);

    expect(result, isA<Success<void>>());
    expect(repository.saved, category);
  });
}

class _FakeRepository implements CustomAzkarRepository {
  CustomCategoryEntity? saved;

  @override
  Future<Result<void>> saveCustomCategory(
    CustomCategoryEntity category,
  ) async {
    saved = category;
    return const Result.success(null);
  }

  @override
  Future<Result<void>> deleteCustomCategory(String id) async =>
      const Result.success(null);

  @override
  Future<Result<List<CustomCategoryEntity>>> getCustomCategories() async =>
      const Result.success([]);

  @override
  Future<Result<CustomCategoryEntity?>> getCustomCategoryById(
    String id,
  ) async => const Result.success(null);
}

import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/error/result.dart';
import 'package:sana/features/azkar/domain/entities/custom_category_entity.dart';
import 'package:sana/features/azkar/domain/repositories/custom_azkar_repository.dart';
import 'package:sana/features/azkar/domain/use_cases/delete_custom_category_use_case.dart';

void main() {
  test('deletes the category through the repository', () async {
    final repository = _FakeRepository();

    final result = await DeleteCustomCategoryUseCase(repository)('custom_1');

    expect(result, isA<Success<void>>());
    expect(repository.deletedId, 'custom_1');
  });
}

class _FakeRepository implements CustomAzkarRepository {
  String? deletedId;

  @override
  Future<Result<void>> deleteCustomCategory(String id) async {
    deletedId = id;
    return const Result.success(null);
  }

  @override
  Future<Result<List<CustomCategoryEntity>>> getCustomCategories() async =>
      const Result.success([]);

  @override
  Future<Result<CustomCategoryEntity?>> getCustomCategoryById(
    String id,
  ) async => const Result.success(null);

  @override
  Future<Result<void>> saveCustomCategory(
    CustomCategoryEntity category,
  ) async => const Result.success(null);
}

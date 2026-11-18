import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/error/result.dart';
import 'package:sana/features/azkar/domain/entities/custom_category_entity.dart';
import 'package:sana/features/azkar/domain/repositories/custom_category_repository.dart';

void main() {
  group('CustomCategoryRepository', () {
    test('can be implemented as a contract', () async {
      final repository = _FakeCustomCategoryRepository();

      expect(repository, isA<CustomCategoryRepository>());
      expect(
        await repository.getCustomCategories(),
        isA<Success<List<CustomCategoryEntity>>>(),
      );
      expect(
        await repository.getCustomCategoryById('x'),
        isA<Success<CustomCategoryEntity?>>(),
      );
    });

    test('supports save, find, list, and delete operations', () async {
      final repository = _FakeCustomCategoryRepository();
      const category = CustomCategoryEntity(
        id: 'custom_1',
        name: 'ورد',
        azkar: [],
      );

      await repository.saveCustomCategory(category);
      expect(
        ((await repository.getCustomCategories())
                as Success<List<CustomCategoryEntity>>)
            .data,
        hasLength(1),
      );
      expect(
        ((await repository.getCustomCategoryById('custom_1'))
                as Success<CustomCategoryEntity?>)
            .data
            ?.id,
        'custom_1',
      );

      await repository.deleteCustomCategory('custom_1');
      expect(
        ((await repository.getCustomCategories())
                as Success<List<CustomCategoryEntity>>)
            .data,
        isEmpty,
      );
      expect(
        ((await repository.getCustomCategoryById('custom_1'))
                as Success<CustomCategoryEntity?>)
            .data,
        isNull,
      );
    });
  });
}

class _FakeCustomCategoryRepository implements CustomCategoryRepository {
  final Map<String, CustomCategoryEntity> _items = {};

  @override
  Future<Result<List<CustomCategoryEntity>>> getCustomCategories() async =>
      Result.success(_items.values.toList());

  @override
  Future<Result<void>> saveCustomCategory(CustomCategoryEntity category) async {
    _items[category.id] = category;
    return const Result.success(null);
  }

  @override
  Future<Result<void>> deleteCustomCategory(String id) async {
    _items.remove(id);
    return const Result.success(null);
  }

  @override
  Future<Result<CustomCategoryEntity?>> getCustomCategoryById(
    String id,
  ) async => Result.success(_items[id]);
}

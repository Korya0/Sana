import 'package:flutter_test/flutter_test.dart';
import 'package:sana/features/azkar/data/data_sources/custom_category_local_data_source.dart';
import 'package:sana/features/azkar/data/models/custom_category_model.dart';

void main() {
  group('CustomCategoryLocalDataSource', () {
    test('can be implemented as a contract', () async {
      final source = _FakeCustomCategoryLocalDataSource();

      expect(source, isA<CustomCategoryLocalDataSource>());
      expect(await source.getCustomCategories(), isEmpty);
      expect(await source.getCustomCategoryById('x'), isNull);
    });

    test('supports save, find, list, and delete operations', () async {
      final source = _FakeCustomCategoryLocalDataSource();
      const category = CustomCategoryModel(
        id: 'custom_1',
        name: 'ورد',
        azkar: [],
      );

      await source.saveCustomCategory(category);
      expect(await source.getCustomCategories(), hasLength(1));
      expect((await source.getCustomCategoryById('custom_1'))?.id, 'custom_1');

      await source.deleteCustomCategory('custom_1');
      expect(await source.getCustomCategories(), isEmpty);
      expect(await source.getCustomCategoryById('custom_1'), isNull);
    });
  });
}

class _FakeCustomCategoryLocalDataSource
    implements CustomCategoryLocalDataSource {
  final Map<String, CustomCategoryModel> _items = {};

  @override
  Future<List<CustomCategoryModel>> getCustomCategories() async =>
      _items.values.toList();

  @override
  Future<void> saveCustomCategory(CustomCategoryModel category) async {
    _items[category.id] = category;
  }

  @override
  Future<void> deleteCustomCategory(String id) async {
    _items.remove(id);
  }

  @override
  Future<CustomCategoryModel?> getCustomCategoryById(String id) async =>
      _items[id];
}

import 'package:flutter_test/flutter_test.dart';
import 'package:sana/features/azkar/data/data_sources/azkar_local_data_source.dart';
import 'package:sana/features/azkar/data/models/azkar_category_model.dart';
import 'package:sana/features/azkar/data/models/zikr_model.dart';

void main() {
  group('AzkarLocalDataSource', () {
    test('can be implemented as a contract', () async {
      final source = _FakeAzkarLocalDataSource();

      expect(source, isA<AzkarLocalDataSource>());
      expect(await source.getCategories(), isEmpty);
      expect(await source.getZikrsByCategory('morning'), isEmpty);
    });

    test(
      'supports returning categories and azkar through the contract',
      () async {
        final source = _FakeAzkarLocalDataSource(
          categories: const [
            AzkarCategoryModel(
              key: 'morning',
              title: 'صباح',
              cardTitle: 'صباح',
            ),
          ],
          zikrs: const [ZikrModel(id: 1, text: 'ذكر', count: 1)],
        );

        final categories = await source.getCategories();
        final zikrs = await source.getZikrsByCategory('morning');

        expect(categories.single.key, 'morning');
        expect(zikrs.single.id, 1);
      },
    );
  });
}

class _FakeAzkarLocalDataSource implements AzkarLocalDataSource {
  _FakeAzkarLocalDataSource({
    List<AzkarCategoryModel>? categories,
    List<ZikrModel>? zikrs,
  }) : _categories = categories ?? const [],
       _zikrs = zikrs ?? const [];

  final List<AzkarCategoryModel> _categories;
  final List<ZikrModel> _zikrs;

  @override
  Future<List<AzkarCategoryModel>> getCategories() async => _categories;

  @override
  Future<List<ZikrModel>> getZikrsByCategory(String categoryKey) async =>
      _zikrs;
}

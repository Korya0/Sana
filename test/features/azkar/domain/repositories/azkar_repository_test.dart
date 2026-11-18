import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/error/result.dart';
import 'package:sana/features/azkar/domain/entities/azkar_category_entity.dart';
import 'package:sana/features/azkar/domain/entities/zikr_entity.dart';
import 'package:sana/features/azkar/domain/repositories/azkar_repository.dart';

void main() {
  group('AzkarRepository', () {
    test('can be implemented as a contract', () async {
      final repository = _FakeAzkarRepository();

      expect(repository, isA<AzkarRepository>());
      expect(await repository.getCategories(), isA<Success<List<AzkarCategoryEntity>>>());
      expect(await repository.getZikrsByCategory('morning'), isA<Success<List<ZikrEntity>>>());
    });

    test('returns categories and azkar through the contract', () async {
      final repository = _FakeAzkarRepository(
        categories: const [
          AzkarCategoryEntity(key: 'morning', title: 'صباح', cardTitle: 'صباح'),
        ],
        zikrs: const [ZikrEntity(id: 1, text: 'ذكر', count: 1)],
      );

      final categories = (await repository.getCategories()) as Success<List<AzkarCategoryEntity>>;
      final zikrs = (await repository.getZikrsByCategory('morning')) as Success<List<ZikrEntity>>;

      expect(categories.data.single.key, 'morning');
      expect(zikrs.data.single.id, 1);
    });
  });
}

class _FakeAzkarRepository implements AzkarRepository {
  _FakeAzkarRepository({
    List<AzkarCategoryEntity>? categories,
    List<ZikrEntity>? zikrs,
  }) : _categories = categories ?? const [],
       _zikrs = zikrs ?? const [];

  final List<AzkarCategoryEntity> _categories;
  final List<ZikrEntity> _zikrs;

  @override
  Future<Result<List<AzkarCategoryEntity>>> getCategories() async =>
      Result.success(_categories);

  @override
  Future<Result<List<ZikrEntity>>> getZikrsByCategory(String categoryKey) async =>
      Result.success(_zikrs);
}

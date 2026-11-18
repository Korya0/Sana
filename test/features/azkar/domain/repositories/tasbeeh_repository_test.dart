import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/error/result.dart';
import 'package:sana/features/azkar/domain/entities/tasbeeh_item_entity.dart';
import 'package:sana/features/azkar/domain/repositories/tasbeeh_repository.dart';

void main() {
  group('TasbeehRepository', () {
    test('can be implemented as a contract', () async {
      final repository = _FakeTasbeehRepository();

      expect(repository, isA<TasbeehRepository>());
      expect(
        await repository.getTasbeehItems(),
        isA<Success<List<TasbeehItemEntity>>>(),
      );
    });

    test('supports save, list, and delete operations', () async {
      final repository = _FakeTasbeehRepository();
      final item = TasbeehItemEntity(
        id: '1',
        text: 'سبحان الله',
        currentCount: 0,
        lastUsedAt: DateTime(2026),
      );

      await repository.saveTasbeehItem(item);
      expect(
        ((await repository.getTasbeehItems()) as Success<List<TasbeehItemEntity>>)
            .data
            .single
            .id,
        '1',
      );

      await repository.deleteTasbeehItem('1');
      expect(
        ((await repository.getTasbeehItems()) as Success<List<TasbeehItemEntity>>)
            .data,
        isEmpty,
      );
    });
  });
}

class _FakeTasbeehRepository implements TasbeehRepository {
  final Map<String, TasbeehItemEntity> _items = {};

  @override
  Future<Result<List<TasbeehItemEntity>>> getTasbeehItems() async =>
      Result.success(_items.values.toList());

  @override
  Future<Result<void>> saveTasbeehItem(TasbeehItemEntity item) async {
    _items[item.id] = item;
    return const Result.success(null);
  }

  @override
  Future<Result<void>> deleteTasbeehItem(String id) async {
    _items.remove(id);
    return const Result.success(null);
  }
}

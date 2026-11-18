import 'package:flutter_test/flutter_test.dart';
import 'package:sana/features/azkar/data/data_sources/tasbeeh_local_data_source.dart';
import 'package:sana/features/azkar/data/models/tasbeeh_item_model.dart';

void main() {
  group('TasbeehLocalDataSource', () {
    test('can be implemented as a contract', () async {
      final source = _FakeTasbeehLocalDataSource();

      expect(source, isA<TasbeehLocalDataSource>());
      expect(await source.getTasbeehItems(), isEmpty);
    });

    test('supports save, list, and delete operations', () async {
      final source = _FakeTasbeehLocalDataSource();
      final item = TasbeehItemModel(
        id: '1',
        text: 'سبحان الله',
        currentCount: 0,
        lastUsedAt: DateTime(2026),
      );

      await source.saveTasbeehItem(item);
      expect((await source.getTasbeehItems()).single.id, '1');

      await source.deleteTasbeehItem('1');
      expect(await source.getTasbeehItems(), isEmpty);
    });
  });
}

class _FakeTasbeehLocalDataSource implements TasbeehLocalDataSource {
  final Map<String, TasbeehItemModel> _items = {};

  @override
  Future<List<TasbeehItemModel>> getTasbeehItems() async =>
      _items.values.toList();

  @override
  Future<void> saveTasbeehItem(TasbeehItemModel item) async {
    _items[item.id] = item;
  }

  @override
  Future<void> deleteTasbeehItem(String id) async {
    _items.remove(id);
  }
}

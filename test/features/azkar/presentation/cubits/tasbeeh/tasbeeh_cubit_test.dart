import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/error/failure.dart';
import 'package:sana/core/error/result.dart';
import 'package:sana/features/azkar/domain/entities/tasbeeh_item_entity.dart';
import 'package:sana/features/azkar/domain/extensions/tasbeeh_item_list_extensions.dart';
import 'package:sana/features/azkar/domain/repositories/tasbeeh_repository.dart';
import 'package:sana/features/azkar/domain/use_cases/delete_tasbeeh_item_use_case.dart';
import 'package:sana/features/azkar/domain/use_cases/get_tasbeeh_items_use_case.dart';
import 'package:sana/features/azkar/domain/use_cases/save_tasbeeh_item_use_case.dart';
import 'package:sana/features/azkar/presentation/cubits/common/counter_increment_result.dart';
import 'package:sana/features/azkar/presentation/cubits/tasbeeh/tasbeeh_cubit.dart';
import 'package:sana/features/azkar/presentation/cubits/tasbeeh/tasbeeh_state.dart';

void main() {
  final now = DateTime(2026, 11, 17);

  TasbeehItemEntity item({
    required String id,
    int count = 0,
    int? target,
    DateTime? usedAt,
  }) => TasbeehItemEntity(
    id: id,
    text: id,
    currentCount: count,
    targetCount: target,
    lastUsedAt: usedAt ?? now,
  );

  test('loads items and selects the most recently used', () async {
    final repository = _FakeRepository([
      item(id: 'a', usedAt: now.subtract(const Duration(days: 1))),
      item(id: 'b', usedAt: now),
    ]);
    final cubit = _createCubit(repository);

    await cubit.loadItems();

    final state = cubit.state as TasbeehLoaded;
    expect(state.selectedItemId, 'b');
    expect(state.selectedItem?.id, 'b');
  });

  test('honors an explicit selectedItemId when it exists', () async {
    final repository = _FakeRepository([
      item(id: 'a', usedAt: now.subtract(const Duration(days: 1))),
      item(id: 'b', usedAt: now),
    ]);
    final cubit = _createCubit(repository);

    await cubit.loadItems(selectedItemId: 'a');

    expect((cubit.state as TasbeehLoaded).selectedItemId, 'a');
  });

  test('empty list leaves selection null', () async {
    final cubit = _createCubit(_FakeRepository([]));

    await cubit.loadItems();

    final state = cubit.state as TasbeehLoaded;
    expect(state.items, isEmpty);
    expect(state.selectedItemId, isNull);
  });

  test(
    'increment raises count, selects the item and reports completion',
    () async {
      final repository = _FakeRepository([item(id: 'a', count: 1, target: 2)]);
      final cubit = _createCubit(repository);
      await cubit.loadItems();
      cubit.selectItem('a');

      final result = await cubit.increment('a');

      expect(result, isA<CounterCompleted>());
      final state = cubit.state as TasbeehLoaded;
      expect(state.items.byId('a')!.currentCount, 2);
      expect(state.selectedItemId, 'a');
      expect(repository.saved.single.currentCount, 2);
    },
  );

  test('increment ignores an item already at its target', () async {
    final repository = _FakeRepository([item(id: 'a', count: 2, target: 2)]);
    final cubit = _createCubit(repository);
    await cubit.loadItems();

    final result = await cubit.increment('a');

    expect(result, isA<CounterIgnored>());
    expect(repository.saved, isEmpty);
  });

  test('failed increment reverts only the affected item', () async {
    final repository = _FakeRepository(
      [item(id: 'a', count: 0, target: 3), item(id: 'b', count: 5)],
      saveFailure: true,
    );
    final cubit = _createCubit(repository);
    await cubit.loadItems();
    cubit.selectItem('b');

    final result = await cubit.increment('a');

    expect(result, isA<CounterIgnored>());
    final state = cubit.state as TasbeehLoaded;
    expect(state.items.byId('a')!.currentCount, 0);
    expect(state.items.byId('b')!.currentCount, 5);
    expect(state.selectedItemId, 'a');
  });

  test('reset returns the counter to zero', () async {
    final repository = _FakeRepository([item(id: 'a', count: 4, target: 10)]);
    final cubit = _createCubit(repository);
    await cubit.loadItems();

    await cubit.resetCounter('a');

    expect((cubit.state as TasbeehLoaded).items.byId('a')!.currentCount, 0);
    expect(repository.saved.single.currentCount, 0);
  });

  test('updating an item clamps its count to a lowered target', () async {
    final repository = _FakeRepository([item(id: 'a', count: 8, target: 10)]);
    final cubit = _createCubit(repository);
    await cubit.loadItems();

    await cubit.updateItem(
      id: 'a',
      text: 'updated',
      targetCount: () => 5,
    );

    final updated = (cubit.state as TasbeehLoaded).items.byId('a')!;
    expect(updated.currentCount, 5);
    expect(updated.targetCount, 5);
    expect(updated.text, 'updated');
  });

  test('delete reloads the remaining items', () async {
    final repository = _FakeRepository([
      item(id: 'a'),
      item(id: 'b'),
    ]);
    final cubit = _createCubit(repository);
    await cubit.loadItems();

    final result = await cubit.deleteTasbeehItem('a');

    expect(result, isA<Success<void>>());
    expect((cubit.state as TasbeehLoaded).items.map((e) => e.id), ['b']);
  });

  test('addItem creates an item and selects it', () async {
    final repository = _FakeRepository([]);
    final cubit = _createCubit(repository);
    await cubit.loadItems();

    final result = await cubit.addItem(text: '  ذكر جديد  ', targetCount: 33);

    expect(result, isA<Success<void>>());
    final state = cubit.state as TasbeehLoaded;
    expect(state.items, hasLength(1));
    expect(state.items.single.text, 'ذكر جديد');
    expect(state.items.single.targetCount, 33);
    expect(state.selectedItemId, state.items.single.id);
  });
}

TasbeehCubit _createCubit(_FakeRepository repository) => TasbeehCubit(
  GetTasbeehItemsUseCase(repository),
  SaveTasbeehItemUseCase(repository),
  DeleteTasbeehItemUseCase(repository),
);

class _FakeRepository implements TasbeehRepository {
  _FakeRepository(this.items, {this.saveFailure = false});

  List<TasbeehItemEntity> items;
  final bool saveFailure;
  final List<TasbeehItemEntity> saved = [];
  final List<String> deleted = [];

  @override
  Future<Result<List<TasbeehItemEntity>>> getTasbeehItems() async =>
      Result.success(List.of(items));

  @override
  Future<Result<void>> saveTasbeehItem(TasbeehItemEntity item) async {
    if (saveFailure) {
      return const Result.failure(CacheFailure(message: 'save failed'));
    }
    saved.add(item);
    final index = items.indexWhere((existing) => existing.id == item.id);
    if (index >= 0) {
      items = List.of(items)..[index] = item;
    } else {
      items = [item, ...items];
    }
    return const Result.success(null);
  }

  @override
  Future<Result<void>> deleteTasbeehItem(String id) async {
    deleted.add(id);
    items = items.where((item) => item.id != id).toList();
    return const Result.success(null);
  }
}

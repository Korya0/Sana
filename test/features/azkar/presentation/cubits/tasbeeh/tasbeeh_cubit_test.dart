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

  test('increment starts a new target cycle at one after completion', () async {
    final repository = _FakeRepository([item(id: 'a', count: 2, target: 2)]);
    final cubit = _createCubit(repository);
    await cubit.loadItems();

    final result = await cubit.increment('a');

    expect(result, isA<CounterIncremented>());
    expect((cubit.state as TasbeehLoaded).items.byId('a')!.currentCount, 1);
    expect(repository.saved.single.currentCount, 1);
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

  test('free counting stops at four digits', () async {
    final repository = _FakeRepository([item(id: 'a', count: 9999)]);
    final cubit = _createCubit(repository);
    await cubit.loadItems();

    final result = await cubit.increment('a');

    expect(result, isA<CounterIgnored>());
    expect((cubit.state as TasbeehLoaded).items.byId('a')!.currentCount, 9999);
    expect(repository.saved, isEmpty);
  });

  test('reset returns the counter to zero', () async {
    final repository = _FakeRepository([item(id: 'a', count: 4, target: 10)]);
    final cubit = _createCubit(repository);
    await cubit.loadItems();

    final result = await cubit.resetCounter('a');

    expect(result, isA<Success<void>>());
    expect((cubit.state as TasbeehLoaded).items.byId('a')!.currentCount, 0);
    expect(repository.saved.single.currentCount, 0);
  });

  test('failed reset reverts the count and returns the failure', () async {
    final repository = _FakeRepository(
      [item(id: 'a', count: 4, target: 10)],
      saveFailure: true,
    );
    final cubit = _createCubit(repository);
    await cubit.loadItems();

    final result = await cubit.resetCounter('a');

    expect(result, isA<FailureResult<void>>());
    expect((cubit.state as TasbeehLoaded).items.byId('a')!.currentCount, 4);
  });

  test('updating an item clamps its count to a lowered target', () async {
    final repository = _FakeRepository([item(id: 'a', count: 8, target: 10)]);
    final cubit = _createCubit(repository);
    await cubit.loadItems();

    await cubit.updateItem(
      id: 'a',
      text: '  updated   zikr\n text  ',
      targetCount: () => 5,
    );

    final updated = (cubit.state as TasbeehLoaded).items.byId('a')!;
    expect(updated.currentCount, 5);
    expect(updated.targetCount, 5);
    expect(updated.text, 'updated zikr text');
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

    final result = await cubit.addItem(
      text: '  ذكر    جديد\n  ومفيد  ',
      targetCount: 33,
    );

    expect(result, isA<Success<void>>());
    final state = cubit.state as TasbeehLoaded;
    expect(state.items, hasLength(1));
    expect(state.items.single.text, 'ذكر جديد ومفيد');
    expect(state.items.single.targetCount, 33);
    expect(state.selectedItemId, state.items.single.id);
  });

  test('load failure emits an error state', () async {
    final repository = _FakeRepository([])..getFailure = true;
    final cubit = _createCubit(repository);

    await cubit.loadItems();

    expect(cubit.state, isA<TasbeehError>());
    expect((cubit.state as TasbeehError).message, 'load failed');
  });

  test('add failure returns the failure and keeps the current state', () async {
    final repository = _FakeRepository([], saveFailure: true);
    final cubit = _createCubit(repository);
    await cubit.loadItems();

    final result = await cubit.addItem(text: 'new');

    expect(result, isA<FailureResult<void>>());
    final state = cubit.state as TasbeehLoaded;
    expect(state.items, isEmpty);
  });

  test('update failure returns the failure and keeps the old values', () async {
    final repository = _FakeRepository(
      [item(id: 'a', count: 1, target: 10)],
      saveFailure: true,
    );
    final cubit = _createCubit(repository);
    await cubit.loadItems();

    final result = await cubit.updateItem(id: 'a', text: 'changed');

    expect(result, isA<FailureResult<void>>());
    final updated = (cubit.state as TasbeehLoaded).items.byId('a')!;
    expect(updated.text, 'a');
    expect(updated.currentCount, 1);
  });

  test('delete failure returns the failure and keeps the item', () async {
    final repository = _FakeRepository(
      [item(id: 'a'), item(id: 'b')],
      deleteFailure: true,
    );
    final cubit = _createCubit(repository);
    await cubit.loadItems();

    final result = await cubit.deleteTasbeehItem('a');

    expect(result, isA<FailureResult<void>>());
    final state = cubit.state as TasbeehLoaded;
    expect(state.items.map((e) => e.id), ['a', 'b']);
  });

  test('delete refresh failure keeps the loaded list', () async {
    final repository = _FakeRepository([item(id: 'a'), item(id: 'b')]);
    final cubit = _createCubit(repository);
    await cubit.loadItems();
    repository.getFailure = true;
    final emittedStates = <TasbeehState>[];
    final subscription = cubit.stream.listen(emittedStates.add);

    final result = await cubit.deleteTasbeehItem('a');
    await Future<void>.delayed(Duration.zero);

    expect(result, isA<Success<void>>());
    expect(cubit.state, isA<TasbeehLoaded>());
    expect((cubit.state as TasbeehLoaded).items, hasLength(2));
    expect(emittedStates.whereType<TasbeehError>(), isEmpty);

    await subscription.cancel();
  });

  test('post-mutation refresh failure keeps the loaded state', () async {
    final repository = _FakeRepository([item(id: 'a', count: 1)]);
    final cubit = _createCubit(repository);
    await cubit.loadItems();
    repository.getFailure = true;
    final emittedStates = <TasbeehState>[];
    final subscription = cubit.stream.listen(emittedStates.add);

    final result = await cubit.addItem(text: 'new');
    await Future<void>.delayed(Duration.zero);

    expect(result, isA<Success<void>>());
    expect(cubit.state, isA<TasbeehLoaded>());
    expect(emittedStates.whereType<TasbeehError>(), isEmpty);

    await subscription.cancel();
  });

  test('item mutations refresh without emitting a loading state', () async {
    final cubit = _createCubit(_FakeRepository([item(id: 'a')]));
    await cubit.loadItems();
    final emittedStates = <TasbeehState>[];
    final subscription = cubit.stream.listen(emittedStates.add);

    await cubit.updateItem(id: 'a', text: 'updated');
    await cubit.addItem(text: 'new');
    await cubit.deleteTasbeehItem('a');
    await Future<void>.delayed(Duration.zero);

    expect(emittedStates.whereType<TasbeehLoading>(), isEmpty);
    expect(emittedStates.whereType<TasbeehLoaded>(), hasLength(3));
    expect((cubit.state as TasbeehLoaded).items, hasLength(1));

    await subscription.cancel();
  });
}

TasbeehCubit _createCubit(_FakeRepository repository) => TasbeehCubit(
  GetTasbeehItemsUseCase(repository),
  SaveTasbeehItemUseCase(repository),
  DeleteTasbeehItemUseCase(repository),
);

class _FakeRepository implements TasbeehRepository {
  _FakeRepository(
    this.items, {
    this.saveFailure = false,
    this.deleteFailure = false,
  });

  List<TasbeehItemEntity> items;
  final bool saveFailure;
  final bool deleteFailure;
  bool getFailure = false;
  final List<TasbeehItemEntity> saved = [];
  final List<String> deleted = [];

  @override
  Future<Result<List<TasbeehItemEntity>>> getTasbeehItems() async =>
      getFailure
      ? const Result.failure(CacheFailure(message: 'load failed'))
      : Result.success(List.of(items));

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
    if (deleteFailure) {
      return const Result.failure(CacheFailure(message: 'delete failed'));
    }
    deleted.add(id);
    items = items.where((item) => item.id != id).toList();
    return const Result.success(null);
  }
}

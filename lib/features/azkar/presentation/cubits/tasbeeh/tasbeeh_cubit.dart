import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/error/result.dart';
import 'package:sana/features/azkar/domain/entities/tasbeeh_item_entity.dart';
import 'package:sana/features/azkar/domain/extensions/tasbeeh_item_list_extensions.dart';
import 'package:sana/features/azkar/domain/use_cases/delete_tasbeeh_item_use_case.dart';
import 'package:sana/features/azkar/domain/use_cases/get_tasbeeh_items_use_case.dart';
import 'package:sana/features/azkar/domain/use_cases/save_tasbeeh_item_use_case.dart';
import 'package:sana/features/azkar/presentation/cubits/common/counter_increment_result.dart';
import 'package:sana/features/azkar/presentation/cubits/tasbeeh/tasbeeh_state.dart';

class TasbeehCubit extends Cubit<TasbeehState> {
  // Creates cubit
  TasbeehCubit(
    this._getTasbeehItems,
    this._saveTasbeehItem,
    this._deleteTasbeehItem,
  ) : super(TasbeehInitial());

  final GetTasbeehItemsUseCase _getTasbeehItems;
  final SaveTasbeehItemUseCase _saveTasbeehItem;
  final DeleteTasbeehItemUseCase _deleteTasbeehItem;

  // Loads items
  Future<void> loadItems({String? selectedItemId}) async {
    emit(TasbeehLoading());
    final result = await _getTasbeehItems();
    if (isClosed) return;

    switch (result) {
      case Success(data: final items):
        final resolvedSelected = _resolveSelectedItemId(items, selectedItemId);
        emit(TasbeehLoaded(items: items, selectedItemId: resolvedSelected));
      case FailureResult(:final failure):
        emit(TasbeehError(failure.message));
    }
  }

  // Selects item
  void selectItem(String id) {
    final current = state;
    if (current is! TasbeehLoaded) return;
    if (current.selectedItemId == id) return;
    emit(current.copyWith(selectedItemId: () => id));
  }

  // Adds item
  Future<Result<void>> addItem({
    required String text,
    int? targetCount,
  }) async {
    final now = DateTime.now();
    final item = TasbeehItemEntity(
      id: 'tasbeeh_${now.microsecondsSinceEpoch}',
      text: text.trim(),
      currentCount: 0,
      targetCount: targetCount,
      lastUsedAt: now,
      isCustom: true,
    );
    return _saveAndReload(item, selectedItemId: item.id);
  }

  // Updates item
  Future<Result<void>> updateItem({
    required String id,
    required String text,
    int? Function()? targetCount,
  }) async {
    final current = state;
    if (current is! TasbeehLoaded) return const Result.success(null);
    final existing = current.items.byId(id);
    if (existing == null) return const Result.success(null);

    final newTarget = targetCount != null
        ? targetCount()
        : existing.targetCount;
    var newCount = existing.currentCount;
    if (newTarget != null && newCount > newTarget) {
      newCount = newTarget;
    }
    final updated = existing.copyWith(
      text: text.trim(),
      targetCount: () => newTarget,
      currentCount: newCount,
      lastUsedAt: DateTime.now(),
    );
    return _saveAndReload(updated, selectedItemId: id);
  }

  // Increments item
  Future<CounterIncrementResult> increment(String id) async {
    final current = state;
    if (current is! TasbeehLoaded) return const CounterIgnored();
    final existing = current.items.byId(id);
    if (existing == null) return const CounterIgnored();

    if (existing.targetCount != null &&
        existing.currentCount >= existing.targetCount!) {
      return const CounterIgnored();
    }

    final newCount = existing.currentCount + 1;
    final updated = existing.copyWith(
      currentCount: newCount,
      lastUsedAt: DateTime.now(),
    );

    // Optimistic update
    final updatedItems = current.items
        .map((item) => item.id == id ? updated : item)
        .toList();
    emit(current.copyWith(items: updatedItems, selectedItemId: () => id));

    final result = await _saveTasbeehItem(updated);
    if (isClosed) {
      return existing.targetCount != null && newCount >= existing.targetCount!
          ? const CounterCompleted()
          : const CounterIncremented();
    }
    if (result is FailureResult<void>) {
      // Reverts only the affected item
      final latest = state;
      if (latest is TasbeehLoaded) {
        emit(
          latest.copyWith(
            items: latest.items
                .map((item) => item.id == id ? existing : item)
                .toList(),
          ),
        );
      }
      return const CounterIgnored();
    }

    if (existing.targetCount != null && newCount >= existing.targetCount!) {
      return const CounterCompleted();
    }
    return const CounterIncremented();
  }

  // Resets item
  Future<void> resetCounter(String id) async {
    final current = state;
    if (current is! TasbeehLoaded) return;
    final existing = current.items.byId(id);
    if (existing == null || existing.currentCount == 0) return;

    final updated = existing.copyWith(
      currentCount: 0,
      lastUsedAt: DateTime.now(),
    );
    final updatedItems = current.items
        .map((item) => item.id == id ? updated : item)
        .toList();
    emit(current.copyWith(items: updatedItems));

    final result = await _saveTasbeehItem(updated);
    if (!isClosed && result is FailureResult<void>) {
      final latest = state;
      if (latest is TasbeehLoaded) {
        emit(
          latest.copyWith(
            items: latest.items
                .map((item) => item.id == id ? existing : item)
                .toList(),
          ),
        );
      }
    }
  }

  // Deletes item
  Future<Result<void>> deleteTasbeehItem(String id) async {
    final result = await _deleteTasbeehItem(id);
    if (isClosed) return result;
    if (result is Success<void>) {
      await loadItems();
    }
    return result;
  }

  // Saves and reloads
  Future<Result<void>> _saveAndReload(
    TasbeehItemEntity item, {
    String? selectedItemId,
  }) async {
    final result = await _saveTasbeehItem(item);
    if (isClosed) return result;
    if (result is Success<void>) {
      await loadItems(selectedItemId: selectedItemId ?? item.id);
    }
    return result;
  }

  // Resolves selection
  String? _resolveSelectedItemId(
    List<TasbeehItemEntity> items,
    String? selectedItemId,
  ) {
    if (items.isEmpty) return null;
    if (selectedItemId != null && items.byId(selectedItemId) != null) {
      return selectedItemId;
    }
    final sorted = List<TasbeehItemEntity>.of(items)
      ..sort((a, b) => b.lastUsedAt.compareTo(a.lastUsedAt));
    return sorted.first.id;
  }
}

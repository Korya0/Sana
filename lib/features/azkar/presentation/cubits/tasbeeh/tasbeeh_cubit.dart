import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/error/result.dart';
import 'package:sana/features/azkar/domain/entities/tasbeeh_item_entity.dart';
import 'package:sana/features/azkar/domain/use_cases/delete_tasbeeh_item_use_case.dart';
import 'package:sana/features/azkar/domain/use_cases/get_tasbeeh_items_use_case.dart';
import 'package:sana/features/azkar/domain/use_cases/save_tasbeeh_item_use_case.dart';
import 'package:sana/features/azkar/presentation/cubits/azkar/zikr_increment_result.dart';
import 'package:sana/features/azkar/presentation/cubits/tasbeeh/tasbeeh_state.dart';

class TasbeehCubit extends Cubit<TasbeehState> {
  // Creates cubit
  TasbeehCubit(
    this._getItems,
    this._saveItem,
    this._deleteItem,
  ) : super(TasbeehInitial());

  final GetTasbeehItemsUseCase _getItems;
  final SaveTasbeehItemUseCase _saveItem;
  final DeleteTasbeehItemUseCase _deleteItem;

  // Loads items
  Future<void> loadItems({String? selectId}) async {
    emit(TasbeehLoading());
    final result = await _getItems();
    if (isClosed) return;

    switch (result) {
      case Success(data: final items):
        final resolvedSelected = _resolveSelectedId(items, selectId);
        emit(TasbeehLoaded(items: items, selectedId: resolvedSelected));
      case FailureResult(:final failure):
        emit(TasbeehError(failure.message));
    }
  }

  // Selects item
  void selectItem(String id) {
    final current = state;
    if (current is! TasbeehLoaded) return;
    if (current.selectedId == id) return;
    emit(current.copyWith(selectedId: () => id));
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
    return _saveAndReload(item, selectId: item.id);
  }

  // Updates item
  Future<Result<void>> updateItem({
    required String id,
    required String text,
    int? Function()? targetCount,
  }) async {
    final current = state;
    if (current is! TasbeehLoaded) return const Result.success(null);
    TasbeehItemEntity? existing;
    for (final item in current.items) {
      if (item.id == id) {
        existing = item;
        break;
      }
    }
    if (existing == null) return const Result.success(null);

    final newTarget = targetCount != null ? targetCount() : existing.targetCount;
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
    return _saveAndReload(updated, selectId: id);
  }

  // Increments item
  Future<ZikrIncrementResult> increment(String id) async {
    final current = state;
    if (current is! TasbeehLoaded) return const ZikrIgnored();
    TasbeehItemEntity? existing;
    for (final item in current.items) {
      if (item.id == id) {
        existing = item;
        break;
      }
    }
    if (existing == null) return const ZikrIgnored();

    if (existing.targetCount != null &&
        existing.currentCount >= existing.targetCount!) {
      return const ZikrIgnored();
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
    emit(current.copyWith(items: updatedItems, selectedId: () => id));

    final result = await _saveItem(updated);
    if (isClosed) {
      return existing.targetCount != null && newCount >= existing.targetCount!
          ? const ZikrCompleted()
          : const ZikrIncremented();
    }
    if (result is FailureResult<void>) {
      // Revert on failure
      emit(current);
      return const ZikrIgnored();
    }

    if (existing.targetCount != null && newCount >= existing.targetCount!) {
      return const ZikrCompleted();
    }
    return const ZikrIncremented();
  }

  // Resets item
  Future<void> resetCounter(String id) async {
    final current = state;
    if (current is! TasbeehLoaded) return;
    TasbeehItemEntity? existing;
    for (final item in current.items) {
      if (item.id == id) {
        existing = item;
        break;
      }
    }
    if (existing == null || existing.currentCount == 0) return;

    final updated = existing.copyWith(
      currentCount: 0,
      lastUsedAt: DateTime.now(),
    );
    final updatedItems = current.items
        .map((item) => item.id == id ? updated : item)
        .toList();
    emit(current.copyWith(items: updatedItems));

    final result = await _saveItem(updated);
    if (!isClosed && result is FailureResult<void>) {
      emit(current);
    }
  }

  // Deletes item
  Future<Result<void>> deleteItem(String id) async {
    final result = await _deleteItem(id);
    if (result is Success<void>) {
      await loadItems();
    }
    return result;
  }

  // Saves and reloads
  Future<Result<void>> _saveAndReload(
    TasbeehItemEntity item, {
    String? selectId,
  }) async {
    final result = await _saveItem(item);
    if (result is Success<void>) {
      await loadItems(selectId: selectId ?? item.id);
    }
    return result;
  }

  // Resolves selection
  String? _resolveSelectedId(List<TasbeehItemEntity> items, String? selectId) {
    if (items.isEmpty) return null;
    if (selectId != null) {
      for (final item in items) {
        if (item.id == selectId) return selectId;
      }
    }
    final sorted = List<TasbeehItemEntity>.of(items)
      ..sort((a, b) => b.lastUsedAt.compareTo(a.lastUsedAt));
    return sorted.first.id;
  }
}

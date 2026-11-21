import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/error/failure.dart';
import 'package:sana/core/error/result.dart';
import 'package:sana/core/utils/app_validators.dart';
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
  static final RegExp _whitespace = RegExp(r'\s+');

  // Loads items
  Future<void> loadItems({String? selectedItemId}) async {
    emit(TasbeehLoading());
    await _refreshItems(selectedItemId: selectedItemId);
  }

  // Refreshes items without replacing the current UI
  Future<void> _refreshItems({
    String? selectedItemId,
    bool emitError = true,
  }) async {
    final result = await _getTasbeehItems();
    if (isClosed) return;

    switch (result) {
      case Success(data: final items):
        final resolvedSelected = _resolveSelectedItemId(items, selectedItemId);
        emit(TasbeehLoaded(items: items, selectedItemId: resolvedSelected));
      case FailureResult(:final failure):
        if (emitError) emit(TasbeehError(failure.message));
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
    final error = _validateText(text) ?? _validateTarget(targetCount);
    if (error != null) {
      return FailureResult(CacheFailure(message: error));
    }

    final now = DateTime.now();
    final item = TasbeehItemEntity(
      id: 'tasbeeh_${now.microsecondsSinceEpoch}',
      text: _normalizeText(text),
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

    final requestedTarget = targetCount != null ? targetCount() : null;
    final error =
        _validateText(text, exceptId: id) ??
        _validateTarget(requestedTarget);
    if (error != null) {
      return FailureResult(CacheFailure(message: error));
    }

    final newTarget = targetCount != null ? requestedTarget : existing.targetCount;
    var newCount = existing.currentCount;
    if (newTarget != null && newCount > newTarget) {
      newCount = newTarget;
    }
    final updated = existing.copyWith(
      text: _normalizeText(text),
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

    final targetReached = existing.isCompleted;
    if (existing.currentCount >= AppConstants.tasbeehMaxCount &&
        !targetReached) {
      return const CounterIgnored();
    }

    final newCount = targetReached ? 1 : existing.currentCount + 1;
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

  // Decrements item without going below zero
  Future<bool> decrement(String id) async {
    final current = state;
    if (current is! TasbeehLoaded) return false;
    final existing = current.items.byId(id);
    if (existing == null || existing.currentCount <= 0) return false;

    final updated = existing.copyWith(
      currentCount: existing.currentCount - 1,
    );
    final updatedItems = current.items
        .map((item) => item.id == id ? updated : item)
        .toList();
    emit(current.copyWith(items: updatedItems, selectedItemId: () => id));

    final result = await _saveTasbeehItem(updated);
    if (isClosed) return true;
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
      return false;
    }

    return true;
  }

  // Resets item
  Future<Result<void>> resetCounter(String id) async {
    final current = state;
    if (current is! TasbeehLoaded) return const Result.success(null);
    final existing = current.items.byId(id);
    if (existing == null || existing.currentCount == 0) {
      return const Result.success(null);
    }

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
    return result;
  }

  // Deletes item
  Future<Result<void>> deleteTasbeehItem(String id) async {
    final result = await _deleteTasbeehItem(id);
    if (isClosed) return result;
    if (result is Success<void>) {
      await _refreshItems(emitError: false);
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
      await _refreshItems(
        selectedItemId: selectedItemId ?? item.id,
        emitError: false,
      );
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

  // collapses repeated whitespace
  String _normalizeText(String text) =>
      text.trim().replaceAll(_whitespace, ' ');

  // Validates a tasbeeh before it reaches storage.
  String? _validateText(String text, {String? exceptId}) {
    final short = AppStrings.tooShortText(AppConstants.minTextLength);
    final current = state;
    final existing = current is TasbeehLoaded
        ? current.items
            .where((item) => item.id != exceptId)
            .map((item) => item.text)
            .toSet()
        : <String>{};

    return AppValidators.requiredField(
          text,
          AppStrings.tasbeehNameRequired,
        ) ??
        AppValidators.arabicLetters(text, AppStrings.arabicLettersRequired) ??
        AppValidators.minLetters(text, AppConstants.minTextLength, short) ??
        AppValidators.duplicate(
          text,
          existing,
          AppStrings.tasbeehTextDuplicate,
        );
  }

  // Validates an optional target count.
  String? _validateTarget(int? target) {
    if (target == null) return null;
    if (target <= 0) return AppStrings.targetCountGreaterThanZero;
    if (target > AppConstants.tasbeehMaxCount) {
      return AppStrings.tasbeehTargetMaxError(AppConstants.tasbeehMaxCount);
    }
    return null;
  }
}

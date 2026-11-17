import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/error/result.dart';
import 'package:sana/features/azkar/domain/extensions/custom_category_id_extension.dart';
import 'package:sana/features/azkar/domain/entities/azkar_category_entity.dart';
import 'package:sana/features/azkar/domain/entities/custom_category_entity.dart';
import 'package:sana/features/azkar/domain/entities/zikr_entity.dart';
import 'package:sana/features/azkar/domain/repositories/custom_category_repository.dart';
import 'package:sana/features/azkar/domain/use_cases/delete_custom_category_use_case.dart';
import 'package:sana/features/azkar/domain/use_cases/get_zikrs_by_category_use_case.dart';
import 'package:sana/features/azkar/domain/use_cases/get_azkar_categories_use_case.dart';
import 'package:sana/features/azkar/presentation/cubits/azkar/azkar_state.dart';
import 'package:sana/features/azkar/presentation/cubits/common/counter_increment_result.dart';

class AzkarCubit extends Cubit<AzkarState> {
  // Creates cubit
  AzkarCubit(
    this._getZikrsByCategoryUseCase,
    this._getCategoriesUseCase,
    this._deleteCustomCategoryUseCase,
    this._customCategoryRepository,
  ) : super(AzkarInitial());

  final GetZikrsByCategoryUseCase _getZikrsByCategoryUseCase;
  final GetAzkarCategoriesUseCase _getCategoriesUseCase;
  final DeleteCustomCategoryUseCase _deleteCustomCategoryUseCase;
  final CustomCategoryRepository _customCategoryRepository;

  // Loads azkar
  Future<void> loadAzkar(
    String categoryKey, {
    required String categoryTitle,
  }) async {
    emit(AzkarLoading());

    final result = await _getZikrsByCategoryUseCase(categoryKey);
    if (isClosed) return;

    switch (result) {
      case Success(data: final azkar):
        if (azkar.isEmpty) {
          emit(AzkarEmpty());
          return;
        }
        final isCustom = categoryKey.isCustomCategoryId;
        var isModified = false;
        if (!isCustom) {
          final customCheck = await _customCategoryRepository
              .getCustomCategoryById(categoryKey);
          if (isClosed) return;
          isModified =
              customCheck is Success<CustomCategoryEntity?> &&
              customCheck.data != null;
        }

        final resolvedTitle = await _resolveTitle(categoryKey, categoryTitle);
        if (isClosed) return;

        emit(
          AzkarLoaded(
            azkar: azkar,
            counters: {for (final ZikrEntity zikr in azkar) zikr.id: 0},
            resolvedTitle: resolvedTitle,
            isCustom: isCustom,
            isModified: isModified,
          ),
        );
      case FailureResult(:final failure):
        emit(AzkarError(failure.message));
    }
  }

  // Increments zikr
  CounterIncrementResult incrementZikr(int zikrId) {
    final currentState = state;
    if (currentState is! AzkarLoaded) return const CounterIgnored();

    final index = currentState.azkar.indexWhere((zikr) => zikr.id == zikrId);
    if (index == -1) return const CounterIgnored();

    final zikr = currentState.azkar[index];
    final currentCount = currentState.counters[zikrId] ?? 0;
    if (currentCount >= zikr.count) return const CounterIgnored();

    final newCount = currentCount + 1;
    emit(
      currentState.copyWith(
        counters: {...currentState.counters, zikrId: newCount},
      ),
    );

    if (newCount >= zikr.count) {
      return const CounterCompleted();
    }

    return const CounterIncremented();
  }

  // Resets counter
  void resetCounter(int zikrId) {
    final currentState = state;
    if (currentState is! AzkarLoaded) return;

    emit(
      currentState.copyWith(
        counters: {...currentState.counters, zikrId: 0},
      ),
    );
  }

  // Applies updates
  void applyCategoryUpdate(
    List<ZikrEntity> azkar, {
    required bool isModified,
    String? resolvedTitle,
  }) {
    final currentState = state;
    if (currentState is! AzkarLoaded) return;

    final updatedCounters = <int, int>{};
    for (final zikr in azkar) {
      final previousCount = currentState.counters[zikr.id] ?? 0;
      updatedCounters[zikr.id] = previousCount > zikr.count
          ? zikr.count
          : previousCount;
    }

    emit(
      currentState.copyWith(
        azkar: azkar,
        counters: updatedCounters,
        resolvedTitle: resolvedTitle,
        isModified: isModified,
      ),
    );
  }

  // Applies a saved category
  void applySavedCategory(CustomCategoryEntity saved) {
    final current = state;
    if (current is! AzkarLoaded) return;
    applyCategoryUpdate(
      saved.azkar,
      isModified: !current.isCustom,
      resolvedTitle: saved.name,
    );
  }

  // Resets category
  Future<Result<void>> restoreCategory(
    String categoryKey, {
    required String categoryTitle,
  }) async {
    final result = await _deleteCustomCategoryUseCase(categoryKey);
    if (isClosed) return result;
    switch (result) {
      case Success():
        await loadAzkar(categoryKey, categoryTitle: categoryTitle);
        return const Result.success(null);
      case FailureResult():
        return result;
    }
  }

  // Deletes category
  Future<Result<void>> deleteCustomCategory(String categoryKey) =>
      _deleteCustomCategoryUseCase(categoryKey);

  // Resolves title
  Future<String> _resolveTitle(String categoryKey, String fallback) async {
    final isBuiltIn = !categoryKey.isCustomCategoryId;
    // Built-in names are app-owned; never trust a caller-supplied title.
    if (!isBuiltIn) {
      if (fallback != AppStrings.azkarHeader) return fallback;

      // Deep links may lack a title, so resolve the stored custom name.
      final custom = await _customCategoryRepository.getCustomCategoryById(
        categoryKey,
      );
      if (isClosed) return fallback;
      if (custom is Success<CustomCategoryEntity?>) {
        final category = custom.data;
        if (category != null) return category.name;
      }
      return fallback;
    }

    final result = await _getCategoriesUseCase();
    if (isClosed || result is! Success<List<AzkarCategoryEntity>>) {
      return fallback;
    }

    for (final category in result.data) {
      if (category.key == categoryKey) return category.title;
    }
    return fallback;
  }
}

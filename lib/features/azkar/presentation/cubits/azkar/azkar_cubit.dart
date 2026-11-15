import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/error/result.dart';
import 'package:sana/features/azkar/data/constants/azkar_constants.dart';
import 'package:sana/features/azkar/domain/entities/azkar_category_entity.dart';
import 'package:sana/features/azkar/domain/entities/custom_category_entity.dart';
import 'package:sana/features/azkar/domain/entities/zikr_entity.dart';
import 'package:sana/features/azkar/domain/repositories/custom_azkar_repository.dart';
import 'package:sana/features/azkar/domain/use_cases/delete_custom_category_use_case.dart';
import 'package:sana/features/azkar/domain/use_cases/get_azkar_by_category_use_case.dart';
import 'package:sana/features/azkar/domain/use_cases/get_azkar_categories_use_case.dart';
import 'package:sana/features/azkar/presentation/cubits/azkar/azkar_state.dart';
import 'package:sana/features/azkar/presentation/cubits/azkar/zikr_increment_result.dart';

class AzkarCubit extends Cubit<AzkarState> {
  // Creates cubit
  AzkarCubit(
    this._getAzkarByCategoryUseCase,
    this._getCategoriesUseCase,
    this._deleteCustomCategoryUseCase,
    this._customAzkarRepository,
  ) : super(AzkarInitial());

  final GetAzkarByCategoryUseCase _getAzkarByCategoryUseCase;
  final GetAzkarCategoriesUseCase _getCategoriesUseCase;
  final DeleteCustomCategoryUseCase _deleteCustomCategoryUseCase;
  final CustomAzkarRepository _customAzkarRepository;

  // Loads azkar
  Future<void> loadAzkar(
    String categoryKey, {
    required String categoryTitle,
  }) async {
    emit(AzkarLoading());

    final result = await _getAzkarByCategoryUseCase(categoryKey);
    if (isClosed) return;

    switch (result) {
      case Success(data: final azkar):
        if (azkar.isEmpty) {
          emit(AzkarEmpty());
          return;
        }
        final isCustom = categoryKey.startsWith(customCategoryIdPrefix);
        var isModified = false;
        if (!isCustom) {
          final customCheck = await _customAzkarRepository
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
  ZikrIncrementResult incrementZikr(int zikrId) {
    final currentState = state;
    if (currentState is! AzkarLoaded) return const ZikrIgnored();

    final index = currentState.azkar.indexWhere((zikr) => zikr.id == zikrId);
    if (index == -1) return const ZikrIgnored();

    final zikr = currentState.azkar[index];
    final currentCount = currentState.counters[zikrId] ?? 0;
    if (currentCount >= zikr.count) return const ZikrIgnored();

    final newCount = currentCount + 1;
    emit(
      currentState.copyWith(
        counters: {...currentState.counters, zikrId: newCount},
      ),
    );

    if (newCount >= zikr.count) {
      return const ZikrCompleted();
    }

    return const ZikrIncremented();
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

  // Applies updates while preserving progress.
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

  // Resets category
  Future<Result<void>> resetCategory(
    String categoryKey, {
    required String categoryTitle,
  }) async {
    final result = await _deleteCustomCategoryUseCase(categoryKey);
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
    final isBuiltIn = !categoryKey.startsWith(customCategoryIdPrefix);
    // Built-in names are app-owned; never trust a caller-supplied title.
    if (!isBuiltIn) {
      if (fallback != AppStrings.azkarHeader) return fallback;

      // Deep links may lack a title, so resolve the stored custom name.
      final custom = await _customAzkarRepository.getCustomCategoryById(
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

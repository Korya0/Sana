import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/error/result.dart';
import 'package:sana/features/azkar/domain/entities/category_entity.dart';
import 'package:sana/features/azkar/domain/entities/custom_category_entity.dart';
import 'package:sana/features/azkar/domain/entities/zikr_entity.dart';
import 'package:sana/features/azkar/domain/repositories/custom_azkar_repository.dart';
import 'package:sana/features/azkar/domain/use_cases/delete_custom_category_use_case.dart';
import 'package:sana/features/azkar/domain/use_cases/get_azkar_by_category_use_case.dart';
import 'package:sana/features/azkar/domain/use_cases/get_categories_use_case.dart';
import 'package:sana/features/azkar/domain/use_cases/save_custom_category_use_case.dart';
import 'package:sana/features/azkar/presentation/cubits/azkar/azkar_state.dart';
import 'package:sana/features/azkar/presentation/cubits/azkar/zikr_increment_result.dart';

class AzkarCubit extends Cubit<AzkarState> {
  AzkarCubit(
    this._getAzkarByCategoryUseCase,
    this._getCategoriesUseCase, [
    this._saveCustomCategoryUseCase,
    this._deleteCustomCategoryUseCase,
    this._customAzkarRepository,
  ]) : super(AzkarInitial());

  final GetAzkarByCategoryUseCase _getAzkarByCategoryUseCase;
  final GetCategoriesUseCase _getCategoriesUseCase;
  final SaveCustomCategoryUseCase? _saveCustomCategoryUseCase;
  final DeleteCustomCategoryUseCase? _deleteCustomCategoryUseCase;
  final CustomAzkarRepository? _customAzkarRepository;

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
        final resolvedTitle = await _resolveTitle(categoryKey, categoryTitle);
        if (isClosed) return;

        var isCustom = categoryKey.startsWith('custom_');
        if (!isCustom && _customAzkarRepository != null) {
          final customCheck =
              await _customAzkarRepository.getCustomCategoryById(categoryKey);
          if (customCheck is Success<CustomCategoryEntity?> &&
              customCheck.data != null) {
            isCustom = true;
          }
        }
        if (isClosed) return;

        emit(
          AzkarLoaded(
            azkar: azkar,
            counters: {for (final ZikrEntity zikr in azkar) zikr.id: 0},
            resolvedTitle: resolvedTitle,
            isCustom: isCustom,
          ),
        );
      case FailureResult(:final failure):
        emit(AzkarError(failure.message));
    }
  }

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

  void resetCounter(int zikrId) {
    final currentState = state;
    if (currentState is! AzkarLoaded) return;

    emit(
      currentState.copyWith(
        counters: {...currentState.counters, zikrId: 0},
      ),
    );
  }

  Future<bool> updateTargetCount(
    int zikrId,
    int newTargetCount, {
    required String categoryKey,
    required String categoryTitle,
  }) async {
    final currentState = state;
    if (currentState is! AzkarLoaded) return false;

    final updatedAzkar = currentState.azkar.map((z) {
      if (z.id == zikrId) {
        return ZikrEntity(
          id: z.id,
          text: z.text,
          count: newTargetCount,
          description: z.description,
          isUserAdded: z.isUserAdded,
        );
      }
      return z;
    }).toList();

    final currentCounter = currentState.counters[zikrId] ?? 0;
    final updatedCounters = {
      ...currentState.counters,
      zikrId: currentCounter > newTargetCount ? newTargetCount : currentCounter,
    };

    if (_saveCustomCategoryUseCase != null) {
      final customCategory = CustomCategoryEntity(
        id: categoryKey,
        name: categoryTitle,
        azkar: updatedAzkar,
        createdAt: DateTime.now(),
      );
      await _saveCustomCategoryUseCase(customCategory);
    }

    emit(
      AzkarLoaded(
        azkar: updatedAzkar,
        counters: updatedCounters,
        resolvedTitle: currentState.resolvedTitle,
        isCustom: true,
      ),
    );
    return true;
  }

  Future<bool> addZikr(
    ZikrEntity newZikr, {
    required String categoryKey,
    required String categoryTitle,
  }) async {
    final currentState = state;
    if (currentState is! AzkarLoaded) return false;

    final updatedAzkar = [...currentState.azkar, newZikr];
    final updatedCounters = {...currentState.counters, newZikr.id: 0};

    if (_saveCustomCategoryUseCase != null) {
      final customCategory = CustomCategoryEntity(
        id: categoryKey,
        name: categoryTitle,
        azkar: updatedAzkar,
        createdAt: DateTime.now(),
      );
      await _saveCustomCategoryUseCase(customCategory);
    }

    emit(
      AzkarLoaded(
        azkar: updatedAzkar,
        counters: updatedCounters,
        resolvedTitle: currentState.resolvedTitle,
        isCustom: true,
      ),
    );
    return true;
  }

  Future<bool> deleteZikr(
    int zikrId, {
    required String categoryKey,
    required String categoryTitle,
  }) async {
    final currentState = state;
    if (currentState is! AzkarLoaded) return false;

    // Safety: Built-in zikr cannot be deleted
    final isCustomCategory = categoryKey.startsWith('custom_');
    if (!isCustomCategory) {
      final zikr = currentState.azkar
          .where((z) => z.id == zikrId)
          .firstOrNull;
      if (zikr != null && !zikr.canBeDeleted) {
        return false;
      }
    }

    final updatedAzkar =
        currentState.azkar.where((z) => z.id != zikrId).toList();
    final updatedCounters = Map<int, int>.from(currentState.counters)
      ..remove(zikrId);

    if (_saveCustomCategoryUseCase != null) {
      final customCategory = CustomCategoryEntity(
        id: categoryKey,
        name: categoryTitle,
        azkar: updatedAzkar,
        createdAt: DateTime.now(),
      );
      await _saveCustomCategoryUseCase(customCategory);
    }

    emit(
      AzkarLoaded(
        azkar: updatedAzkar,
        counters: updatedCounters,
        resolvedTitle: currentState.resolvedTitle,
        isCustom: true,
      ),
    );
    return true;
  }

  Future<void> resetCategory(
    String categoryKey, {
    required String categoryTitle,
  }) async {
    if (_deleteCustomCategoryUseCase != null) {
      await _deleteCustomCategoryUseCase(categoryKey);
    }
    await loadAzkar(categoryKey, categoryTitle: categoryTitle);
  }

  Future<String> _resolveTitle(String categoryKey, String fallback) async {
    if (fallback != AppStrings.azkarHeader) return fallback;

    final result = await _getCategoriesUseCase();
    if (isClosed || result is! Success<List<CategoryEntity>>) return fallback;

    for (final category in result.data) {
      if (category.key == categoryKey) return category.title;
    }
    return fallback;
  }
}

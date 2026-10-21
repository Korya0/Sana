import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/error/result.dart';
import 'package:sana/features/azkar/domain/entities/category_entity.dart';
import 'package:sana/features/azkar/domain/entities/zikr_entity.dart';
import 'package:sana/features/azkar/domain/use_cases/get_azkar_by_category_use_case.dart';
import 'package:sana/features/azkar/domain/use_cases/get_categories_use_case.dart';
import 'package:sana/features/azkar/presentation/cubits/azkar/azkar_state.dart';
import 'package:sana/features/azkar/presentation/cubits/azkar/zikr_increment_result.dart';

class AzkarCubit extends Cubit<AzkarState> {
  AzkarCubit(
    this._getAzkarByCategoryUseCase,
    this._getCategoriesUseCase,
  ) : super(AzkarInitial());

  final GetAzkarByCategoryUseCase _getAzkarByCategoryUseCase;
  final GetCategoriesUseCase _getCategoriesUseCase;

  Future<void> loadAzkar(
    int categoryId, {
    required String categoryTitle,
  }) async {
    emit(AzkarLoading());

    final result = await _getAzkarByCategoryUseCase(categoryId);
    if (isClosed) return;

    switch (result) {
      case Success(data: final azkar):
        if (azkar.isEmpty) {
          emit(AzkarEmpty());
          return;
        }
        final resolvedTitle = await _resolveTitle(categoryId, categoryTitle);
        if (isClosed) return;
        emit(
          AzkarLoaded(
            azkar: azkar,
            counters: {for (final ZikrEntity zikr in azkar) zikr.id: 0},
            resolvedTitle: resolvedTitle,
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

  Future<String> _resolveTitle(int categoryId, String fallback) async {
    if (fallback != AppStrings.azkarHeader) return fallback;

    final result = await _getCategoriesUseCase();
    if (isClosed || result is! Success<List<CategoryEntity>>) return fallback;

    for (final category in result.data) {
      if (category.id == categoryId) return category.title;
    }
    return fallback;
  }
}

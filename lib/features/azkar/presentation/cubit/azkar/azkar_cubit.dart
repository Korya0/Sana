import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/constants/constants.dart';
import 'package:sana/core/network/result.dart';
import 'package:sana/core/utils/utils.dart';
import 'package:sana/features/azkar/domain/entities/category_entity.dart';
import 'package:sana/features/azkar/domain/entities/zikr_entity.dart';
import 'package:sana/features/azkar/domain/usecases/get_azkar_by_category_usecase.dart';
import 'package:sana/features/azkar/domain/usecases/get_categories_usecase.dart';
import 'package:sana/features/azkar/presentation/cubit/azkar/azkar_state.dart';
import 'package:sana/features/azkar/presentation/cubit/azkar/zikr_increment_result.dart';

class AzkarCubit extends Cubit<AzkarState> {
  AzkarCubit(this._getAzkarByCategoryUseCase, this._getCategoriesUseCase) : super(AzkarInitial());

  final GetAzkarByCategoryUseCase _getAzkarByCategoryUseCase;
  final GetCategoriesUseCase _getCategoriesUseCase;

  Future<void> loadAzkar(int categoryId, {String fallbackTitle = AppStrings.azkarHeader}) async {
    emit(AzkarLoading());

    var resolvedTitle = fallbackTitle;
    if (fallbackTitle == AppStrings.azkarHeader) {
      final categoryResult = await _getCategoriesUseCase();
      if (categoryResult is Success<List<CategoryEntity>>) {
        final categories = categoryResult.data;
        CategoryEntity? match;
        for (final c in categories) {
          if (c.id == categoryId) {
            match = c;
            break;
          }
        }
        if (match != null) {
          resolvedTitle = match.title;
        } else if (categories.isNotEmpty) {
          resolvedTitle = categories.first.title;
        }
      }
    }

    final result = await _getAzkarByCategoryUseCase(categoryId);

    if (result is Success<List<ZikrEntity>>) {
      final azkar = result.data;
      if (azkar.isEmpty) {
        emit(AzkarEmpty());
      } else {
        final counters = <int, int>{};
        for (final zikr in azkar) {
          counters[zikr.id] = 0;
        }
        emit(AzkarLoaded(azkar: azkar, counters: counters, resolvedTitle: resolvedTitle));
      }
    } else if (result is FailureResult<List<ZikrEntity>>) {
      emit(AzkarError(result.failure.message));
    }
  }

  ZikrIncrementResult incrementZikr(int zikrId) {
    if (state is AzkarLoaded) {
      final currentState = state as AzkarLoaded;
      final index = currentState.azkar.indexWhere((z) => z.id == zikrId);
      if (index == -1) return const ZikrIgnored();

      final zikr = currentState.azkar[index];
      final currentCount = currentState.counters[zikrId] ?? 0;

      if (currentCount < zikr.count) {
        final newCount = currentCount + 1;
        final newCounters = Map<int, int>.from(currentState.counters);
        newCounters[zikrId] = newCount;

        emit(currentState.copyWith(counters: newCounters));

        unawaited(playVibrate());
        
        if (newCount >= zikr.count) {
          unawaited(playVibrate());
          unawaited(Future.delayed(AppConstants.animationFast200ms, playVibrate));
          return const ZikrCompleted();
        }
        return const ZikrIncremented();
      }
    }
    return const ZikrIgnored();
  }
}

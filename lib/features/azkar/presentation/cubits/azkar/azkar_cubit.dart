import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/networking/result.dart';
import 'package:sana/features/azkar/domain/entities/zikr_entity.dart';
import 'package:sana/features/azkar/domain/usecases/get_azkar_by_category_usecase.dart';
import 'package:sana/features/azkar/presentation/cubits/azkar/azkar_state.dart';

class AzkarCubit extends Cubit<AzkarState> {
  AzkarCubit(this._getAzkarByCategoryUseCase) : super(AzkarInitial());

  final GetAzkarByCategoryUseCase _getAzkarByCategoryUseCase;

  Future<void> loadAzkar(int categoryId) async {
    emit(AzkarLoading());

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
        emit(AzkarLoaded(azkar: azkar, counters: counters));
      }
    } else if (result is FailureResult<List<ZikrEntity>>) {
      emit(AzkarError(result.failure.message));
    }
  }

  void incrementZikrCount(int zikrId) {
    if (state is AzkarLoaded) {
      final currentState = state as AzkarLoaded;
      final index = currentState.azkar.indexWhere((z) => z.id == zikrId);
      if (index == -1) return;

      final zikr = currentState.azkar[index];
      final currentCount = currentState.counters[zikrId] ?? 0;

      if (currentCount < zikr.count) {
        final newCounters = Map<int, int>.from(currentState.counters);
        newCounters[zikrId] = currentCount + 1;

        int? newScrollTarget;

        if (newCounters[zikrId] == zikr.count) {
          for (var i = index + 1; i < currentState.azkar.length; i++) {
            final nextZikr = currentState.azkar[i];
            if ((newCounters[nextZikr.id] ?? 0) < nextZikr.count) {
              newScrollTarget = i;
              break;
            }
          }
        }

        emit(
          currentState.copyWith(
            counters: newCounters,
            scrollTargetIndex: newScrollTarget,
          ),
        );
      }
    }
  }

  void resetScrollTarget() {
    if (state is AzkarLoaded) {
      final currentState = state as AzkarLoaded;
      if (currentState.scrollTargetIndex != null) {
        emit(currentState.clearScrollTarget());
      }
    }
  }
}

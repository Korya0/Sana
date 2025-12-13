import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/features/azkar/domain/entities/azkar_category.dart';
import 'package:sana/features/azkar/presentation/cubit/azkar_list_state.dart';

class AzkarListCubit extends Cubit<AzkarListState> {
  AzkarListCubit(AzkarCategory category)
    : super(
        AzkarListInProgress(
          category: category,
          zikrProgress: {},
          currentIndex: 0,
        ),
      );

  void incrementZikr(int index) {
    if (state is AzkarListInProgress) {
      final currentState = state as AzkarListInProgress;
      final currentCount = currentState.getCurrentCount(index);
      final totalCount = currentState.category.azkar[index].totalCount;

      if (currentCount < totalCount) {
        final newProgress = Map<int, int>.from(currentState.zikrProgress);
        newProgress[index] = currentCount + 1;

        final isZikrCompleted = newProgress[index]! >= totalCount;
        final nextIndex =
            isZikrCompleted && index + 1 < currentState.category.azkar.length
            ? index + 1
            : currentState.currentIndex;

        emit(
          AzkarListInProgress(
            category: currentState.category,
            zikrProgress: newProgress,
            currentIndex: nextIndex,
          ),
        );

        if (_isAllCompleted(newProgress, currentState.category)) {
          emit(AzkarListCompleted(currentState.category));
        }
      }
    }
  }

  void decrementZikr(int index) {
    if (state is AzkarListInProgress) {
      final currentState = state as AzkarListInProgress;
      final currentCount = currentState.getCurrentCount(index);

      if (currentCount > 0) {
        final newProgress = Map<int, int>.from(currentState.zikrProgress);
        newProgress[index] = currentCount - 1;

        emit(
          AzkarListInProgress(
            category: currentState.category,
            zikrProgress: newProgress,
            currentIndex: currentState.currentIndex,
          ),
        );
      }
    }
  }

  void resetAll() {
    if (state is AzkarListInProgress) {
      final currentState = state as AzkarListInProgress;
      emit(
        AzkarListInProgress(
          category: currentState.category,
          zikrProgress: {},
          currentIndex: 0,
        ),
      );
    }
  }

  bool _isAllCompleted(Map<int, int> progress, AzkarCategory category) {
    for (int i = 0; i < category.azkar.length; i++) {
      final currentCount = progress[i] ?? 0;
      if (currentCount < category.azkar[i].totalCount) {
        return false;
      }
    }
    return true;
  }
}

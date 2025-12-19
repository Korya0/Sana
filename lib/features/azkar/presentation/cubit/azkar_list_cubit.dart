import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/features/azkar/data/models/azkar_category_model.dart';
import 'package:sana/features/azkar/presentation/cubit/azkar_list_state.dart';

class AzkarListCubit extends Cubit<AzkarListState> {
  AzkarListCubit(AzkarCategoryModel category)
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
      final totalCount = currentState.category.array[index].count;

      if (currentCount < totalCount) {
        final newProgress = Map<int, int>.from(currentState.zikrProgress);
        newProgress[index] = currentCount + 1;

        final isZikrCompleted = newProgress[index]! >= totalCount;
        final nextIndex =
            isZikrCompleted && index + 1 < currentState.category.array.length
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

  bool _isAllCompleted(Map<int, int> progress, AzkarCategoryModel category) {
    for (int i = 0; i < category.array.length; i++) {
      final currentCount = progress[i] ?? 0;
      if (currentCount < category.array[i].count) {
        return false;
      }
    }
    return true;
  }
}

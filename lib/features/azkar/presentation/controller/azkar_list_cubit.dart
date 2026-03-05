import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/features/azkar/data/models/azkar_category_model.dart';
import 'package:sana/features/azkar/presentation/controller/azkar_list_state.dart';

class AzkarListCubit extends Cubit<AzkarListState> {
  AzkarListCubit() : super(AzkarListInitial());

  void loadAzkar(AzkarCategoryModel category) {
    emit(
      AzkarListInProgress(
        category: category,
        zikrProgress: const {},
        currentIndex: 0,
      ),
    );
  }

  void incrementZikr(int index) {
    final currentState = state;
    if (currentState is AzkarListInProgress) {
      final currentCount = currentState.zikrProgress[index] ?? 0;
      final targetCount = currentState.category.array[index].count;

      if (currentCount < targetCount) {
        final newCount = currentCount + 1;
        final newProgress = Map<int, int>.from(currentState.zikrProgress);
        newProgress[index] = newCount;

        // If it just became completed, increment completedCount
        final newCompletedCount = newCount == targetCount
            ? currentState.completedCount + 1
            : currentState.completedCount;

        final newState = currentState.copyWith(
          zikrProgress: newProgress,
          currentIndex: index,
          completedCount: newCompletedCount,
        );

        if (newState.isAllCompleted) {
          emit(AzkarListCompleted(currentState.category));
        } else {
          emit(newState);
        }
      }
    }
  }

  void reset() {
    final currentState = state;
    if (currentState is AzkarListInProgress) {
      loadAzkar(currentState.category);
    }
  }
}

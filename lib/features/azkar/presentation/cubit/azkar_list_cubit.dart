import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/features/azkar/data/models/azkar_category_model.dart';
import 'package:sana/features/azkar/presentation/cubit/azkar_list_state.dart';

class AzkarListCubit extends Cubit<AzkarListState> {
  AzkarListCubit() : super(AzkarListInitial());

  void loadAzkar(AzkarCategoryModel category) {
    emit(
      AzkarListInProgress(
        category: category,
        zikrProgress: {},
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
        final newProgress = Map<int, int>.from(currentState.zikrProgress);
        newProgress[index] = currentCount + 1;

        final newState = AzkarListInProgress(
          category: currentState.category,
          zikrProgress: newProgress,
          currentIndex: index, // Update current index or logic as needed
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
    // implementation if needed
  }
}

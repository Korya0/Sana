import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/features/azkar/data/models/azkar_category_model.dart';
import 'package:sana/features/azkar/presentation/controller/azkar_list_state.dart';

class AzkarListCubit extends Cubit<AzkarListState> {
  AzkarListCubit() : super(const AzkarListState.initial());

  void loadAzkar(AzkarCategoryModel category) {
    emit(
      AzkarListState.inProgress(
        category: category,
        zikrProgress: const {},
        currentIndex: 0,
      ),
    );
  }

  void incrementZikr(int index) {
    state.mapOrNull(
      inProgress: (inProgressState) {
        final currentCount = inProgressState.zikrProgress[index] ?? 0;
        final targetCount = inProgressState.category.array[index].count;

        if (currentCount < targetCount) {
          final newCount = currentCount + 1;
          final newProgress = Map<int, int>.from(inProgressState.zikrProgress);
          newProgress[index] = newCount;

          final newCompletedCount = newCount == targetCount
              ? inProgressState.completedCount + 1
              : inProgressState.completedCount;

          final newState = inProgressState.copyWith(
            zikrProgress: newProgress,
            currentIndex: index,
            completedCount: newCompletedCount,
          );

          if (newState.isAllCompleted) {
            emit(AzkarListState.completed(inProgressState.category));
          } else {
            emit(newState);
          }
        }
      },
    );
  }

  void reset() {
    state.maybeMap(
      inProgress: (inProgressState) => loadAzkar(inProgressState.category),
      orElse: () {},
    );
  }
}

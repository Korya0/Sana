import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sana/features/azkar/data/models/azkar_category_model.dart';

part 'azkar_list_state.freezed.dart';

@freezed
class AzkarListState with _$AzkarListState {
  const AzkarListState._();

  const factory AzkarListState.initial() = AzkarListInitial;
  const factory AzkarListState.inProgress({
    required AzkarCategoryModel category,
    required Map<int, int> zikrProgress,
    required int currentIndex,
    @Default(0) int completedCount,
  }) = AzkarListInProgress;
  const factory AzkarListState.completed(AzkarCategoryModel category) =
      AzkarListCompleted;

  bool isZikrCompleted(int index) {
    return maybeWhen(
      inProgress: (category, zikrProgress, currentIndex, completedCount) {
        final currentCount = zikrProgress[index] ?? 0;
        return currentCount >= category.array[index].count;
      },
      orElse: () => false,
    );
  }

  bool get isAllCompleted {
    return maybeWhen(
      inProgress: (category, zikrProgress, currentIndex, completedCount) {
        return completedCount >= category.array.length;
      },
      orElse: () => false,
    );
  }

  bool get hasProgress {
    return maybeWhen(
      inProgress: (category, zikrProgress, currentIndex, completedCount) {
        return completedCount > 0 ||
            zikrProgress.values.any((element) => element > 0);
      },
      orElse: () => false,
    );
  }

  int getCurrentCount(int index) {
    return maybeWhen(
      inProgress: (category, zikrProgress, currentIndex, completedCount) {
        return zikrProgress[index] ?? 0;
      },
      orElse: () => 0,
    );
  }

  double getProgress(int index) {
    return maybeWhen(
      inProgress: (category, zikrProgress, currentIndex, completedCount) {
        final total = category.array[index].count;
        final current = zikrProgress[index] ?? 0;
        return total > 0 ? current / total : 0.0;
      },
      orElse: () => 0.0,
    );
  }
}

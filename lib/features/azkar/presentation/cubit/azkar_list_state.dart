import 'package:sana/features/azkar/data/models/azkar_category_model.dart';

sealed class AzkarListState {
  const AzkarListState();

  bool isZikrCompleted(int index) {
    if (this is AzkarListInProgress) {
      final state = this as AzkarListInProgress;
      final currentCount = state.zikrProgress[index] ?? 0;
      return currentCount >= state.category.array[index].count;
    }
    return false;
  }

  bool get isAllCompleted {
    if (this is AzkarListInProgress) {
      final state = this as AzkarListInProgress;
      return state.completedCount >= state.category.array.length;
    }
    return false;
  }

  bool get hasProgress {
    if (this is AzkarListInProgress) {
      final state = this as AzkarListInProgress;
      return state.completedCount > 0 ||
          state.zikrProgress.values.any((element) => element > 0);
    }
    return false;
  }

  int getCurrentCount(int index) {
    if (this is AzkarListInProgress) {
      final state = this as AzkarListInProgress;
      return state.zikrProgress[index] ?? 0;
    }
    return 0;
  }

  double getProgress(int index) {
    if (this is AzkarListInProgress) {
      final state = this as AzkarListInProgress;
      final total = state.category.array[index].count;
      final current = state.zikrProgress[index] ?? 0;
      return total > 0 ? current / total : 0.0;
    }
    return 0;
  }
}

class AzkarListInitial extends AzkarListState {
  const AzkarListInitial();
}

class AzkarListInProgress extends AzkarListState {
  const AzkarListInProgress({
    required this.category,
    required this.zikrProgress,
    required this.currentIndex,
    this.completedCount = 0,
  });
  final AzkarCategoryModel category;
  final Map<int, int> zikrProgress;
  final int currentIndex;
  final int completedCount;

  AzkarListInProgress copyWith({
    AzkarCategoryModel? category,
    Map<int, int>? zikrProgress,
    int? currentIndex,
    int? completedCount,
  }) {
    return AzkarListInProgress(
      category: category ?? this.category,
      zikrProgress: zikrProgress ?? this.zikrProgress,
      currentIndex: currentIndex ?? this.currentIndex,
      completedCount: completedCount ?? this.completedCount,
    );
  }
}

class AzkarListCompleted extends AzkarListState {
  const AzkarListCompleted(this.category);
  final AzkarCategoryModel category;
}

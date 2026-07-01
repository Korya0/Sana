import 'package:sana/features/azkar/data/models/azkar_category_model.dart';

sealed class AzkarListState {
  const AzkarListState();
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

  bool isZikrCompleted(int index) {
    final currentCount = zikrProgress[index] ?? 0;
    return currentCount >= category.array[index].count;
  }

  bool get isAllCompleted {
    return completedCount >= category.array.length;
  }

  bool get hasProgress {
    return completedCount > 0 || zikrProgress.values.any((element) => element > 0);
  }

  int getCurrentCount(int index) {
    return zikrProgress[index] ?? 0;
  }

  double getProgress(int index) {
    final total = category.array[index].count;
    final current = zikrProgress[index] ?? 0;
    return total > 0 ? current / total : 0.0;
  }

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

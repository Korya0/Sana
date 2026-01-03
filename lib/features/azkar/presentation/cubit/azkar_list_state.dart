import 'package:sana/features/azkar/data/models/azkar_category_model.dart';

abstract class AzkarListState {}

class AzkarListInitial extends AzkarListState {}

class AzkarListInProgress extends AzkarListState {
  final AzkarCategoryModel category;
  final Map<int, int> zikrProgress;
  final int currentIndex;

  AzkarListInProgress({
    required this.category,
    required this.zikrProgress,
    required this.currentIndex,
  });

  bool isZikrCompleted(int index) {
    final currentCount = zikrProgress[index] ?? 0;
    return currentCount >= category.array[index].count;
  }

  bool get isAllCompleted {
    for (int i = 0; i < category.array.length; i++) {
      if (!isZikrCompleted(i)) return false;
    }
    return true;
  }

  bool get hasProgress {
    return zikrProgress.values.any((count) => count > 0);
  }

  int getCurrentCount(int index) => zikrProgress[index] ?? 0;

  double getProgress(int index) {
    final total = category.array[index].count;
    final current = getCurrentCount(index);
    return total > 0 ? current / total : 0.0;
  }
}

class AzkarListCompleted extends AzkarListState {
  final AzkarCategoryModel category;
  AzkarListCompleted(this.category);
}

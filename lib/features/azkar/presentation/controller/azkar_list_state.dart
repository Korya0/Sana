import 'package:equatable/equatable.dart';
import 'package:sana/features/azkar/data/models/azkar_category_model.dart';

abstract class AzkarListState extends Equatable {
  const AzkarListState();
  @override
  List<Object?> get props => [];
}

class AzkarListInitial extends AzkarListState {}

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

  bool get isAllCompleted => completedCount >= category.array.length;

  bool get hasProgress {
    return zikrProgress.values.any((count) => count > 0);
  }

  int getCurrentCount(int index) => zikrProgress[index] ?? 0;

  double getProgress(int index) {
    final total = category.array[index].count;
    final current = getCurrentCount(index);
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

  @override
  List<Object?> get props => [
    category,
    zikrProgress,
    currentIndex,
    completedCount,
  ];
}

class AzkarListCompleted extends AzkarListState {
  const AzkarListCompleted(this.category);
  final AzkarCategoryModel category;

  @override
  List<Object?> get props => [category];
}

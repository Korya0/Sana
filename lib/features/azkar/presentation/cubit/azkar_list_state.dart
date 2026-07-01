import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:sana/features/azkar/domain/entities/azkar_category_entity.dart';

@immutable
sealed class AzkarListState {
  const AzkarListState();
}

class AzkarListInitial extends AzkarListState {
  const AzkarListInitial();

  @override
  bool operator ==(Object other) => identical(this, other) || other is AzkarListInitial;

  @override
  int get hashCode => 0;
}

class AzkarListInProgress extends AzkarListState {
  const AzkarListInProgress({
    required this.category,
    required this.zikrProgress,
    required this.currentIndex,
    this.completedCount = 0,
  });
  final AzkarCategoryEntity category;
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
    AzkarCategoryEntity? category,
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
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AzkarListInProgress &&
          category == other.category &&
          const MapEquality<int, int>().equals(zikrProgress, other.zikrProgress) &&
          currentIndex == other.currentIndex &&
          completedCount == other.completedCount;

  @override
  int get hashCode =>
      category.hashCode ^
      const MapEquality<int, int>().hash(zikrProgress) ^
      currentIndex.hashCode ^
      completedCount.hashCode;
}

class AzkarListCompleted extends AzkarListState {
  const AzkarListCompleted(this.category);
  final AzkarCategoryEntity category;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AzkarListCompleted && category == other.category;

  @override
  int get hashCode => category.hashCode;
}

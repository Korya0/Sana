import 'package:flutter/foundation.dart';
import 'package:sana/features/azkar/domain/entities/zikr_entity.dart';
import 'package:sana/features/azkar/domain/extensions/zikr_list_extensions.dart';
import 'package:sana/features/azkar/presentation/cubits/azkar/zikr_progress.dart';

@immutable
sealed class AzkarState {
  // Creates state
  const AzkarState();
}

class AzkarInitial extends AzkarState {}

class AzkarLoading extends AzkarState {}

class AzkarLoaded extends AzkarState {
  // Creates state
  const AzkarLoaded({
    required this.azkar,
    required this.counters,
    required this.resolvedTitle,
    this.isCustom = false,
    this.isModified = false,
  });

  final List<ZikrEntity> azkar;
  final Map<int, int> counters;
  final String resolvedTitle;
  final bool isCustom;
  final bool isModified;

  // Checks completion
  bool get isAllCompleted => firstIncompleteIndex == null;

  // Checks progress
  bool get hasStarted => counters.values.any((count) => count > 0);

  // Returns progress for a zikr
  ZikrProgress getProgressFor(int id) {
    final zikr = azkar.byId(id);
    final count = counters[id] ?? 0;
    final total = zikr?.count ?? 0;
    final left = total - count;
    return ZikrProgress(
      completedCount: count,
      totalCount: total,
      remaining: left > 0 ? left : 0,
      isCompleted: zikr != null && count >= zikr.count,
      canReset: count > 0,
    );
  }

  // Finds incomplete
  int? get firstIncompleteIndex {
    for (var index = 0; index < azkar.length; index++) {
      final zikr = azkar[index];
      if ((counters[zikr.id] ?? 0) < zikr.count) return index;
    }
    return null;
  }

  // Copies state
  AzkarLoaded copyWith({
    List<ZikrEntity>? azkar,
    Map<int, int>? counters,
    String? resolvedTitle,
    bool? isCustom,
    bool? isModified,
  }) => AzkarLoaded(
    azkar: azkar ?? this.azkar,
    counters: counters ?? this.counters,
    resolvedTitle: resolvedTitle ?? this.resolvedTitle,
    isCustom: isCustom ?? this.isCustom,
    isModified: isModified ?? this.isModified,
  );
}

class AzkarEmpty extends AzkarState {}

class AzkarError extends AzkarState {
  // Creates state
  const AzkarError(this.message);

  final String message;
}

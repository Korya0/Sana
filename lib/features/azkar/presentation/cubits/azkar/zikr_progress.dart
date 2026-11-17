import 'package:flutter/foundation.dart';

@immutable
class ZikrProgress {
  // Creates progress
  const ZikrProgress({
    required this.completedCount,
    required this.totalCount,
    required this.remaining,
    required this.isCompleted,
    required this.canReset,
  });

  final int completedCount;
  final int totalCount;
  final int remaining;
  final bool isCompleted;
  final bool canReset;
}

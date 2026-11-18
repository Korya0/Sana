class TasbeehItemEntity {
  // Creates entity
  const TasbeehItemEntity({
    required this.id,
    required this.text,
    required this.currentCount,
    required this.lastUsedAt,
    this.targetCount,
    this.isCustom = true,
  });

  final String id;
  final String text;
  final int currentCount;
  final int? targetCount;
  final DateTime lastUsedAt;
  final bool isCustom;

  // Checks completion
  bool get isCompleted => targetCount != null && currentCount >= targetCount!;

  // Checks target
  bool get hasTarget => targetCount != null && targetCount! > 0;

  // Checks free mode
  bool get isFreeMode => !hasTarget;

  // Calculates progress
  double get progress {
    if (isFreeMode) return currentCount <= 0 ? 0 : 1;
    return (currentCount / targetCount!).clamp(0.0, 1.0);
  }

  // Returns remaining count
  int get remaining {
    if (!hasTarget) return currentCount;
    final left = targetCount! - currentCount;
    return left > 0 ? left : 0;
  }

  // Checks reset
  bool get canReset => currentCount > 0;

  // Copies entity
  TasbeehItemEntity copyWith({
    String? id,
    String? text,
    int? currentCount,
    int? Function()? targetCount,
    DateTime? lastUsedAt,
    bool? isCustom,
  }) => TasbeehItemEntity(
    id: id ?? this.id,
    text: text ?? this.text,
    currentCount: currentCount ?? this.currentCount,
    targetCount: targetCount != null ? targetCount() : this.targetCount,
    lastUsedAt: lastUsedAt ?? this.lastUsedAt,
    isCustom: isCustom ?? this.isCustom,
  );

  // Compares entities
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TasbeehItemEntity &&
          id == other.id &&
          text == other.text &&
          currentCount == other.currentCount &&
          targetCount == other.targetCount &&
          lastUsedAt == other.lastUsedAt &&
          isCustom == other.isCustom;

  // Hashes entity
  @override
  int get hashCode =>
      Object.hash(id, text, currentCount, targetCount, lastUsedAt, isCustom);
}

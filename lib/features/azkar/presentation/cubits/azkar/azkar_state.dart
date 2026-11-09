import 'package:sana/features/azkar/domain/entities/zikr_entity.dart';

sealed class AzkarState {
  const AzkarState();
}

class AzkarInitial extends AzkarState {}

class AzkarLoading extends AzkarState {}

class AzkarLoaded extends AzkarState {
  const AzkarLoaded({
    required this.azkar,
    required this.counters,
    required this.resolvedTitle,
    this.isCustom = false,
  });

  final List<ZikrEntity> azkar;
  final Map<int, int> counters;
  final String resolvedTitle;
  final bool isCustom;

  bool get isAllCompleted => firstIncompleteIndex == null;

  bool get hasStarted => counters.values.any((count) => count > 0);

  // First zikr still incomplete.
  int? get firstIncompleteIndex {
    for (var index = 0; index < azkar.length; index++) {
      final zikr = azkar[index];
      if ((counters[zikr.id] ?? 0) < zikr.count) return index;
    }
    return null;
  }

  AzkarLoaded copyWith({
    List<ZikrEntity>? azkar,
    Map<int, int>? counters,
    String? resolvedTitle,
    bool? isCustom,
  }) => AzkarLoaded(
    azkar: azkar ?? this.azkar,
    counters: counters ?? this.counters,
    resolvedTitle: resolvedTitle ?? this.resolvedTitle,
    isCustom: isCustom ?? this.isCustom,
  );
}

class AzkarEmpty extends AzkarState {}

class AzkarError extends AzkarState {
  const AzkarError(this.message);

  final String message;
}

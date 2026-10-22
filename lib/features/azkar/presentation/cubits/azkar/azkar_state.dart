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
  });

  final List<ZikrEntity> azkar;
  final Map<int, int> counters;
  final String resolvedTitle;

  bool get isAllCompleted =>
      azkar.every((zikr) => (counters[zikr.id] ?? 0) >= zikr.count);

  bool get hasStarted => counters.values.any((count) => count > 0);

  int? findNextIncompleteIndex(int afterIndex) {
    for (var index = afterIndex + 1; index < azkar.length; index++) {
      final zikr = azkar[index];
      if ((counters[zikr.id] ?? 0) < zikr.count) return index;
    }
    return null;
  }

  AzkarLoaded copyWith({Map<int, int>? counters}) => AzkarLoaded(
    azkar: azkar,
    counters: counters ?? this.counters,
    resolvedTitle: resolvedTitle,
  );
}

class AzkarEmpty extends AzkarState {}

class AzkarError extends AzkarState {
  const AzkarError(this.message);

  final String message;
}

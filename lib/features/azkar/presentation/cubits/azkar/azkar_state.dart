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
  });

  final List<ZikrEntity> azkar;
  final Map<int, int> counters;

  bool get isAllCompleted =>
      azkar.every((z) => (counters[z.id] ?? 0) >= z.count);

  AzkarLoaded copyWith({
    List<ZikrEntity>? azkar,
    Map<int, int>? counters,
  }) {
    return AzkarLoaded(
      azkar: azkar ?? this.azkar,
      counters: counters ?? this.counters,
    );
  }
}

class AzkarEmpty extends AzkarState {}

class AzkarError extends AzkarState {
  const AzkarError(this.message);

  final String message;
}

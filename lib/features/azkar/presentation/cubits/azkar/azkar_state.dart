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
    this.scrollTargetIndex,
  });

  final List<ZikrEntity> azkar;
  final Map<int, int> counters;
  final int? scrollTargetIndex;

  AzkarLoaded copyWith({
    List<ZikrEntity>? azkar,
    Map<int, int>? counters,
    int? scrollTargetIndex,
  }) {
    return AzkarLoaded(
      azkar: azkar ?? this.azkar,
      counters: counters ?? this.counters,
      scrollTargetIndex: scrollTargetIndex ?? this.scrollTargetIndex,
    );
  }

  AzkarLoaded clearScrollTarget() {
    return AzkarLoaded(
      azkar: azkar,
      counters: counters,
    );
  }
}

class AzkarEmpty extends AzkarState {}

class AzkarError extends AzkarState {
  const AzkarError(this.message);

  final String message;
}

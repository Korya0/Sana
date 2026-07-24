import 'package:sana/features/asma_ul_husna/domain/entities/asma_ul_husna_entity.dart';

sealed class DailyAsmaUlHusnaState {
  const DailyAsmaUlHusnaState();

  const factory DailyAsmaUlHusnaState.initial() = DailyAsmaUlHusnaInitial;
  const factory DailyAsmaUlHusnaState.loading() = DailyAsmaUlHusnaStateLoading;
  const factory DailyAsmaUlHusnaState.loaded(AsmaUlHusnaEntity name) =
      DailyAsmaUlHusnaLoaded;
  const factory DailyAsmaUlHusnaState.error(String message) =
      DailyAsmaUlHusnaStateError;

  T maybeWhen<T>({
    required T Function() orElse,
    T Function()? initial,
    T Function()? loading,
    T Function(AsmaUlHusnaEntity name)? loaded,
    T Function(String message)? error,
  }) {
    return switch (this) {
      DailyAsmaUlHusnaInitial() => initial != null ? initial() : orElse(),
      DailyAsmaUlHusnaStateLoading() => loading != null ? loading() : orElse(),
      DailyAsmaUlHusnaLoaded(:final name) =>
        loaded != null ? loaded(name) : orElse(),
      DailyAsmaUlHusnaStateError(:final message) =>
        error != null ? error(message) : orElse(),
    };
  }
}

class DailyAsmaUlHusnaInitial extends DailyAsmaUlHusnaState {
  const DailyAsmaUlHusnaInitial();
}

class DailyAsmaUlHusnaStateLoading extends DailyAsmaUlHusnaState {
  const DailyAsmaUlHusnaStateLoading();
}

class DailyAsmaUlHusnaLoaded extends DailyAsmaUlHusnaState {
  const DailyAsmaUlHusnaLoaded(this.name);
  final AsmaUlHusnaEntity name;
}

class DailyAsmaUlHusnaStateError extends DailyAsmaUlHusnaState {
  const DailyAsmaUlHusnaStateError(this.message);
  final String message;
}

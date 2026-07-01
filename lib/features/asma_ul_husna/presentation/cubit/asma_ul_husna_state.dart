import 'package:sana/features/asma_ul_husna/domain/entities/asma_ul_husna_entity.dart';

sealed class AsmaUlHusnaState {
  const AsmaUlHusnaState();

  const factory AsmaUlHusnaState.initial() = AsmaUlHusnaInitial;
  const factory AsmaUlHusnaState.loading() = AsmaUlHusnaLoading;
  const factory AsmaUlHusnaState.loaded(List<AsmaUlHusnaEntity> names) = AsmaUlHusnaLoaded;
  const factory AsmaUlHusnaState.error(String message) = AsmaUlHusnaError;

  T when<T>({
    required T Function() initial,
    required T Function() loading,
    required T Function(List<AsmaUlHusnaEntity> names) loaded,
    required T Function(String message) error,
  }) {
    return switch (this) {
      AsmaUlHusnaInitial() => initial(),
      AsmaUlHusnaLoading() => loading(),
      AsmaUlHusnaLoaded(:final names) => loaded(names),
      AsmaUlHusnaError(:final message) => error(message),
    };
  }
}

class AsmaUlHusnaInitial extends AsmaUlHusnaState {
  const AsmaUlHusnaInitial();
}

class AsmaUlHusnaLoading extends AsmaUlHusnaState {
  const AsmaUlHusnaLoading();
}

class AsmaUlHusnaLoaded extends AsmaUlHusnaState {
  const AsmaUlHusnaLoaded(this.names);
  final List<AsmaUlHusnaEntity> names;
}

class AsmaUlHusnaError extends AsmaUlHusnaState {
  const AsmaUlHusnaError(this.message);
  final String message;
}

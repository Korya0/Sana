import 'package:flutter/foundation.dart';
import 'package:sana/core/constants/constants.dart';

@immutable
sealed class LocationPositionState {
  const LocationPositionState();
}

@immutable
class LocationPositionInitial extends LocationPositionState {
  const LocationPositionInitial();

  @override
  String toString() => 'LocationPositionState.initial()';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocationPositionInitial && runtimeType == other.runtimeType;

  @override
  int get hashCode => runtimeType.hashCode;
}

@immutable
class LocationPositionLoading extends LocationPositionState {
  const LocationPositionLoading();

  @override
  String toString() => 'LocationPositionState.loading()';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocationPositionLoading && runtimeType == other.runtimeType;

  @override
  int get hashCode => runtimeType.hashCode;
}

@immutable
class LocationPositionSaved extends LocationPositionState {
  const LocationPositionSaved({
    this.message = AppStrings.locationSavedSuccess,
  });

  final String message;

  @override
  String toString() => 'LocationPositionState.saved(message: $message)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocationPositionSaved &&
          runtimeType == other.runtimeType &&
          message == other.message;

  @override
  int get hashCode => message.hashCode;
}

@immutable
class LocationPositionError extends LocationPositionState {
  const LocationPositionError({required this.message});

  final String message;

  @override
  String toString() => 'LocationPositionState.error(message: $message)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocationPositionError &&
          runtimeType == other.runtimeType &&
          message == other.message;

  @override
  int get hashCode => message.hashCode;
}

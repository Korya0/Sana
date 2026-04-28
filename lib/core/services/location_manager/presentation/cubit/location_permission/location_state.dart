import 'package:flutter/foundation.dart';
import 'package:sana/core/constants/app_strings.dart';

@immutable
sealed class LocationState {
  const LocationState();
}

@immutable
class LocationInitial extends LocationState {
  const LocationInitial();

  @override
  String toString() => 'LocationState.initial()';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocationInitial && runtimeType == other.runtimeType;

  @override
  int get hashCode => runtimeType.hashCode;
}

@immutable
class LocationLoading extends LocationState {
  const LocationLoading();

  @override
  String toString() => 'LocationState.loading()';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocationLoading && runtimeType == other.runtimeType;

  @override
  int get hashCode => runtimeType.hashCode;
}

@immutable
class LocationShowChoiceSheet extends LocationState {
  const LocationShowChoiceSheet();

  @override
  String toString() => 'LocationState.showChoiceSheet()';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocationShowChoiceSheet && runtimeType == other.runtimeType;

  @override
  int get hashCode => runtimeType.hashCode;
}

@immutable
class LocationNeedsServiceEnable extends LocationState {
  const LocationNeedsServiceEnable({
    this.message = AppStrings.needsLocationService,
  });

  final String message;

  @override
  String toString() => 'LocationState.needsServiceEnable(message: $message)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocationNeedsServiceEnable &&
          runtimeType == other.runtimeType &&
          message == other.message;

  @override
  int get hashCode => message.hashCode;
}

@immutable
class LocationNeedsPermission extends LocationState {
  const LocationNeedsPermission({
    this.message = AppStrings.needsLocationPermission,
  });

  final String message;

  @override
  String toString() => 'LocationState.needsPermission(message: $message)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocationNeedsPermission &&
          runtimeType == other.runtimeType &&
          message == other.message;

  @override
  int get hashCode => message.hashCode;
}

@immutable
class LocationSuccess extends LocationState {
  const LocationSuccess({this.message = AppStrings.success});

  final String message;

  @override
  String toString() => 'LocationState.success(message: $message)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocationSuccess &&
          runtimeType == other.runtimeType &&
          message == other.message;

  @override
  int get hashCode => message.hashCode;
}

@immutable
class LocationPermissionPermanentlyDenied extends LocationState {
  const LocationPermissionPermanentlyDenied();

  @override
  String toString() => 'LocationState.permissionPermanentlyDenied()';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocationPermissionPermanentlyDenied &&
          runtimeType == other.runtimeType;

  @override
  int get hashCode => runtimeType.hashCode;
}

@immutable
class LocationError extends LocationState {
  const LocationError({required this.message});

  final String message;

  @override
  String toString() => 'LocationState.error(message: $message)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocationError &&
          runtimeType == other.runtimeType &&
          message == other.message;

  @override
  int get hashCode => message.hashCode;
}

@immutable
class LocationDisabled extends LocationState {
  const LocationDisabled({this.message = AppStrings.locationDisabled});

  final String message;

  @override
  String toString() => 'LocationState.disabled(message: $message)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocationDisabled &&
          runtimeType == other.runtimeType &&
          message == other.message;

  @override
  int get hashCode => message.hashCode;
}

@immutable
class LocationPermissionDenied extends LocationState {
  const LocationPermissionDenied({
    this.message = AppStrings.locationPermissionDenied,
  });

  final String message;

  @override
  String toString() => 'LocationState.permissionDenied(message: $message)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocationPermissionDenied &&
          runtimeType == other.runtimeType &&
          message == other.message;

  @override
  int get hashCode => message.hashCode;
}

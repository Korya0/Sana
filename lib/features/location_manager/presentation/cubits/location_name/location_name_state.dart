import 'package:flutter/foundation.dart';

@immutable
sealed class LocationNameState {
  const LocationNameState();
}

@immutable
class LocationNameInitial extends LocationNameState {
  const LocationNameInitial();

  @override
  String toString() => 'LocationNameState.initial()';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocationNameInitial && runtimeType == other.runtimeType;

  @override
  int get hashCode => runtimeType.hashCode;
}

@immutable
class LocationNameLoading extends LocationNameState {
  const LocationNameLoading();

  @override
  String toString() => 'LocationNameState.loading()';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocationNameLoading && runtimeType == other.runtimeType;

  @override
  int get hashCode => runtimeType.hashCode;
}

@immutable
class LocationNameLoaded extends LocationNameState {
  const LocationNameLoaded(this.location, {this.lat, this.lng});

  final String location;
  final double? lat;
  final double? lng;

  @override
  String toString() =>
      'LocationNameState.loaded(location: $location, lat: $lat, lng: $lng)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocationNameLoaded &&
          runtimeType == other.runtimeType &&
          location == other.location &&
          lat == other.lat &&
          lng == other.lng;

  @override
  int get hashCode => Object.hash(location, lat, lng);
}

@immutable
class LocationNameError extends LocationNameState {
  const LocationNameError(this.message);

  final String message;

  @override
  String toString() => 'LocationNameState.error(message: $message)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocationNameError &&
          runtimeType == other.runtimeType &&
          message == other.message;

  @override
  int get hashCode => message.hashCode;
}

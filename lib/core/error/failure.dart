import 'package:equatable/equatable.dart';

/// Base class for all app failures (errors).
abstract class Failure extends Equatable {
  const Failure({required this.message});

  /// User-friendly error message.
  final String message;

  @override
  List<Object?> get props => [message];
}

/// Errors related to location services (GPS, permissions).
class LocationFailure extends Failure {
  const LocationFailure({required super.message});
}

/// Errors related to server communication (APIs, Firestore).
class ServerFailure extends Failure {
  const ServerFailure({required super.message});
}

/// Errors related to network connectivity (offline, timeout).
class NetworkFailure extends Failure {
  const NetworkFailure({required super.message});
}

/// Errors related to local storage (SharedPreferences, local files).
class CacheFailure extends Failure {
  const CacheFailure({required super.message});
}

/// Errors related to device sensors (e.g., compass).
class SensorFailure extends Failure {
  const SensorFailure({required super.message});
}

/// Errors when required data is missing.
class MissingDataFailure extends Failure {
  const MissingDataFailure({required super.message});
}

/// Unknown or unexpected errors.
class UnknownFailure extends Failure {
  const UnknownFailure({required super.message});
}

import 'package:equatable/equatable.dart';

/// Base class for all app failures (errors).
abstract class Failure extends Equatable {
  const Failure({required this.message, this.statusCode});

  /// User-friendly error message.
  final String message;

  /// Optional HTTP status code or internal error code.
  final int? statusCode;

  @override
  List<Object?> get props => [message, statusCode];
}

/// Errors related to location services (GPS, permissions).
class LocationFailure extends Failure {
  const LocationFailure({required super.message, super.statusCode});
}

/// Errors related to server communication (APIs, Firestore).
class ServerFailure extends Failure {
  const ServerFailure({required super.message, super.statusCode});
}

/// Errors related to network connectivity (offline, timeout).
class NetworkFailure extends Failure {
  const NetworkFailure({required super.message, super.statusCode});
}

/// Errors related to local storage (SharedPreferences, local files).
class CacheFailure extends Failure {
  const CacheFailure({required super.message, super.statusCode});
}

/// Errors related to device sensors (e.g., compass).
class SensorFailure extends Failure {
  const SensorFailure({required super.message, super.statusCode});
}

/// Errors when required data is missing.
class MissingDataFailure extends Failure {
  const MissingDataFailure({required super.message, super.statusCode});
}

/// Unknown or unexpected errors.
class UnknownFailure extends Failure {
  const UnknownFailure({required super.message, super.statusCode});
}

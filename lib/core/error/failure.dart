import 'package:flutter/foundation.dart';

@immutable
sealed class Failure {
  const Failure({required this.message, this.statusCode});

  // Factory constructors for backward compatibility with 'const' usage
  const factory Failure.server({required String message, int? statusCode}) =
      ServerFailure;
  const factory Failure.network({required String message}) = NetworkFailure;
  const factory Failure.cache({required String message}) = CacheFailure;
  const factory Failure.location({required String message}) = LocationFailure;
  const factory Failure.sensor({required String message}) = SensorFailure;
  const factory Failure.wrongPassword({required String message}) = WrongPasswordFailure;
  const factory Failure.missingData({required String message}) =
      MissingDataFailure;
  const factory Failure.unknown({required String message}) = UnknownFailure;

  final String message;
  final int? statusCode;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Failure &&
        other.runtimeType == runtimeType &&
        other.message == message &&
        other.statusCode == statusCode;
  }

  @override
  int get hashCode => message.hashCode ^ statusCode.hashCode;
}

class ServerFailure extends Failure {
  const ServerFailure({required super.message, super.statusCode});
}

class NetworkFailure extends Failure {
  const NetworkFailure({required super.message});
}

class CacheFailure extends Failure {
  const CacheFailure({required super.message});
}

class LocationFailure extends Failure {
  const LocationFailure({required super.message});
}

class SensorFailure extends Failure {
  const SensorFailure({required super.message});
}

class WrongPasswordFailure extends Failure {
  const WrongPasswordFailure({required super.message});
}

class MissingDataFailure extends Failure {
  const MissingDataFailure({required super.message});
}

class UnknownFailure extends Failure {
  const UnknownFailure({required super.message});
}

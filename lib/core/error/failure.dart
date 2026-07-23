import 'package:flutter/foundation.dart';

@immutable
sealed class Failure {
  const Failure({required this.message, this.statusCode});

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

  @override
  String toString() => 'ServerFailure(message: $message, statusCode: $statusCode)';
}

class NetworkFailure extends Failure {
  const NetworkFailure({required super.message});

  @override
  String toString() => 'NetworkFailure(message: $message)';
}

class CacheFailure extends Failure {
  const CacheFailure({required super.message});

  @override
  String toString() => 'CacheFailure(message: $message)';
}

class LocationFailure extends Failure {
  const LocationFailure({required super.message});

  @override
  String toString() => 'LocationFailure(message: $message)';
}

class SensorFailure extends Failure {
  const SensorFailure({required super.message});

  @override
  String toString() => 'SensorFailure(message: $message)';
}

class WrongPasswordFailure extends Failure {
  const WrongPasswordFailure({required super.message});

  @override
  String toString() => 'WrongPasswordFailure(message: $message)';
}

class MissingDataFailure extends Failure {
  const MissingDataFailure({required super.message});

  @override
  String toString() => 'MissingDataFailure(message: $message)';
}

class UnknownFailure extends Failure {
  const UnknownFailure({required super.message});

  @override
  String toString() => 'UnknownFailure(message: $message)';
}

class ReminderFailure extends Failure {
  const ReminderFailure({required super.message});

  @override
  String toString() => 'ReminderFailure(message: $message)';
}

class NotificationPermissionFailure extends Failure {
  const NotificationPermissionFailure({required super.message});

  @override
  String toString() => 'NotificationPermissionFailure(message: $message)';
}

abstract class Failure {

  Failure({required this.message, this.technicalMessage});
  final String message;
  final String? technicalMessage;
}

class LocationFailure extends Failure {
  LocationFailure({required super.message, super.technicalMessage});
}

class ServerFailure extends Failure {
  ServerFailure({required super.message, super.technicalMessage});
}

class NetworkFailure extends Failure {
  NetworkFailure({required super.message, super.technicalMessage});
}

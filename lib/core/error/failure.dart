abstract class Failure {
  final String message;

  Failure({required this.message});
}

class LocationFailure extends Failure {
  LocationFailure({required super.message});
}

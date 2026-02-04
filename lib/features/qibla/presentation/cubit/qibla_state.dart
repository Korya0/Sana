import 'package:equatable/equatable.dart';

abstract class QiblaState extends Equatable {
  const QiblaState();

  @override
  List<Object?> get props => [];
}

class QiblaInitial extends QiblaState {}

class QiblaLoading extends QiblaState {}

class QiblaLoaded extends QiblaState {
  final double qiblaDirection;
  final double distanceToKaaba;
  final double lat;
  final double lng;

  const QiblaLoaded({
    required this.qiblaDirection,
    required this.distanceToKaaba,
    required this.lat,
    required this.lng,
  });

  @override
  List<Object?> get props => [qiblaDirection, distanceToKaaba, lat, lng];
}

class QiblaError extends QiblaState {
  final String message;

  const QiblaError(this.message);

  @override
  List<Object?> get props => [message];
}

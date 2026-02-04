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

  const QiblaLoaded({
    required this.qiblaDirection,
    required this.distanceToKaaba,
  });

  @override
  List<Object?> get props => [qiblaDirection, distanceToKaaba];
}

class QiblaError extends QiblaState {
  final String message;

  const QiblaError(this.message);

  @override
  List<Object?> get props => [message];
}

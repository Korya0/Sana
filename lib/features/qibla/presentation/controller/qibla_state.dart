part of 'qibla_cubit.dart';

abstract class QiblaState extends Equatable {
  const QiblaState();

  @override
  List<Object?> get props => [];
}

class QiblaInitial extends QiblaState {}

class QiblaLoading extends QiblaState {}

class QiblaLoaded extends QiblaState {
  const QiblaLoaded({
    required this.qiblaDirection,
    required this.distanceToKaaba,
  });
  final double qiblaDirection;
  final double distanceToKaaba;

  @override
  List<Object?> get props => [qiblaDirection, distanceToKaaba];
}

class QiblaError extends QiblaState {
  const QiblaError(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}

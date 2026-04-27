sealed class QiblaState {
  const QiblaState();
}

final class QiblaInitial extends QiblaState {
  const QiblaInitial();
}

final class QiblaLoading extends QiblaState {
  const QiblaLoading();
}

final class QiblaLoaded extends QiblaState {
  const QiblaLoaded({
    required this.qiblaDirection,
    required this.distanceToKaaba,
  });
  final double qiblaDirection;
  final double distanceToKaaba;
}

final class QiblaError extends QiblaState {
  const QiblaError(this.message);
  final String message;
}

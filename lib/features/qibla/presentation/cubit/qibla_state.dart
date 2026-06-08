import 'package:sana/features/qibla/domain/entities/qibla_entities.dart';

enum QiblaMode { compass, map }

sealed class QiblaState {
  const QiblaState();
}

final class QiblaInitial extends QiblaState {
  const QiblaInitial();
}

final class QiblaLoading extends QiblaState {
  const QiblaLoading();
}

final class QiblaSuccess extends QiblaState {
  const QiblaSuccess({
    required this.qiblaDirection,
    required this.distanceToKaaba,
    required this.qiblaMode,
    required this.userLocation,
  });
  final double qiblaDirection;
  final double distanceToKaaba;
  final QiblaMode qiblaMode;
  final QiblaLocationEntity userLocation;

  QiblaSuccess copyWith({
    double? qiblaDirection,
    double? distanceToKaaba,
    QiblaMode? qiblaMode,
    QiblaLocationEntity? userLocation,
  }) {
    return QiblaSuccess(
      qiblaDirection: qiblaDirection ?? this.qiblaDirection,
      distanceToKaaba: distanceToKaaba ?? this.distanceToKaaba,
      qiblaMode: qiblaMode ?? this.qiblaMode,
      userLocation: userLocation ?? this.userLocation,
    );
  }
}

final class QiblaError extends QiblaState {
  const QiblaError(this.message);
  final String message;
}

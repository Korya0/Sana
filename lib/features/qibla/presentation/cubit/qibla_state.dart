import 'package:sana/features/qibla/domain/entities/qibla_entities.dart';
import 'package:flutter/foundation.dart';

enum QiblaMode { compass, map }

@immutable
sealed class QiblaState {
  const QiblaState();

  @override
  bool operator ==(Object other) => identical(this, other);

  @override
  int get hashCode => runtimeType.hashCode;
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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is QiblaSuccess &&
        other.qiblaDirection == qiblaDirection &&
        other.distanceToKaaba == distanceToKaaba &&
        other.qiblaMode == qiblaMode &&
        other.userLocation == userLocation;
  }

  @override
  int get hashCode => Object.hash(
    qiblaDirection,
    distanceToKaaba,
    qiblaMode,
    userLocation,
  );
}

final class QiblaError extends QiblaState {
  const QiblaError(this.message);
  final String message;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is QiblaError && other.message == message;
  }

  @override
  int get hashCode => message.hashCode;
}

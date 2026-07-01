import 'package:flutter/foundation.dart';

enum QiblaMessageType { perfect, close, adjusting, searching }

@immutable
class QiblaMessageEntity {
  const QiblaMessageEntity({
    required this.message,
    required this.subMessage,
    required this.type,
  });
  final String message;
  final String subMessage;
  final QiblaMessageType type;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is QiblaMessageEntity &&
        other.message == message &&
        other.subMessage == subMessage &&
        other.type == type;
  }

  @override
  int get hashCode => Object.hash(message, subMessage, type);
}

@immutable
class QiblaLocationEntity {
  const QiblaLocationEntity({required this.latitude, required this.longitude});
  final double latitude;
  final double longitude;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is QiblaLocationEntity &&
        other.latitude == latitude &&
        other.longitude == longitude;
  }

  @override
  int get hashCode => Object.hash(latitude, longitude);
}

@immutable
class QiblaDirectionEntity {
  const QiblaDirectionEntity({
    required this.qiblaDirection,
    required this.distanceToKaaba,
    required this.userLocation,
  });
  final double qiblaDirection;
  final double distanceToKaaba;
  final QiblaLocationEntity userLocation;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is QiblaDirectionEntity &&
        other.qiblaDirection == qiblaDirection &&
        other.distanceToKaaba == distanceToKaaba &&
        other.userLocation == userLocation;
  }

  @override
  int get hashCode =>
      Object.hash(qiblaDirection, distanceToKaaba, userLocation);
}

@immutable
class QiblaCompassDataEntity {
  const QiblaCompassDataEntity({
    required this.compassRotation,
    required this.arrowRotation,
    required this.angleDifference,
    required this.qiblaMessage,
  });
  final double compassRotation;
  final double arrowRotation;
  final double angleDifference;
  final QiblaMessageEntity qiblaMessage;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is QiblaCompassDataEntity &&
        other.compassRotation == compassRotation &&
        other.arrowRotation == arrowRotation &&
        other.angleDifference == angleDifference &&
        other.qiblaMessage == qiblaMessage;
  }

  @override
  int get hashCode => Object.hash(
    compassRotation,
    arrowRotation,
    angleDifference,
    qiblaMessage,
  );
}

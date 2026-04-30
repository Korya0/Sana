enum QiblaMessageType { perfect, close, adjusting, searching }

class QiblaMessageEntity {
  const QiblaMessageEntity({
    required this.message,
    required this.subMessage,
    required this.type,
  });
  final String message;
  final String subMessage;
  final QiblaMessageType type;
}

class QiblaLocationEntity {
  const QiblaLocationEntity({required this.latitude, required this.longitude});
  final double latitude;
  final double longitude;
}

class QiblaDirectionEntity {
  const QiblaDirectionEntity({
    required this.qiblaDirection,
    required this.distanceToKaaba,
  });
  final double qiblaDirection;
  final double distanceToKaaba;
}

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
}

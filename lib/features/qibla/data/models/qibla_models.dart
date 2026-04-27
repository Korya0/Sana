enum QiblaMessageType { perfect, close, adjusting, searching }

class QiblaMessageModel {
  const QiblaMessageModel({
    required this.message,
    required this.subMessage,
    required this.type,
  });
  final String message;
  final String subMessage;
  final QiblaMessageType type;
}

class QiblaLocationModel {
  const QiblaLocationModel({required this.latitude, required this.longitude});
  final double latitude;
  final double longitude;
}

class QiblaCompassData {
  const QiblaCompassData({
    required this.compassRotation,
    required this.arrowRotation,
    required this.angleDifference,
    required this.qiblaMessage,
  });
  final double compassRotation;
  final double arrowRotation;
  final double angleDifference;
  final QiblaMessageModel qiblaMessage;
}

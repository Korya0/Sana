import 'package:sana/features/qibla/domain/entities/qibla_entities.dart';

class QiblaMessageModel {
  const QiblaMessageModel({
    required this.message,
    required this.subMessage,
    required this.type,
  });
  final String message;
  final String subMessage;
  final QiblaMessageType type;

  QiblaMessageEntity toEntity() => QiblaMessageEntity(
        message: message,
        subMessage: subMessage,
        type: type,
      );
}

class QiblaLocationModel {
  const QiblaLocationModel({required this.latitude, required this.longitude});
  final double latitude;
  final double longitude;

  QiblaLocationEntity toEntity() => QiblaLocationEntity(
        latitude: latitude,
        longitude: longitude,
      );
}

class QiblaCompassDataModel {
  const QiblaCompassDataModel({
    required this.compassRotation,
    required this.arrowRotation,
    required this.angleDifference,
    required this.qiblaMessage,
  });
  final double compassRotation;
  final double arrowRotation;
  final double angleDifference;
  final QiblaMessageModel qiblaMessage;

  QiblaCompassDataEntity toEntity() => QiblaCompassDataEntity(
        compassRotation: compassRotation,
        arrowRotation: arrowRotation,
        angleDifference: angleDifference,
        qiblaMessage: qiblaMessage.toEntity(),
      );
}

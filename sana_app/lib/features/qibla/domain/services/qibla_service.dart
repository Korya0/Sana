import 'package:sana/features/qibla/domain/entities/qibla_entities.dart';

abstract interface class IQiblaService {
  double calculateQiblaDirection(double userLat, double userLng);
  double calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  );
  double calculateAngleDifference(
    double deviceHeading,
    double qiblaDirection,
  );
  QiblaMessageEntity getQiblaMessage(double angleDifference);
  double calculateCompassRotation(double heading);
  double calculateArrowRotation(double angleDifference);
}

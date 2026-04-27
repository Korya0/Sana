import 'dart:math' as math;
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/features/qibla/data/models/qibla_models.dart';
import 'package:sana/features/qibla/data/qibla_constants.dart';

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
  QiblaMessageModel getQiblaMessage(double angleDifference);
  double calculateCompassRotation(double heading);
  double calculateArrowRotation(double angleDifference);
}

class QiblaServiceImpl implements IQiblaService {
  const QiblaServiceImpl();

  @override
  double calculateQiblaDirection(double userLat, double userLng) {
    final dLng = (QiblaConstants.kaabaLongitude - userLng) * math.pi / 180;
    final lat1 = userLat * math.pi / 180;
    const lat2 = QiblaConstants.kaabaLatitude * math.pi / 180;

    final y = math.sin(dLng) * math.cos(lat2);
    final x =
        math.cos(lat1) * math.sin(lat2) -
        math.sin(lat1) * math.cos(lat2) * math.cos(dLng);

    var bearing = math.atan2(y, x);
    bearing = bearing * 180 / math.pi;
    bearing = (bearing + 360) % 360;

    return bearing;
  }

  @override
  double calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    final dLat = (lat2 - lat1) * math.pi / 180;
    final dLon = (lon2 - lon1) * math.pi / 180;

    final a =
        math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(lat1 * math.pi / 180) *
            math.cos(lat2 * math.pi / 180) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);

    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return QiblaConstants.earthRadiusKm * c;
  }

  @override
  double calculateAngleDifference(
    double deviceHeading,
    double qiblaDirection,
  ) {
    var diff = qiblaDirection - deviceHeading;

    if (diff > 180) {
      diff -= 360;
    } else if (diff < -180) {
      diff += 360;
    }

    return diff;
  }

  @override
  QiblaMessageModel getQiblaMessage(double angleDifference) {
    final absAngle = angleDifference.abs();
    final direction = angleDifference > 0
        ? AppStrings.qiblaRight
        : AppStrings.qiblaLeft;

    if (absAngle < QiblaConstants.perfectTolerance) {
      return const QiblaMessageModel(
        message: AppStrings.qiblaPerfectMessage,
        subMessage: AppStrings.qiblaPerfectSubMessage,
        type: QiblaMessageType.perfect,
      );
    } else if (absAngle < QiblaConstants.closeTolerance) {
      return QiblaMessageModel(
        message: AppStrings.qiblaCloseMessage,
        subMessage: AppStrings.qiblaCloseSubMessage(direction),
        type: QiblaMessageType.close,
      );
    } else if (absAngle < QiblaConstants.adjustingTolerance) {
      return QiblaMessageModel(
        message: AppStrings.qiblaAdjustingMessage(direction),
        subMessage: AppStrings.qiblaAdjustingSubMessage(absAngle.toInt()),
        type: QiblaMessageType.adjusting,
      );
    } else {
      return QiblaMessageModel(
        message: AppStrings.qiblaSearchingMessage(direction),
        subMessage: AppStrings.qiblaSearchingSubMessage(absAngle.toInt()),
        type: QiblaMessageType.searching,
      );
    }
  }

  @override
  double calculateCompassRotation(double heading) {
    return -heading * math.pi / 180;
  }

  @override
  double calculateArrowRotation(double angleDifference) {
    return angleDifference * math.pi / 180;
  }
}

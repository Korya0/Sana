import 'dart:math' as math;

import 'package:sana/features/qibla/data/models/qibla_models.dart';
import 'package:sana/features/qibla/data/qibla_constants.dart';

class QiblaService {
  /// Calculate Qibla direction from user location using Haversine formula
  static double calculateQiblaDirection(double userLat, double userLng) {
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

  /// Calculate distance to Kaaba in kilometers using Haversine formula
  static double calculateDistance(
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

  /// Calculate the angle difference between device heading and Qibla
  static double calculateAngleDifference(
    double deviceHeading,
    double qiblaDirection,
  ) {
    var diff = qiblaDirection - deviceHeading;

    // Normalize to -180 to 180
    if (diff > 180) {
      diff -= 360;
    } else if (diff < -180) {
      diff += 360;
    }

    return diff;
  }

  /// Get user-friendly message based on angle difference
  static QiblaMessage getQiblaMessage(double angleDifference) {
    final absAngle = angleDifference.abs();
    final direction = angleDifference > 0 ? 'اليمين' : 'اليسار';

    if (absAngle < QiblaConstants.perfectTolerance) {
      return QiblaMessage(
        message: 'ممتاز! أنت في الاتجاه الصحيح',
        subMessage: 'يمكنك الصلاة الآن',
        type: QiblaMessageType.perfect,
      );
    } else if (absAngle < QiblaConstants.closeTolerance) {
      return QiblaMessage(
        message: 'قريب جداً من الاتجاه الصحيح',
        subMessage: 'حرك الهاتف قليلاً نحو $direction',
        type: QiblaMessageType.close,
      );
    } else if (absAngle < QiblaConstants.adjustingTolerance) {
      return QiblaMessage(
        message: 'استمر في التوجيه نحو $direction',
        subMessage: 'متبقي ${absAngle.toInt()}° تقريباً',
        type: QiblaMessageType.adjusting,
      );
    } else {
      return QiblaMessage(
        message: 'استدر نحو $direction',
        subMessage: 'متبقي ${absAngle.toInt()}° تقريباً',
        type: QiblaMessageType.searching,
      );
    }
  }
}

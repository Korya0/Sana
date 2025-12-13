import 'package:flutter/material.dart';
import 'package:sana/core/theme/style/app_colors.dart';

/// Constants used throughout the Qibla feature
class QiblaConstants {
  // Tolerance levels for Qibla direction accuracy (in degrees)

  /// Perfect alignment - within 3 degrees
  static const double perfectTolerance = 3.0;

  /// Close to Qibla - within 10 degrees
  static const double closeTolerance = 10.0;

  /// Adjusting direction - within 45 degrees
  static const double adjustingTolerance = 45.0;

  // Kaaba coordinates
  static const double kaabaLatitude = 21.4225;
  static const double kaabaLongitude = 39.8262;

  // Colors for Qibla states
  static const Color activeColor = Colors.green;
  static Color get inactiveColor => AppColors.gold;

  // Compass settings
  static const double compassSize = 300.0;
  static const double kaabaIconSize = 60.0;
  static const double navigationIconSize = 60.0;
  static const double centerDotSize = 20.0;

  // Earth radius in kilometers for distance calculations
  static const double earthRadiusKm = 6371.0;
}

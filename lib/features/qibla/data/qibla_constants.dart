import 'package:flutter/material.dart';
import 'package:sana/core/theme/style/app_colors.dart';

/// Constants used throughout the Qibla feature
class QiblaConstants {
  // Tolerance levels for Qibla direction accuracy (in degrees)

  /// Perfect alignment - within 3 degrees
  static const double perfectTolerance = 3;

  /// Close to Qibla - within 10 degrees
  static const double closeTolerance = 10;

  /// Adjusting direction - within 45 degrees
  static const double adjustingTolerance = 45;

  // Kaaba coordinates
  static const double kaabaLatitude = 21.4225;
  static const double kaabaLongitude = 39.8262;

  // Colors for Qibla states
  static const Color activeColor = Colors.green;
  static Color get inactiveColor => AppColors.gold;

  // Compass settings
  static const double compassSize = 300;
  static const double kaabaIconSize = 60;
  static const double navigationIconSize = 60;
  static const double centerDotSize = 20;

  // Earth radius in kilometers for distance calculations
  static const double earthRadiusKm = 6371;
}

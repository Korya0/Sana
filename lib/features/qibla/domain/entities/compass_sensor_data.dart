import 'package:sana/core/constants/app_constants.dart';

class CompassSensorData {
  const CompassSensorData({
    required this.heading,
    required this.tilt,
    this.isLowAccuracy = false,
  });

  // Phone heading
  final double heading;

  // Phone tilt
  final double tilt;

  // Low accuracy
  final bool isLowAccuracy;

  // Not flat
  bool get isNotFlat => tilt > AppConstants.qiblaTiltTolerance;
}

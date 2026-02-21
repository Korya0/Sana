import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:sana/features/qibla/data/qibla_constants.dart';
import 'package:sana/features/qibla/data/services/qibla_service.dart';

/// Handles compass stream and calculates angle differences
class QiblaCompassStream extends StatelessWidget {

  const QiblaCompassStream({
    required this.qiblaDirection, required this.builder, super.key,
  });
  final double qiblaDirection;
  final Widget Function(double? angleDiff, bool isNearQibla, double heading)
  builder;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<CompassEvent>(
      stream: FlutterCompass.events,
      builder: (context, snapshot) {
        double? diff;
        var isNearQibla = false;
        double heading = 0;

        if (snapshot.hasData) {
          heading = snapshot.data!.heading ?? 0;
          diff = QiblaService.calculateAngleDifference(heading, qiblaDirection);
          isNearQibla = diff.abs() <= QiblaConstants.closeTolerance;
        }

        return builder(diff, isNearQibla, heading);
      },
    );
  }
}

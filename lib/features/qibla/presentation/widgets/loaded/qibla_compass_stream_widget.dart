import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:sana/core/di/service_locator.dart';
import 'package:sana/features/qibla/data/models/qibla_models.dart';
import 'package:sana/features/qibla/data/services/qibla_service.dart';

class QiblaCompassStreamWidget extends StatelessWidget {
  const QiblaCompassStreamWidget({
    required this.qiblaDirection,
    required this.builder,
    super.key,
  });
  final double qiblaDirection;
  final Widget Function(QiblaCompassData? data) builder;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<CompassEvent>(
      stream: FlutterCompass.events,
      builder: (context, snapshot) {
        QiblaCompassData? data;

        if (snapshot.hasData) {
          final heading = snapshot.data!.heading ?? 0;
          final service = sl<IQiblaService>();
          final diff = service.calculateAngleDifference(heading, qiblaDirection);
          final message = service.getQiblaMessage(diff);
          
          data = QiblaCompassData(
            compassRotation: service.calculateCompassRotation(heading),
            arrowRotation: service.calculateArrowRotation(diff),
            angleDifference: diff,
            qiblaMessage: message,
          );
        }

        return builder(data);
      },
    );
  }
}

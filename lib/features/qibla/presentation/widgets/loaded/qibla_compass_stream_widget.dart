import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:sana/core/di/service_locator.dart';
import 'package:sana/features/qibla/domain/entities/qibla_entities.dart';
import 'package:sana/features/qibla/domain/use_cases/get_qibla_compass_stream_use_case.dart';

class QiblaCompassStreamWidget extends StatelessWidget {
  const QiblaCompassStreamWidget({
    required this.qiblaDirection,
    required this.builder,
    super.key,
  });
  final double qiblaDirection;
  final Widget Function(QiblaCompassDataEntity? data) builder;

  @override
  Widget build(BuildContext context) {
    final stream = FlutterCompass.events;
    
    if (stream == null) {
      return builder(null);
    }

    return StreamBuilder<QiblaCompassDataEntity>(
      stream: sl<GetQiblaCompassStreamUseCase>().call(
        headingStream: stream.map((event) => event.heading ?? 0),
        qiblaDirection: qiblaDirection,
      ),
      builder: (context, snapshot) {
        return builder(snapshot.data);
      },
    );
  }
}

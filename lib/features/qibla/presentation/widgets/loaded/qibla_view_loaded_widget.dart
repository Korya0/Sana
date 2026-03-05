import 'package:flutter/material.dart';
import 'package:sana/features/qibla/presentation/controller/qibla_cubit.dart';
import 'package:sana/features/qibla/presentation/widgets/loaded/qibla_compass_stream.dart';
import 'package:sana/features/qibla/presentation/widgets/loaded/qibla_content_layout.dart';

/// Main loaded widget that coordinates compass stream and content layout
class QiblaViewLoadedWidget extends StatelessWidget {
  const QiblaViewLoadedWidget({required this.state, super.key});

  final QiblaLoaded state;

  @override
  Widget build(BuildContext context) {
    return QiblaCompassStream(
      qiblaDirection: state.qiblaDirection,
      builder: (angleDiff, isNearQibla, heading) {
        return QiblaContentLayout(
          angleDifference: angleDiff,
          heading: heading,
          qiblaDirection: state.qiblaDirection,
          isNearQibla: isNearQibla,
          distanceToKaaba: state.distanceToKaaba,
        );
      },
    );
  }
}

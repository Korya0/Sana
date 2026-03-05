import 'package:flutter/material.dart';
import 'package:sana/features/qibla/presentation/widgets/compass/qibla_compass.dart';
import 'package:sana/features/qibla/presentation/widgets/hint/qibla_hint_message.dart';
import 'package:sana/features/qibla/presentation/widgets/qibla_header_info.dart';

/// Layout structure for Qibla content
class QiblaContentLayout extends StatelessWidget {
  const QiblaContentLayout({
    required this.angleDifference,
    required this.heading,
    required this.qiblaDirection,
    required this.isNearQibla,
    required this.distanceToKaaba,
    super.key,
  });
  final double? angleDifference;
  final double heading;
  final double qiblaDirection;
  final bool isNearQibla;
  final double distanceToKaaba;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),

        // Hint message
        if (angleDifference != null)
          QiblaHintMessage(angleDifference: angleDifference!)
        else
          const SizedBox.shrink(),

        const SizedBox(height: 20),

        // Compass
        Expanded(
          child: Center(
            child: QiblaCompass(
              heading: heading,
              qiblaDirection: qiblaDirection,
              activeColor: isNearQibla,
            ),
          ),
        ),

        const SizedBox(height: 20),

        // Qibla info
        QiblaInfo(distance: distanceToKaaba, direction: qiblaDirection),

        const SizedBox(height: 40),
      ],
    );
  }
}

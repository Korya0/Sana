import 'package:flutter/material.dart';
import 'package:sana/core/theme/style/app_spacing.dart';
import 'package:sana/features/qibla/domain/entities/qibla_entities.dart';
import 'package:sana/features/qibla/presentation/widgets/compass/qibla_compass.dart';
import 'package:sana/features/qibla/presentation/widgets/hint/qibla_hint_message.dart';
import 'package:sana/features/qibla/presentation/widgets/qibla_header_info.dart';

class QiblaContentLayoutWidget extends StatelessWidget {
  const QiblaContentLayoutWidget({
    required this.compassData,
    required this.qiblaDirection,
    required this.distanceToKaaba,
    super.key,
  });

  final QiblaCompassDataEntity? compassData;
  final double qiblaDirection;
  final double distanceToKaaba;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: AppSpacing.v20),
        if (compassData != null)
          QiblaHintMessage(qiblaMessage: compassData!.qiblaMessage)
        else
          const SizedBox.shrink(),
        const SizedBox(height: AppSpacing.v20),
        Expanded(
          child: Center(
            child: QiblaCompass(
              compassData: compassData,
              qiblaDirection: qiblaDirection,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.v20),
        QiblaHeaderInfoWidget(
          distance: distanceToKaaba,
          direction: qiblaDirection,
        ),
        const SizedBox(height: AppSpacing.v40),
      ],
    );
  }
}

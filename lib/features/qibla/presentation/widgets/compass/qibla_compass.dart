import 'package:flutter/material.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:sana/core/theme/style/app_spacing.dart';
import 'package:sana/features/qibla/data/models/qibla_models.dart';
import 'package:sana/features/qibla/data/qibla_constants.dart';
import 'package:sana/features/qibla/presentation/widgets/compass/compass_arrow.dart';
import 'package:sana/features/qibla/presentation/widgets/compass/compass_background_painter.dart';
import 'package:sana/features/qibla/presentation/widgets/compass/compass_kaaba_icon.dart';

class QiblaCompass extends StatelessWidget {
  const QiblaCompass({
    required this.compassData,
    required this.qiblaDirection,
    super.key,
  });

  final QiblaCompassData? compassData;
  final double qiblaDirection;

  @override
  Widget build(BuildContext context) {
    const size = QiblaConstants.compassSize;
    final isNearQibla = compassData?.qiblaMessage.type == QiblaMessageType.perfect ||
        compassData?.qiblaMessage.type == QiblaMessageType.close;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CompassKaabaIcon(activeColor: isNearQibla),
        const SizedBox(height: AppSpacing.v32),
        RepaintBoundary(
          child: SizedBox(
            width: size,
            height: size,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Transform.rotate(
                  angle: compassData?.compassRotation ?? 0,
                  child: CustomPaint(
                    size: const Size(size, size),
                    painter: CompassBackgroundPainter(
                      mainDirectionStyle:
                          AppTextStyles.font20W700primary(context),
                      otherDirectionStyle:
                          AppTextStyles.font20W400Grey(context),
                    ),
                  ),
                ),
                CompassArrow(
                  rotation: compassData?.arrowRotation ?? 0,
                  activeColor: isNearQibla,
                  compassSize: size,
                ),
                _buildCenterDot(context),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCenterDot(BuildContext context) {
    return Container(
      width: QiblaConstants.centerDotSize,
      height: QiblaConstants.centerDotSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.scaffoldBackground,
        border: Border.all(
          color: AppColors.primary,
          width: QiblaConstants.compassBorderWidth,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.5),
            blurRadius: 5,
            spreadRadius: 2,
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/utils/utils.dart';
import 'package:sana/features/qibla/constants/qibla_ui_constants.dart';
import 'package:sana/features/qibla/domain/entities/qibla_entities.dart';
import 'package:sana/features/qibla/presentation/widgets/compass/compass_arrow.dart';
import 'package:sana/features/qibla/presentation/widgets/compass/compass_background_painter.dart';

class QiblaCompass extends StatefulWidget {
  const QiblaCompass({
    required this.compassData,
    required this.qiblaDirection,
    super.key,
  });

  final QiblaCompassDataEntity? compassData;
  final double qiblaDirection;

  @override
  State<QiblaCompass> createState() => _QiblaCompassState();
}

class _QiblaCompassState extends State<QiblaCompass> {
  CompassBackgroundPainter? _painter;
  TextStyle? _lastMainStyle;
  TextStyle? _lastOtherStyle;
  Color? _lastPrimaryColor;
  Color? _lastSecondaryColor;

  @override
  Widget build(BuildContext context) {
    final size = QiblaUiConstants.compassSize.r(context);
    final isNearQibla =
        widget.compassData?.qiblaMessage.type == QiblaMessageType.perfect ||
        widget.compassData?.qiblaMessage.type == QiblaMessageType.close;

    final currentMainStyle = AppTextStyles.font20W700(
      context,
    ).copyWith(color: context.color.textAccent);
    final currentOtherStyle = AppTextStyles.font20W700(
      context,
    ).copyWith(color: context.color.textSecondary);
    final currentPrimaryColor = context.color.primary;
    final currentSecondaryColor =
        context.color.secondaryScaffoldBackgroundColor;

    if (_painter == null ||
        _lastMainStyle != currentMainStyle ||
        _lastOtherStyle != currentOtherStyle ||
        _lastPrimaryColor != currentPrimaryColor ||
        _lastSecondaryColor != currentSecondaryColor) {
      _painter = CompassBackgroundPainter(
        mainDirectionStyle: currentMainStyle,
        otherDirectionStyle: currentOtherStyle,
        primaryColor: currentPrimaryColor,
        secondaryBackgroundColor: currentSecondaryColor,
      );
      _lastMainStyle = currentMainStyle;
      _lastOtherStyle = currentOtherStyle;
      _lastPrimaryColor = currentPrimaryColor;
      _lastSecondaryColor = currentSecondaryColor;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        RepaintBoundary(
          child: SizedBox(
            width: size,
            height: size,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Transform.rotate(
                  angle: widget.compassData?.compassRotation ?? 0,
                  child: CustomPaint(
                    size: Size(size, size),
                    painter: _painter,
                  ),
                ),
                CompassArrow(
                  rotation: widget.compassData?.arrowRotation ?? 0,
                  activeColor: isNearQibla,
                  compassSize: size,
                ),
                const _CenterDot(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _CenterDot extends StatelessWidget {
  const _CenterDot();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: QiblaUiConstants.centerDotSize.r(context),
      height: QiblaUiConstants.centerDotSize.r(context),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: context.color.scaffoldBackgroundColor,
        border: Border.all(
          color: context.color.primary,
          width: QiblaUiConstants.compassBorderWidth.r(context),
        ),
        boxShadow: [
          BoxShadow(
            color: context.color.primary.withValues(alpha: 0.5),
            blurRadius: 5,
            spreadRadius: 2,
          ),
        ],
      ),
    );
  }
}

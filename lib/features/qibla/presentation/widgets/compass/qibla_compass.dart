import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/utils/context_extension.dart';
import 'package:sana/features/qibla/presentation/widgets/compass/compass_dial_painter.dart';
import 'package:sana/features/qibla/presentation/widgets/compass/compass_kaaba_icon.dart';
import 'package:skeletonizer/skeletonizer.dart';

class QiblaCompass extends StatefulWidget {
  const QiblaCompass({
    required this.direction,
    required this.phoneHeading,
    required this.isFacing,
    super.key,
  });

  final double direction;
  final double? phoneHeading;
  final bool isFacing;

  @override
  State<QiblaCompass> createState() => _QiblaCompassState();
}

class _QiblaCompassState extends State<QiblaCompass> {
  static const _half = 0.5;
  static const _fullTurn = 360.0;
  static const _halfTurn = 180.0;
  static const _degreesToRadians = math.pi / _halfTurn;
  static const _kaabaRadiusRatio = 0.78;

  double _animatedHeading = AppConstants.progressStart;

  @override
  void initState() {
    super.initState();
    _animatedHeading = widget.phoneHeading ?? AppConstants.progressStart;
  }

  @override
  void didUpdateWidget(QiblaCompass oldWidget) {
    super.didUpdateWidget(oldWidget);
    final target = widget.phoneHeading ?? AppConstants.progressStart;
    // Shortest turn
    final delta =
        ((target - _animatedHeading + _fullTurn + _halfTurn) % _fullTurn) -
        _halfTurn;
    _animatedHeading += delta;
  }

  @override
  Widget build(BuildContext context) {
    final diameter = AppSize.compassDiameter;
    final radius = AppSize.compassRadius;

    final targetHeading = _animatedHeading;
    final qiblaDirection = widget.direction;
    final isFacing = widget.isFacing;

    final activeColor = context.color.iconBrand;
    final neutralColor = context.color.iconNeutral;
    final backgroundColor = context.color.scaffoldBackgroundColor;

    return Center(
      child: SizedBox(
        width: diameter,
        height: diameter,
        child: TweenAnimationBuilder<double>(
          tween: Tween<double>(end: targetHeading),
          duration: AppConstants.compassRotation150ms,
          curve: Curves.easeOutCubic,
          builder: (context, animatedVal, _) {
            // Normalized heading
            final normalizedHeading =
                ((animatedVal % _fullTurn) + _fullTurn) % _fullTurn;

            // Kaaba angle
            final relativeKaabaRad =
                (qiblaDirection - normalizedHeading) * _degreesToRadians;
            final kaabaDistance = radius * _kaabaRadiusRatio;
            final sinOffset = kaabaDistance * math.sin(relativeKaabaRad);
            final isRtl = Directionality.of(context) == TextDirection.rtl;
            final kaabaX = isRtl ? radius - sinOffset : radius + sinOffset;
            final kaabaY = radius - kaabaDistance * math.cos(relativeKaabaRad);

            return Stack(
              alignment: Alignment.center,
              children: [
                // Dial
                RepaintBoundary(
                  child: CustomPaint(
                    size: Size(diameter, diameter),
                    painter: CompassDialPainter(
                      heading: normalizedHeading,
                      qiblaDirection: qiblaDirection,
                      isFacing: isFacing,
                      activeColor: activeColor,
                      neutralColor: neutralColor,
                      backgroundColor: backgroundColor,
                    ),
                  ),
                ),

                // Kaaba badge — kept visible during skeleton loading
                PositionedDirectional(
                  start: kaabaX - AppSize.qiblaKaabaIconSize * _half,
                  top: kaabaY - AppSize.qiblaKaabaIconSize * _half,
                  child: Skeleton.keep(
                    child: CompassKaabaIcon(isFacing: isFacing),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

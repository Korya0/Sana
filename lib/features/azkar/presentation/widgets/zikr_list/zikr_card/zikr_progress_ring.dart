import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/theme/colors/app_colors_common.dart';

class ZikrProgressRing extends StatelessWidget {
  // Creates ring
  const ZikrProgressRing({
    required this.value,
    required this.color,
    this.strokeCap = StrokeCap.butt,
    super.key,
  });

  final double value;
  final Color color;
  final StrokeCap strokeCap;

  // Builds ring
  @override
  Widget build(BuildContext context) => SizedBox.square(
    dimension: AppSize.h56,
    child: CircularProgressIndicator(
      value: value,
      strokeWidth: AppSize.progressStrokeWidth,
      strokeCap: strokeCap,
      backgroundColor: AppColorsCommon.transparent,
      color: color,
    ),
  );
}

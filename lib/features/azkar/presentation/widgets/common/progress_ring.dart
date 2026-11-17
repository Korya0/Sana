import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/theme/colors/app_colors_common.dart';

class ProgressRing extends StatelessWidget {
  const ProgressRing({
    required this.value,
    required this.color,
    this.strokeCap = StrokeCap.butt,
    this.dimension,
    this.strokeWidth,
    super.key,
  });

  final double value;
  final Color color;
  final StrokeCap strokeCap;
  final double? dimension;
  final double? strokeWidth;

  @override
  Widget build(BuildContext context) => SizedBox.square(
    dimension: dimension ?? AppSize.h56,
    child: CircularProgressIndicator(
      value: value,
      strokeWidth: strokeWidth ?? AppSize.progressStrokeWidth,
      strokeCap: strokeCap,
      backgroundColor: AppColorsCommon.transparent,
      color: color,
    ),
  );
}

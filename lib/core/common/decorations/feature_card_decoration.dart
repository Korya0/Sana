import 'package:flutter/material.dart';
import 'package:sana/core/utils/utils.dart';

BoxDecoration featureCardDecoration({
  required BuildContext context,
  BoxShape shape = BoxShape.rectangle,
  BorderRadiusGeometry? borderRadius,
  Color? color,
  Color? borderColor,
}) {
  return BoxDecoration(
    shape: shape,
    borderRadius: borderRadius,
    color: color ?? context.color.secondaryScaffoldBackgroundColor,
  );
}

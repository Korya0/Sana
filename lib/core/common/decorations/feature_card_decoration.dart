import 'package:flutter/material.dart';
import 'package:sana/core/utils/context_extension.dart';
BoxDecoration featureCardDecoration({
  required BuildContext context,
  BoxShape shape = BoxShape.rectangle,
  BorderRadiusGeometry? borderRadius,
  Color? color,
  Color? borderColor,
}) {
  final bgColor = color ?? context.color.secondaryScaffoldBackgroundColor;
  return BoxDecoration(
    shape: shape,
    borderRadius: borderRadius,
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        bgColor,
        bgColor.withValues(alpha: 0.8),
      ],
    ),
    border: Border.all(
      color: borderColor ?? context.color.primary.withValues(alpha: 0.12),
    ),
  );
}

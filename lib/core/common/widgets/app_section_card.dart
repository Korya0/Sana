import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_spacing.dart';
import 'package:sana/core/utils/utils.dart';

class AppSectionCard extends StatelessWidget {
  const AppSectionCard({
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.v16),
    this.backgroundColor,
    this.borderColor,
    this.shape = BoxShape.rectangle,
    this.expandWidth = true,
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? backgroundColor;
  final Color? borderColor;
  final BoxShape shape;
  final bool expandWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: shape == BoxShape.circle || !expandWidth ? null : double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor ??
            context.color.secondaryScaffoldBackgroundColor.withValues(
              alpha: 0.3,
            ),
        shape: shape,
        borderRadius: shape == BoxShape.circle
            ? null
            : BorderRadius.circular(AppSpacing.radiusL),
        border: Border.all(
          color:
              borderColor ?? context.color.textPrimary.withValues(alpha: 0.1),
        ),
      ),
      child: child,
    );
  }
}

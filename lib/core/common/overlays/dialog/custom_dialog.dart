import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:sana/core/utils/utils.dart';
import 'package:sana/core/common/layout/responsive_wrapper.dart';
import 'package:sana/core/theme/app_spacing.dart';

class CustomDialog extends StatelessWidget {
  const CustomDialog({
    required this.child,
    super.key,
    this.backgroundColor,
    this.borderRadius = AppSpacing.radiusL,
    this.padding = const EdgeInsets.all(AppSpacing.v24),
    this.insetPadding = const EdgeInsets.symmetric(
      horizontal: AppSpacing.v40,
      vertical: AppSpacing.v24,
    ),
    this.useGlassmorphism = false,
    this.borderColor,
    this.borderWidth = 1.0,
    this.showShadow = true,
  });

  final Widget child;
  final Color? backgroundColor;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final EdgeInsets insetPadding;
  final bool useGlassmorphism;
  final Color? borderColor;
  final double borderWidth;
  final bool showShadow;

  @override
  Widget build(BuildContext context) {
    final Widget dialogContent = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: useGlassmorphism
            ? (backgroundColor ??
                      context.color.secondaryScaffoldBackgroundColor)
                  .withValues(
                    alpha: 0.95,
                  )
            : (backgroundColor ??
                  context.color.secondaryScaffoldBackgroundColor),
        borderRadius: BorderRadius.circular(borderRadius),
        border: borderColor != null
            ? Border.all(color: borderColor!, width: borderWidth)
            : null,
        boxShadow: showShadow
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ]
            : null,
      ),
      child: child,
    );

    final Widget dialog = Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: insetPadding,
      child: dialogContent,
    );

    if (useGlassmorphism) {
      return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: dialog,
      );
    }

    return dialog;
  }
}

Future<T?> showCustomDialog<T>({
  required BuildContext context,
  required Widget child,
  Color? backgroundColor,
  double borderRadius = AppSpacing.radiusL,
  EdgeInsetsGeometry padding = const EdgeInsets.all(AppSpacing.v24),
  EdgeInsets insetPadding = const EdgeInsets.symmetric(
    horizontal: AppSpacing.v40,
    vertical: AppSpacing.v24,
  ),
  bool useGlassmorphism = false,
  Color? borderColor,
  double borderWidth = 1.0,
  bool showShadow = true,
  bool barrierDismissible = true,
  Color? barrierColor,
  String? routeName,
}) {
  final effectiveBarrierColor =
      barrierColor ??
      context.color.scaffoldBackgroundColor.withValues(alpha: 0.54);
  return showDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    barrierColor: effectiveBarrierColor,
    routeSettings: routeName != null ? RouteSettings(name: routeName) : null,
    builder: (context) => ResponsiveWrapper(
      child: Material(
        color: Colors.transparent,
        child: CustomDialog(
          backgroundColor: backgroundColor,
          borderRadius: borderRadius,
          padding: padding,
          insetPadding: insetPadding,
          useGlassmorphism: useGlassmorphism,
          borderColor: borderColor,
          borderWidth: borderWidth,
          showShadow: showShadow,
          child: child,
        ),
      ),
    ),
  );
}

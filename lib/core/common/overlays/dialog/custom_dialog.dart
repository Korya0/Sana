/// [CustomDialog]
/// - الوظيفة الأساسية: هذا هو الـ Wrapper أو الحاوية الأساسية لكل الـ Dialogs في التطبيق.
/// - الاستخدام: لا يتم استدعاؤه مباشرة في الشاشات غالباً، بل يتم استدعاؤه بداخل (CustomConfirmationDialog, CustomInfoDialog, CustomRichContentDialog).
/// - مميزاته: يعطي الـ Blur (Glassmorphism effect) والخلفية الموحدة والحدود (Borders) المتوافقة مع Design System الخاص بالتطبيق.
library;

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:sana/core/theme/style/app_colors.dart';

class CustomDialog extends StatelessWidget {
  const CustomDialog({
    required this.child,
    super.key,
    this.backgroundColor,
    this.borderRadius = 16.0,
    this.padding = const EdgeInsets.all(24),
    this.insetPadding = const EdgeInsets.symmetric(
      horizontal: 40,
      vertical: 24,
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
            ? (backgroundColor ?? AppColors.secondaryBackground).withValues(
                alpha: 0.95,
              )
            : (backgroundColor ?? AppColors.secondaryBackground),
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
  double borderRadius = 16.0,
  EdgeInsetsGeometry padding = const EdgeInsets.all(24),
  EdgeInsets insetPadding = const EdgeInsets.symmetric(
    horizontal: 40,
    vertical: 24,
  ),
  bool useGlassmorphism = false,
  Color? borderColor,
  double borderWidth = 1.0,
  bool showShadow = true,
  bool barrierDismissible = true,
  Color? barrierColor = Colors.black54,
}) {
  return showDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    barrierColor: barrierColor,
    builder: (context) => CustomDialog(
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
  );
}

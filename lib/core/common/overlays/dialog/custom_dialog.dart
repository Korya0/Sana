import 'package:flutter/material.dart';
import 'package:sana/core/common/overlays/dialog/app_dialog.dart';

class CustomDialog extends StatelessWidget {
  const CustomDialog({
    required this.child,
    super.key,
    this.backgroundColor,
    this.borderRadius = 16,
    this.padding = const EdgeInsets.all(16),
    this.insetPadding = const EdgeInsets.symmetric(horizontal: 24),
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
    return AppDialog(child: child);
  }
}

Future<T?> showCustomDialog<T>({
  required BuildContext context,
  required Widget child,
  Color? backgroundColor,
  double borderRadius = 16,
  EdgeInsetsGeometry padding = const EdgeInsets.all(16),
  EdgeInsets insetPadding = const EdgeInsets.symmetric(horizontal: 24),
  bool useGlassmorphism = false,
  Color? borderColor,
  double borderWidth = 1.0,
  bool showShadow = true,
  bool barrierDismissible = true,
  Color? barrierColor,
  String? routeName,
}) {
  return AppDialog.show<T>(
    context: context,
    child: child,
    barrierDismissible: barrierDismissible,
  );
}

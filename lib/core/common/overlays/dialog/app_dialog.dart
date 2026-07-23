import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_spacing.dart';
import 'package:sana/core/utils/context_extension.dart';

class AppDialog extends StatelessWidget {
  const AppDialog({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: context.color.secondaryScaffoldBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusL),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.w24),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.v16),
        child: child,
      ),
    );
  }

  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    bool barrierDismissible = true,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) => AppDialog(child: child),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/router/app_navigation_guard.dart';
import 'package:sana/core/utils/context_extension.dart';

class AppBottomSheet {
  const AppBottomSheet._();

  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
  }) {
    final sheet = AppNavigationGuard.runIfIdle(
      () => showModalBottomSheet<T>(
        context: context,
        isScrollControlled: true,
        backgroundColor: context.color.secondaryScaffoldBackgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppSize.r24),
          ),
        ),
        builder: (context) => SafeArea(
          top: false,
          child: child,
        ),
      ),
    );

    return sheet ?? Future<T?>.value();
  }
}

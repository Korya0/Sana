import 'package:flutter/material.dart';
import 'package:sana/core/common/widgets/app_gap.dart';
import 'package:sana/core/theme/app_spacing.dart';
import 'package:sana/core/utils/context_extension.dart';

class AppBottomSheet {
  AppBottomSheet._();

  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    bool isDismissible = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      isDismissible: isDismissible,
      enableDrag: isDismissible,
      backgroundColor: context.color.secondaryScaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacing.radiusXL)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: AppSpacing.v16,
              right: AppSpacing.v16,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const AppGap.h(AppSpacing.v12),
                Container(
                  width: AppSpacing.w40,
                  height: AppSpacing.v4,
                  decoration: BoxDecoration(
                    color: context.color.textSecondary.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusXL),
                  ),
                ),
                const AppGap.h(AppSpacing.v24),
                child,
                const AppGap.h(AppSpacing.v48),
              ],
            ),
          ),
        );
      },
    );
  }
}

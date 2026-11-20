import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/theme/colors/app_colors_common.dart';
import 'package:sana/core/utils/context_extension.dart';

class AppBottomSheet {
  const AppBottomSheet._();

  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    bool isDismissible = true,
    bool enableDrag = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      // Keep the route surface transparent and paint the real color inside
      // the builder. A color passed here is captured when the sheet opens, so
      // an open sheet would keep the old theme after a live theme switch.
      backgroundColor: AppColorsCommon.transparent,
      builder: (context) => Material(
        color: context.color.secondaryScaffoldBackgroundColor,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppSize.r24),
          ),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            // Form sheets already add the keyboard inset; keep only a small
            // breathing space then so the sheet cannot overflow the viewport.
            padding: EdgeInsets.only(
              bottom: AppSize.keyboardHeight(context) > 0
                  ? AppSize.p4
                  : AppSize.sbp,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Drag handle
                Padding(
                  padding: EdgeInsets.only(top: AppSize.p8),
                  child: Container(
                    width: AppSize.w48,
                    height: AppSize.p4,
                    decoration: BoxDecoration(
                      color: context.color.dividerColor,
                      borderRadius: BorderRadius.circular(
                        AppSize.circularRadius,
                      ),
                    ),
                  ),
                ),
                child,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

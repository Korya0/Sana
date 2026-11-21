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
      builder: (context) {
        // Cap the whole sheet to the viewport so an arbitrary `child` can
        // never push the modal past the screen. Keyboard inset handling stays
        // exactly as before (the framework pads an isScrollControlled route).
        return ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: AppSize.maxSheetHeight(context),
          ),
          child: Material(
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
                // The sheet keeps a fixed height; its body scrolls internally.
                padding: EdgeInsets.only(bottom: AppSize.sbp),
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
                    Flexible(
                      fit: FlexFit.loose,
                      child: SingleChildScrollView(child: child),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

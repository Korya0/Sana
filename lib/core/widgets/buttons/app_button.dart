import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/utils/context_extension.dart';
import 'package:sana/core/widgets/app_gap.dart';
import 'package:sana/core/widgets/interaction/app_pressable.dart';

enum AppButtonVariant { primary, secondary }

class AppButton extends StatelessWidget {
  const AppButton({
    required this.label,
    required this.onPressed,
    super.key,
    this.variant = AppButtonVariant.primary,
    this.expand = false,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final bool expand;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final height = AppSize.h48 < AppConstants.minTapTarget
        ? AppConstants.minTapTarget
        : AppSize.h48;
    final enabled = onPressed != null;
    final isPrimary = variant == AppButtonVariant.primary;

    final decoration = isPrimary
        ? BoxDecoration(
            color: context.color.actionPrimary,
            borderRadius: BorderRadius.circular(AppSize.r16),
          )
        : BoxDecoration(
            borderRadius: BorderRadius.circular(AppSize.r16),
            border: Border.all(
              color: context.color.actionPrimary,
              width: AppSize.borderWidth,
            ),
          );

    final foregroundColor = isPrimary
        ? context.color.iconOnPrimary
        : context.color.iconBrand;

    return Opacity(
      opacity: enabled
          ? AppConstants.opacityFull
          : AppConstants.opacityDisabled,
      // Buttons fade as one control: fill, border and label dim together.
      child: AppPressable(
        onPressed: onPressed,
        child: Container(
          width: expand ? double.infinity : null,
          height: height,
          decoration: decoration,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSize.p16),
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Icon
                  if (icon != null) ...[
                    Icon(icon, size: AppSize.icon16, color: foregroundColor),
                    AppGap.w(AppSize.p8),
                  ],

                  // Label
                  Flexible(
                    child: Text(
                      label,
                      maxLines: AppConstants.maxOneLine,
                      overflow: TextOverflow.ellipsis,
                      style: isPrimary
                          ? AppTextStyles.font14W700OnPrimary(context)
                          : AppTextStyles.font14W700Brand(context),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

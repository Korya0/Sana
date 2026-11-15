import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/colors/app_colors_common.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/icons/app_icons.dart';
import 'package:sana/core/utils/context_extension.dart';
import 'package:sana/core/widgets/app_gap.dart';
import 'package:sana/core/widgets/buttons/app_secondary_button.dart';
import 'package:sana/core/widgets/interaction/app_pressable.dart';

enum ZikrOptionAction { resetCounter, editTarget, delete }

class ZikrOptionsBottomSheet extends StatelessWidget {
  const ZikrOptionsBottomSheet({
    super.key,
    this.canReset = true,
    this.canDelete = false,
  });

  final bool canReset;
  final bool canDelete;

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.symmetric(
      horizontal: AppSize.p20,
      vertical: AppSize.p16,
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Title
        Text(
          AppStrings.zikrOptionsTitle,
          maxLines: AppConstants.maxOneLine,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: AppTextStyles.font16W700Primary(context),
        ),
        AppGap.h(AppSize.p20),

        // Reset counter button
        Opacity(
          opacity: canReset
              ? AppConstants.opacityFull
              : AppConstants.opacityDisabled,
          child: AppPressable(
            onPressed: canReset
                ? () => Navigator.of(context).pop(ZikrOptionAction.resetCounter)
                : null,
            child: Container(
              height: AppSize.h48,
              padding: EdgeInsets.symmetric(horizontal: AppSize.p16),
              decoration: BoxDecoration(
                color: context.color.secondaryScaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(AppSize.r16),
                border: Border.all(
                  color: context.color.dividerColor,
                  width: AppSize.borderWidth,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    AppIcons.refresh,
                    size: AppSize.icon24,
                    color: canReset
                        ? context.color.iconBrand
                        : context.color.iconDisabled,
                  ),
                  AppGap.w(AppSize.p12),
                  Expanded(
                    child: Text(
                      AppStrings.resetCounter,
                      style: canReset
                          ? AppTextStyles.font14W700Primary(context)
                          : AppTextStyles.font14W700Secondary(context),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        AppGap.h(AppSize.p12),

        // Edit target count button
        AppPressable(
          onPressed: () =>
              Navigator.of(context).pop(ZikrOptionAction.editTarget),
          child: Container(
            height: AppSize.h48,
            padding: EdgeInsets.symmetric(horizontal: AppSize.p16),
            decoration: BoxDecoration(
              color: context.color.secondaryScaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(AppSize.r16),
              border: Border.all(
                color: context.color.dividerColor,
                width: AppSize.borderWidth,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  AppIcons.edit,
                  size: AppSize.icon24,
                  color: context.color.iconBrand,
                ),
                AppGap.w(AppSize.p12),
                Expanded(
                  child: Text(
                    AppStrings.editTargetCount,
                    style: AppTextStyles.font14W700Primary(context),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (canDelete) ...[
          AppGap.h(AppSize.p12),
          AppPressable(
            onPressed: () =>
                Navigator.of(context).pop(ZikrOptionAction.delete),
            child: Container(
              height: AppSize.h48,
              padding: EdgeInsets.symmetric(horizontal: AppSize.p16),
              decoration: BoxDecoration(
                color: context.color.secondaryScaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(AppSize.r16),
                border: Border.all(
                  color: AppColorsCommon.errorColor.withValues(
                    alpha: AppConstants.opacityMuted,
                  ),
                  width: AppSize.borderWidth,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    AppIcons.delete,
                    size: AppSize.icon24,
                    color: AppColorsCommon.errorColor,
                  ),
                  AppGap.w(AppSize.p12),
                  Expanded(
                    child: Text(
                      AppStrings.deleteZikr,
                      style: AppTextStyles.font14W700Primary(context).copyWith(
                        color: AppColorsCommon.errorColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
        AppGap.h(AppSize.p12),

        // Cancel
        AppSecondaryButton(
          label: AppStrings.cancel,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    ),
  );
}

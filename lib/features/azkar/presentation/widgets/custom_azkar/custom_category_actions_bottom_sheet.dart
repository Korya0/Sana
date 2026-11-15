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

enum CustomCategoryAction { edit, delete, reset }

class CustomCategoryActionsBottomSheet extends StatelessWidget {
  const CustomCategoryActionsBottomSheet({
    required this.title,
    super.key,
    this.isBuiltIn = false,
  });

  final String title;
  final bool isBuiltIn;

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
          title,
          maxLines: AppConstants.maxOneLine,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: AppTextStyles.font16W700Primary(context),
        ),
        AppGap.h(AppSize.p20),

        // Edit button (only for user-created custom categories)
        if (!isBuiltIn) ...[
          AppPressable(
            onPressed: () =>
                Navigator.of(context).pop(CustomCategoryAction.edit),
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
                      AppStrings.editCustomZikr,
                      style: AppTextStyles.font14W700Primary(context),
                    ),
                  ),
                ],
              ),
            ),
          ),
          AppGap.h(AppSize.p12),
        ],

        // Delete or Reset button
        if (isBuiltIn)
          AppPressable(
            onPressed: () =>
                Navigator.of(context).pop(CustomCategoryAction.reset),
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
                    color: context.color.iconPrimary,
                  ),
                  AppGap.w(AppSize.p12),
                  Expanded(
                    child: Text(
                      AppStrings.resetCategoryToDefault,
                      style: AppTextStyles.font14W700Primary(context),
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          AppPressable(
            onPressed: () =>
                Navigator.of(context).pop(CustomCategoryAction.delete),
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
                      AppStrings.deleteCustomZikrDialogTitle,
                      style: AppTextStyles.font14W700Primary(
                        context,
                      ).copyWith(color: AppColorsCommon.errorColor),
                    ),
                  ),
                ],
              ),
            ),
          ),
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

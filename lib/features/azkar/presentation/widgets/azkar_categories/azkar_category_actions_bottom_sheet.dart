import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/icons/app_icons.dart';
import 'package:sana/core/utils/context_extension.dart';
import 'package:sana/core/widgets/app_gap.dart';
import 'package:sana/core/widgets/buttons/app_text_button.dart';
import 'package:sana/core/widgets/dividers/custom_app_divider.dart';
import 'package:sana/features/azkar/presentation/widgets/common/azkar_option_section.dart';
import 'package:sana/features/azkar/presentation/widgets/common/azkar_option_tile.dart';

enum AzkarCategoryAction { fontSize, edit, restore, delete }

class AzkarCategoryActionsBottomSheet extends StatelessWidget {
  // Creates sheet
  const AzkarCategoryActionsBottomSheet({
    required this.isCustom,
    super.key,
    this.canRestore = false,
  });

  final bool isCustom;
  final bool canRestore;

  // Builds sheet
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
        // Reading settings
        AzkarOptionSection(
          title: AppStrings.readingSettingsTitle,
          children: [
            AzkarOptionTile(
              icon: AppIcons.fontSize,
              label: AppStrings.fontSize,
              onPressed: () => context.popOnce(AzkarCategoryAction.fontSize),
            ),
          ],
        ),
        AppGap.h(AppSize.p16),

        // Separator
        const CustomAppDivider(),
        AppGap.h(AppSize.p16),

        // Actions section
        AzkarOptionSection(
          title: AppStrings.azkarOptions,
          children: [
            // Edit action
            AzkarOptionTile(
              icon: AppIcons.edit,
              label: AppStrings.editAzkar,
              onPressed: () => context.popOnce(AzkarCategoryAction.edit),
            ),
            AppGap.h(AppSize.p8),

            // Secondary actions
            Row(
              children: [
                // Restore action
                Expanded(
                  child: AppTextButton(
                    label: AppStrings.restoreOriginal,
                    expand: true,
                    onPressed: canRestore
                        ? () => context.popOnce(AzkarCategoryAction.restore)
                        : null,
                  ),
                ),
                AppGap.w(AppSize.p8),

                // Delete action
                Expanded(
                  child: AppTextButton(
                    label: AppStrings.delete,
                    expand: true,
                    textStyle: AppTextStyles.font14W700Error(context),
                    onPressed: isCustom
                        ? () => context.popOnce(AzkarCategoryAction.delete)
                        : null,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  );
}

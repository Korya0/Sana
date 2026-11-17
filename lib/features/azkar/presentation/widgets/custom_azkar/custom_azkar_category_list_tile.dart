import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/icons/app_icons.dart';
import 'package:sana/core/utils/context_extension.dart';
import 'package:sana/core/widgets/app_gap.dart';
import 'package:sana/core/widgets/buttons/app_icon_button.dart';
import 'package:sana/core/widgets/cards/app_section_card.dart';
import 'package:sana/features/azkar/domain/entities/custom_category_entity.dart';

class CustomAzkarCategoryListTile extends StatelessWidget {
  // Creates tile
  const CustomAzkarCategoryListTile({
    required this.category,
    required this.isBuiltIn,
    required this.onEdit,
    required this.onDelete,
    required this.onRestore,
    super.key,
  });

  final CustomCategoryEntity category;
  final bool isBuiltIn;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onRestore;

  // Builds tile
  @override
  Widget build(BuildContext context) => AppSectionCard(
    padding: EdgeInsets.zero,
    child: Padding(
      padding: EdgeInsets.all(AppSize.p16),
      child: Row(
        children: [
          // Icon
          Container(
            width: AppSize.w40,
            height: AppSize.h40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: context.color.primary.withValues(
                alpha: AppConstants.opacitySubtle,
              ),
              border: Border.all(
                color: context.color.borderBrand.withValues(
                  alpha: AppConstants.opacityMuted,
                ),
                width: AppSize.borderWidth,
              ),
            ),
            child: Center(
              child: Icon(
                AppIcons.adhkar,
                size: AppSize.icon24,
                color: context.color.iconBrand,
              ),
            ),
          ),
          AppGap.w(AppSize.p12),

          // Info (name + count)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name
                Text(
                  category.name,
                  maxLines: AppConstants.maxOneLine,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.font16W700Primary(context),
                ),
                AppGap.h(AppSize.p4),
                // Count
                Text(
                  AppStrings.azkarCountLabel(category.azkar.length),
                  maxLines: AppConstants.maxOneLine,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.font12W500Secondary(context),
                ),
              ],
            ),
          ),
          AppGap.w(AppSize.p8),

          // Edit action
          AppIconButton(
            icon: AppIcons.edit,
            tooltip: AppStrings.editAzkar,
            onPressed: onEdit,
          ),

          // Remove action
          if (isBuiltIn)
            AppIconButton(
              icon: AppIcons.refresh,
              tooltip: AppStrings.restoreOriginal,
              onPressed: onRestore,
            )
          else
            AppIconButton(
              icon: AppIcons.delete,
              color: context.color.errorText,
              tooltip: AppStrings.deleteCustomAzkarDialogTitle,
              onPressed: onDelete,
            ),
        ],
      ),
    ),
  );
}

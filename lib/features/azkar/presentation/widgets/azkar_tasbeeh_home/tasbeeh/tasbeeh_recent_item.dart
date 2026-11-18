import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/icons/app_icons.dart';
import 'package:sana/core/utils/context_extension.dart';
import 'package:sana/core/widgets/app_gap.dart';
import 'package:sana/core/widgets/buttons/app_button.dart';
import 'package:sana/core/widgets/interaction/app_pressable.dart';
import 'package:sana/features/azkar/domain/entities/tasbeeh_item_entity.dart';
import 'package:sana/features/azkar/presentation/widgets/common/tasbeeh_counter_widgets.dart';

class TasbeehRecentItem extends StatelessWidget {
  const TasbeehRecentItem({
    required this.item,
    required this.onContinue,
    required this.onOpenAll,
    super.key,
  });

  final TasbeehItemEntity item;
  final VoidCallback onContinue;
  final VoidCallback onOpenAll;

  @override
  Widget build(BuildContext context) {
    final borderBrandColor = context.color.borderBrand.withValues(
      alpha: AppConstants.opacitySubtle,
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Mihrab Arch Crown & Dial
        Center(
          child: AppPressable(
            onPressed: onContinue,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Outer decorative halo circle
                Container(
                  width: AppSize.h100,
                  height: AppSize.h100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: borderBrandColor,
                      width: AppSize.borderWidth,
                    ),
                    color: context.color.surfaceSelected.withValues(
                      alpha: AppConstants.opacitySubtle * 0.5,
                    ),
                  ),
                ),
                // Circular Counter
                TasbeehCounter(
                  currentCount: item.currentCount,
                  targetCount: item.targetCount,
                  dimension: AppSize.h64 * 1.3,
                  strokeWidth: AppSize.progressStrokeWidthLarge,
                  numberStyle: AppTextStyles.font24W700Brand(context),
                ),
              ],
            ),
          ),
        ),
        AppGap.h(AppSize.p12),

        // Dhikr Title
        AppPressable(
          onPressed: onContinue,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSize.p8),
            child: Text(
              item.text,
              maxLines: AppConstants.maxTwoLines,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: AppTextStyles.font16W700Primary(context),
            ),
          ),
        ),
        AppGap.h(AppSize.p16),

        // Actions
        Row(
          children: [
            Expanded(
              child: AppButton(
                icon: AppIcons.play,
                label: AppStrings.continueTasbeeh,
                onPressed: onContinue,
                expand: true,
              ),
            ),
            AppGap.w(AppSize.p8),
            Expanded(
              child: AppButton(
                icon: AppIcons.list,
                label: AppStrings.allTasbeeh,
                onPressed: onOpenAll,
                variant: AppButtonVariant.secondary,
                expand: true,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

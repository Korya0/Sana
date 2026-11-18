import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/icons/app_icons.dart';
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
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      // Info (counter + title)
      AppPressable(
        onPressed: onContinue,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: AppSize.p8),
          child: Row(
            children: [
              // Counter
              TasbeehCounter(
                currentCount: item.currentCount,
                targetCount: item.targetCount,
                dimension: AppSize.h64,
                strokeWidth: AppSize.progressStrokeWidthLarge,
                numberStyle: AppTextStyles.font20W700Brand(context),
              ),
              AppGap.w(AppSize.p12),

              // Title
              Expanded(
                child: Text(
                  item.text,
                  maxLines: AppConstants.maxTwoLines,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.start,
                  style: AppTextStyles.font16W700Primary(context),
                ),
              ),
            ],
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

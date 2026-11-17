import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/icons/app_icons.dart';
import 'package:sana/core/widgets/app_gap.dart';
import 'package:sana/core/widgets/interaction/app_pressable.dart';
import 'package:sana/features/azkar/domain/entities/tasbeeh_item_entity.dart';
import 'package:sana/features/azkar/presentation/widgets/azkar_tasbeeh_home/tasbeeh/tasbeeh_action_button.dart';
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
      AppPressable(
        onPressed: onContinue,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: AppSize.p8),
          child: Row(
            children: [
              TasbeehCounter(
                currentCount: item.currentCount,
                targetCount: item.targetCount,
                dimension: AppSize.h48,
                strokeWidth: AppSize.progressStrokeWidth,
                numberStyle: AppTextStyles.font14W700Brand(context),
              ),
              AppGap.w(AppSize.p12),
              Expanded(
                child: Text(
                  item.text,
                  maxLines: AppConstants.maxTwoLines,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.start,
                  style: AppTextStyles.font14W700Primary(context),
                ),
              ),
            ],
          ),
        ),
      ),
      AppGap.h(AppSize.p12),
      Row(
        children: [
          Expanded(
            child: TasbeehActionButton(
              label: AppStrings.continueTasbeeh,
              icon: AppIcons.next,
              onPressed: onContinue,
            ),
          ),
          AppGap.w(AppSize.p8),
          Expanded(
            child: TasbeehActionButton(
              label: AppStrings.allTasbeeh,
              icon: AppIcons.list,
              onPressed: onOpenAll,
            ),
          ),
        ],
      ),
    ],
  );
}

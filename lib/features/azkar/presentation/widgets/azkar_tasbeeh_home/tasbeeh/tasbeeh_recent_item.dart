import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/icons/app_icons.dart';
import 'package:sana/core/widgets/app_gap.dart';
import 'package:sana/core/widgets/buttons/app_button.dart';
import 'package:sana/features/azkar/domain/entities/tasbeeh_item_entity.dart';
import 'package:sana/features/azkar/presentation/widgets/common/tasbeeh_bead_counter.dart';

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
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      // Bead gauge
      TasbeehBeadCounter(
        count: item.currentCount,
        subtitle: item.text,
        progress: item.progress,
        onPressed: onContinue,
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

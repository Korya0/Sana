import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/icons/app_icons.dart';
import 'package:sana/core/widgets/app_gap.dart';
import 'package:sana/core/widgets/buttons/app_button.dart';
import 'package:sana/features/azkar/presentation/widgets/common/tasbeeh_bead_counter.dart';

class TasbeehPresetGrid extends StatelessWidget {
  const TasbeehPresetGrid({
    required this.onSelect,
    required this.onCustomTap,
    super.key,
  });

  final ValueChanged<String> onSelect;
  final VoidCallback onCustomTap;

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      // Start gauge
      const TasbeehBeadCounter(
        count: 0,
        subtitle: AppStrings.chooseTasbeehToStart,
        progress: AppConstants.progressStart,
        showCount: false,
      ),
      AppGap.h(AppSize.p16),

      // Actions
      Row(
        children: [
          Expanded(
            child: AppButton(
              icon: AppIcons.play,
              label: AppStrings.tasbeehPresetIstighfar,
              onPressed: () => onSelect(AppStrings.tasbeehPresetIstighfar),
              expand: true,
            ),
          ),
          AppGap.w(AppSize.p8),
          Expanded(
            child: AppButton(
              icon: AppIcons.add,
              label: AppStrings.customTasbeeh,
              onPressed: onCustomTap,
              variant: AppButtonVariant.secondary,
              expand: true,
            ),
          ),
        ],
      ),
    ],
  );
}

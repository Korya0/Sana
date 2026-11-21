import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/icons/app_icons.dart';
import 'package:sana/core/widgets/app_gap.dart';
import 'package:sana/features/azkar/presentation/widgets/common/tasbeeh_bead_counter.dart';
import 'package:sana/features/azkar/presentation/widgets/common/tasbeeh_chip.dart';

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
      // Start gauge — the prompt itself is the custom-tasbeeh action.
      TasbeehBeadCounter(
        count: 0,
        subtitle: AppStrings.chooseOrAddCustomTasbeeh,
        progress: AppConstants.progressStart,
        showCount: false,
        onSubtitleTap: onCustomTap,
        subtitleIcon: AppIcons.add,
      ),

      // Presets
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: TasbeehChip(
              label: AppStrings.tasbeehPresetAlhamdulillah,
              onPressed: () => onSelect(AppStrings.tasbeehPresetAlhamdulillah),
            ),
          ),
          AppGap.w(AppSize.p8),
          Expanded(
            child: TasbeehChip(
              label: AppStrings.tasbeehPresetIstighfar,
              onPressed: () => onSelect(AppStrings.tasbeehPresetIstighfar),
            ),
          ),
          AppGap.w(AppSize.p8),
          Expanded(
            child: TasbeehChip(
              label: AppStrings.tasbeehPresetSubhanAllah,
              onPressed: () => onSelect(AppStrings.tasbeehPresetSubhanAllah),
            ),
          ),
        ],
      ),
    ],
  );
}

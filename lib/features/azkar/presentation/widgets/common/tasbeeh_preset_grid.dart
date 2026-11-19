import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/icons/app_icons.dart';
import 'package:sana/core/utils/context_extension.dart';
import 'package:sana/core/widgets/app_gap.dart';
import 'package:sana/core/widgets/interaction/app_pressable.dart';
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
          Flexible(
            child: _PresetChip(
              label: AppStrings.tasbeehPresetIstighfar,
              onPressed: () => onSelect(AppStrings.tasbeehPresetIstighfar),
            ),
          ),
          AppGap.w(AppSize.p8),
          Flexible(
            child: _PresetChip(
              label: AppStrings.tasbeehPresetAlhamdulillah,
              onPressed: () => onSelect(AppStrings.tasbeehPresetAlhamdulillah),
            ),
          ),
          AppGap.w(AppSize.p8),
          Flexible(
            child: _PresetChip(
              label: AppStrings.tasbeehPresetSubhanAllah,
              onPressed: () => onSelect(AppStrings.tasbeehPresetSubhanAllah),
            ),
          ),
        ],
      ),
    ],
  );
}

class _PresetChip extends StatelessWidget {
  const _PresetChip({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => AppPressable(
    onPressed: onPressed,
    child: Container(
      height: AppSize.h40,
      padding: EdgeInsets.symmetric(horizontal: AppSize.p8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSize.r12),
        border: Border.all(
          color: context.color.dividerColor,
          width: AppSize.borderWidth,
        ),
      ),
      child: Center(
        child: Text(
          label,
          maxLines: AppConstants.maxOneLine,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.font12W700Brand(context),
        ),
      ),
    ),
  );
}

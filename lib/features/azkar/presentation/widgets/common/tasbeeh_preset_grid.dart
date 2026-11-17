import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/icons/app_icons.dart';
import 'package:sana/core/utils/context_extension.dart';
import 'package:sana/core/widgets/app_gap.dart';
import 'package:sana/core/widgets/interaction/app_pressable.dart';

class TasbeehPresetGrid extends StatelessWidget {
  const TasbeehPresetGrid({
    required this.onSelect,
    required this.onCustomTap,
    super.key,
  });

  static const _presetIcons = <IconData>[
    AppIcons.tasbih,
    AppIcons.sparkle,
    AppIcons.repentance,
  ];

  final ValueChanged<String> onSelect;
  final VoidCallback onCustomTap;

  @override
  Widget build(BuildContext context) {
    const presets = AppStrings.tasbeehPresets;
    final items = <({String label, IconData icon, bool isCustom, VoidCallback onTap})>[
      for (var i = 0; i < presets.length; i++)
        (
          label: presets[i],
          icon: _presetIcons[i],
          isCustom: false,
          onTap: () => onSelect(presets[i]),
        ),
      (
        label: AppStrings.customTasbeeh,
        icon: AppIcons.add,
        isCustom: true,
        onTap: onCustomTap,
      ),
    ];

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < items.length; i++) ...[
          Expanded(
            child: _TasbeehQuickCard(
              label: items[i].label,
              icon: items[i].icon,
              isCustom: items[i].isCustom,
              onTap: items[i].onTap,
            ),
          ),
          if (i != items.length - 1) AppGap.w(AppSize.p8),
        ],
      ],
    );
  }
}

class _TasbeehQuickCard extends StatelessWidget {
  const _TasbeehQuickCard({
    required this.label,
    required this.icon,
    required this.isCustom,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool isCustom;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => AppPressable(
    onPressed: onTap,
    semanticLabel: label,
    excludeChildSemantics: true,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: AppSize.w48,
          height: AppSize.h48,
          decoration: BoxDecoration(
            color: isCustom
                ? context.color.secondaryScaffoldBackgroundColor
                : context.color.surfaceSelected,
            shape: BoxShape.circle,
            border: isCustom
                ? Border.all(
                    color: context.color.dividerColor,
                    width: AppSize.borderWidth,
                  )
                : null,
          ),
          child: Center(
            child: Icon(
              icon,
              size: AppSize.icon24,
              color: isCustom
                  ? context.color.iconSecondary
                  : context.color.iconPrimary,
            ),
          ),
        ),
        AppGap.h(AppSize.p8),
        Text(
          label,
          maxLines: AppConstants.maxTwoLines,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: AppTextStyles.font12W700Primary(context),
        ),
      ],
    ),
  );
}

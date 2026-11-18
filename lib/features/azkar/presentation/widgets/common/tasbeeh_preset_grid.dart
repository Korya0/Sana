import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/icons/app_icons.dart';
import 'package:sana/core/utils/context_extension.dart';
import 'package:sana/core/widgets/app_gap.dart';
import 'package:sana/core/widgets/interaction/app_pressable.dart';
import 'package:sana/core/widgets/text/app_marquee_text.dart';

class TasbeehPresetGrid extends StatelessWidget {
  const TasbeehPresetGrid({
    required this.onSelect,
    required this.onCustomTap,
    super.key,
  });

  static const _presetIcons = <IconData>[
    AppIcons.tasbih,
    AppIcons.repentance,
  ];

  final ValueChanged<String> onSelect;
  final VoidCallback onCustomTap;

  @override
  Widget build(BuildContext context) {
    const presets = AppStrings.tasbeehPresets;
    final items =
        <({String label, IconData icon, bool isCustom, VoidCallback onTap})>[
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

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Mihrab Arch Crest
        Container(
          width: AppSize.w48,
          height: AppSize.h48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: context.color.surfaceSelected,
            border: Border.all(
              color: context.color.borderBrand.withValues(
                alpha: AppConstants.opacitySubtle,
              ),
              width: AppSize.borderWidth,
            ),
          ),
          child: Center(
            child: Icon(
              AppIcons.tasbih,
              size: AppSize.icon24,
              color: context.color.primary,
            ),
          ),
        ),
        AppGap.h(AppSize.p8),

        // Subtitle Header
        Text(
          AppStrings.chooseTasbeehToStart,
          style: AppTextStyles.font14W700Primary(context),
        ),
        AppGap.h(AppSize.p16),

        // Presets & Custom List / Grid
        Row(
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
        ),
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
    child: Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSize.p4,
        vertical: AppSize.p8,
      ),
      decoration: BoxDecoration(
        color: isCustom
            ? context.color.surfaceSelected.withValues(
                alpha: AppConstants.opacitySubtle * 0.5,
              )
            : context.color.secondaryScaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(AppSize.r16),
        border: Border.all(
          color: isCustom
              ? context.color.primary.withValues(
                  alpha: AppConstants.opacitySubtle,
                )
              : context.color.dividerColor,
          width: AppSize.borderWidth,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: AppSize.w40,
            height: AppSize.h40,
            decoration: BoxDecoration(
              color: isCustom
                  ? context.color.surfaceBrand.withValues(
                      alpha: AppConstants.opacitySubtle,
                    )
                  : context.color.surfaceSelected,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                icon,
                size: AppSize.icon24,
                color: isCustom
                    ? context.color.primary
                    : context.color.iconPrimary,
              ),
            ),
          ),
          AppGap.h(AppSize.p8),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSize.p4),
            child: AppMarqueeText(
              text: label,
              style: isCustom
                  ? AppTextStyles.font12W700Brand(context)
                  : AppTextStyles.font12W700Primary(context),
            ),
          ),
        ],
      ),
    ),
  );
}

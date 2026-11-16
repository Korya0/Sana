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
  // Creates grid
  const TasbeehPresetGrid({
    required this.onSelect,
    required this.onCustomPressed,
    super.key,
  });

  final ValueChanged<String> onSelect;
  final VoidCallback onCustomPressed;

  // Builds grid
  @override
  Widget build(BuildContext context) {
    final items = <({String label, VoidCallback onTap})>[
      for (final text in AppStrings.tasbeehPresets)
        (label: text, onTap: () => onSelect(text)),
      (label: AppStrings.customTasbeeh, onTap: onCustomPressed),
    ];

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < items.length; i++) ...[
          Expanded(
            child: _TasbeehQuickCard(
              label: items[i].label,
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
  // Creates card
  const _TasbeehQuickCard({
    required this.label,
    required this.onTap,
  });

  final String label;
  final VoidCallback onTap;

  // Builds card
  @override
  Widget build(BuildContext context) => Stack(
    alignment: Alignment.topCenter,
    children: [
      // Surface
      SizedBox(
        width: AppSize.w48,
        height: AppSize.h48,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: context.color.secondaryScaffoldBackgroundColor,
            shape: BoxShape.circle,
            border: Border.all(
              color: context.color.borderBrand.withValues(
                alpha: AppConstants.opacitySubtle,
              ),
              width: AppSize.borderWidth,
            ),
          ),
        ),
      ),

      // Content (icon + title)
      AppPressable(
        onPressed: onTap,
        semanticLabel: label,
        excludeChildSemantics: true,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            SizedBox(
              width: AppSize.w48,
              height: AppSize.h48,
              child: Center(
                child: Icon(
                  AppIcons.add,
                  size: AppSize.icon32,
                  color: context.color.iconPrimary,
                ),
              ),
            ),
            AppGap.h(AppSize.p8),

            // Title
            AppMarqueeText(
              text: label,
              style: AppTextStyles.font11W700Primary(context),
            ),
          ],
        ),
      ),
    ],
  );
}

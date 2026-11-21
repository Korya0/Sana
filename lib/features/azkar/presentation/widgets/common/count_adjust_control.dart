import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/icons/app_icons.dart';
import 'package:sana/core/utils/context_extension.dart';
import 'package:sana/core/widgets/buttons/app_icon_button.dart';
import 'package:sana/core/widgets/interaction/app_pressable.dart';

class CountAdjustControl extends StatelessWidget {
  const CountAdjustControl({
    required this.canAdjust,
    required this.onDecrement,
    required this.onReset,
    super.key,
  });

  final bool canAdjust;
  final VoidCallback onDecrement;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      // Minus one
      AppIconButton(
        icon: AppIcons.minus,
        size: AppSize.icon24,
        tooltip: AppStrings.decrementOne,
        color: canAdjust
            ? context.color.iconNeutral
            : context.color.iconDisabled,
        onPressed: canAdjust ? onDecrement : null,
      ),

      // Full reset — refresh icon with a small zero badge
      AppPressable(
        key: const ValueKey('count_reset_button'),
        semanticLabel: AppStrings.resetCounter,
        onPressed: canAdjust ? onReset : null,
        child: Opacity(
          opacity: canAdjust
              ? AppConstants.opacityFull
              : AppConstants.opacityDisabled,
          child: SizedBox(
            width: AppSize.w48,
            height: AppSize.w48,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Icon(
                  AppIcons.refresh,
                  size: AppSize.icon24,
                  color: context.color.iconNeutral,
                ),
                PositionedDirectional(
                  end: AppSize.p8,
                  bottom: AppSize.p8,
                  child: Text(
                    '0',
                    style: AppTextStyles.font11W700Primary(context),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ],
  );
}

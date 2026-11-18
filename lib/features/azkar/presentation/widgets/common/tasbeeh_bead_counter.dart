import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/utils/context_extension.dart';
import 'package:sana/core/widgets/app_gap.dart';
import 'package:sana/core/widgets/interaction/app_pressable.dart';
import 'package:sana/features/azkar/presentation/widgets/common/tasbeeh_bead_arc.dart';

class TasbeehBeadCounter extends StatelessWidget {
  const TasbeehBeadCounter({
    required this.count,
    required this.subtitle,
    required this.progress,
    required this.onPressed,
    super.key,
    this.isFreeMode = false,
  });

  final String count;
  final String subtitle;
  final double progress;
  final bool isFreeMode;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => AppPressable(
    onPressed: onPressed,
    tapCooldown: AppConstants.tapCooldown120ms,
    child: SizedBox(
      height: AppSize.h135,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          // Bead gauge
          Positioned.fill(
            child: TasbeehBeadArc(
              progress: progress,
              isFreeMode: isFreeMode,
              activeColor: context.color.primary,
              inactiveColor: context.color.borderBrand.withValues(
                alpha: AppConstants.opacitySubtle,
              ),
            ),
          ),

          // Count
          PositionedDirectional(
            start: AppSize.p16,
            end: AppSize.p16,
            bottom: AppSize.p8,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  count,
                  style: AppTextStyles.font24W700Brand(context),
                ),
                AppGap.h(AppSize.p4),
                Text(
                  subtitle,
                  maxLines: AppConstants.maxOneLine,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.font14W500Secondary(context),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

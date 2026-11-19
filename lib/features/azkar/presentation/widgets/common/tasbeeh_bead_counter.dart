import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/icons/app_icons.dart';
import 'package:sana/core/utils/context_extension.dart';
import 'package:sana/core/widgets/app_gap.dart';
import 'package:sana/core/widgets/buttons/app_text_button.dart';
import 'package:sana/core/widgets/interaction/app_pressable.dart';
import 'package:sana/features/azkar/presentation/widgets/common/tasbeeh_bead_arc.dart';

class TasbeehBeadCounter extends StatelessWidget {
  const TasbeehBeadCounter({
    required this.count,
    required this.subtitle,
    required this.progress,
    super.key,
    this.onPressed,
    this.subtitleMaxLines = AppConstants.maxOneLine,
    this.contentTop,
    this.contentBottom,
    this.showTouchCue = false,
    this.showCount = true,
    this.onSubtitleTap,
    this.subtitleIcon,
  });

  final int count;
  final String subtitle;
  final double progress;
  final VoidCallback? onPressed;
  final int subtitleMaxLines;
  final double? contentTop;
  final double? contentBottom;
  final bool showTouchCue;
  final bool showCount;
  final VoidCallback? onSubtitleTap;
  final IconData? subtitleIcon;

  @override
  Widget build(BuildContext context) {
    final gauge = SizedBox(
      height: AppSize.h135,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          // Bead gauge — narrowed by 10 logical pixels total, height untouched.
          Positioned.fill(
            left: AppConstants.beadArcWidthInset,
            right: AppConstants.beadArcWidthInset,
            child: TasbeehBeadArc(
              progress: progress,
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
            top: contentTop,
            bottom: showCount
                ? (contentTop == null ? (contentBottom ?? AppSize.p8) : null)
                : (contentBottom ?? AppSize.p20),
            child: Stack(
              alignment: Alignment.center,
              children: [
                if (showTouchCue)
                  Icon(
                    AppIcons.fingerprint,
                    size: AppSize.h100,
                    color: context.color.primary.withValues(
                      alpha: AppConstants.opacityGhost,
                    ),
                  ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (showCount) ...[
                      _CountUpNumber(value: count),
                      AppGap.h(AppSize.p4),
                    ],
                    if (onSubtitleTap != null)
                      AppTextButton(
                        label: subtitle,
                        icon: subtitleIcon,
                        onPressed: onSubtitleTap,
                      )
                    else
                      Text(
                        subtitle,
                        maxLines: subtitleMaxLines,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.font14W500Secondary(context),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );

    if (onPressed == null) return gauge;

    return AppPressable(
      onPressed: onPressed,
      tapCooldown: AppConstants.tapCooldown120ms,
      child: gauge,
    );
  }
}

class _CountUpNumber extends StatelessWidget {
  const _CountUpNumber({required this.value});

  final int value;

  @override
  Widget build(BuildContext context) {
    final style = AppTextStyles.font24W700Brand(context);

    if (context.reduceMotion) {
      return Text(AppStrings.counterValue(value), style: style);
    }

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(
        begin: AppConstants.progressStart,
        end: value.toDouble(),
      ),
      duration: AppConstants.tasbeehCountUp1500ms,
      curve: Curves.easeOutCubic,
      builder: (context, animated, child) => Text(
        AppStrings.counterValue(animated.round()),
        maxLines: AppConstants.maxOneLine,
        style: style,
      ),
    );
  }
}

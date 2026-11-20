import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/widgets/app_gap.dart';
import 'package:sana/core/widgets/cards/app_section_card.dart';
import 'package:sana/core/widgets/dividers/custom_app_divider.dart';
import 'package:sana/core/widgets/interaction/app_pressable.dart';
import 'package:sana/features/azkar/presentation/widgets/common/zikr_badge.dart';

class ZikrCardShell extends StatelessWidget {
  const ZikrCardShell({
    required this.content,
    required this.footer,
    required this.showBadge,
    super.key,
    this.onTap,
    this.onLongPress,
    this.isCompleted = false,
    this.semanticButton = false,
  });

  final Widget content;
  final Widget footer;
  final bool showBadge;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool isCompleted;
  final bool semanticButton;

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.only(bottom: AppSize.p16),
    child: Stack(
      children: [
        // Body
        AppSectionCard(
          padding: EdgeInsets.zero,
          child: _buildSurface(
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(
                AppSize.p24,
                showBadge ? AppSize.p24 + AppSize.p16 : AppSize.p24,
                AppSize.p24,
                AppSize.p24,
              ),
              child: AnimatedOpacity(
                duration: AppConstants.animationSlow400ms,
                opacity: isCompleted
                    ? AppConstants.opacityMuted
                    : AppConstants.opacityFull,
                child: AnimatedScale(
                  duration: AppConstants.animationSlow400ms,
                  scale: isCompleted
                      ? AppConstants.scaleCompleted
                      : AppConstants.scaleNormal,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      content,
                      AppGap.h(AppSize.p24),
                      const CustomAppDivider(),
                      AppGap.h(AppSize.p24),
                      footer,
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        if (showBadge)
          PositionedDirectional(
            top: AppSize.p8,
            end: AppSize.p8,
            child: const ZikrBadge(),
          ),
      ],
    ),
  );

  Widget _buildSurface({required Widget child}) {
    if (onTap == null && onLongPress == null) return child;
    return AppPressable(
      onPressed: onTap,
      onLongPress: onLongPress,
      tapCooldown: AppConstants.tapCooldown120ms,
      semanticButton: semanticButton,
      disabledOpacity: AppConstants.opacityFull,
      fadeOpacity: AppConstants.opacityFull,
      child: child,
    );
  }
}

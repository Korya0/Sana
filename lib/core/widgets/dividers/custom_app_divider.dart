import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/theme/icons/app_icons.dart';
import 'package:sana/core/utils/context_extension.dart';
import 'package:sana/core/widgets/app_gap.dart';

class CustomAppDivider extends StatelessWidget {
  const CustomAppDivider({super.key});

  @override
  Widget build(BuildContext context) {
    // Lines + stars
    return Row(
      children: [
        const Expanded(child: _DividerLineWidget(isFirst: true)),
        Icon(
          AppIcons.sparkle,
          size: AppSize.p8,
          color: context.color.iconBrand.withValues(
            alpha: AppConstants.opacityFaint,
          ),
        ),
        AppGap.w(AppSize.p4),
        Container(
          padding: EdgeInsets.all(AppSize.p4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: context.color.iconBrand.withValues(
                alpha: AppConstants.opacityMuted,
              ),
              width: AppSize.borderWidth,
            ),
          ),
          child: Icon(
            AppIcons.sparkle,
            size: AppSize.p12,
            color: context.color.iconBrand,
          ),
        ),
        AppGap.w(AppSize.p4),
        Icon(
          AppIcons.sparkle,
          size: AppSize.p8,
          color: context.color.iconBrand.withValues(
            alpha: AppConstants.opacityFaint,
          ),
        ),
        const Expanded(child: _DividerLineWidget(isFirst: false)),
      ],
    );
  }
}

class _DividerLineWidget extends StatelessWidget {
  const _DividerLineWidget({required this.isFirst});

  final bool isFirst;

  @override
  Widget build(BuildContext context) => Container(
    height: AppSize.dividerThickness,
    margin: EdgeInsets.symmetric(horizontal: AppSize.p8),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: isFirst
            ? [
                context.color.primary.withValues(
                  alpha: AppConstants.opacityTransparent,
                ),
                context.color.primary.withValues(
                  alpha: AppConstants.opacityMuted,
                ),
              ]
            : [
                context.color.primary.withValues(
                  alpha: AppConstants.opacityMuted,
                ),
                context.color.primary.withValues(
                  alpha: AppConstants.opacityTransparent,
                ),
              ],
      ),
    ),
  );
}

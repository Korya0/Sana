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
          AppIcons.star,
          size: AppSize.icon16,
          color: context.color.iconBrand,
        ),
        AppGap.w(AppSize.p4),
        Icon(
          AppIcons.star,
          size: AppSize.icon24,
          color: context.color.iconBrand,
        ),
        AppGap.w(AppSize.p4),
        Icon(
          AppIcons.star,
          size: AppSize.icon16,
          color: context.color.iconBrand,
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
                context.color.borderBrand,
                context.color.dividerColor.withValues(
                  alpha: AppConstants.opacityTransparent,
                ),
              ]
            : [
                context.color.dividerColor.withValues(
                  alpha: AppConstants.opacityTransparent,
                ),
                context.color.borderBrand,
              ],
      ),
    ),
  );
}

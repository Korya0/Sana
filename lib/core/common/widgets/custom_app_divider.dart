import 'package:flutter/material.dart';
import 'package:sana/core/theme/app_spacing.dart';
import 'package:sana/core/utils/utils.dart';
import 'package:solar_icons/solar_icons.dart';

class CustomAppDivider extends StatelessWidget {
  const CustomAppDivider({this.isVertical = false, super.key});

  final bool isVertical;

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: isVertical ? Axis.vertical : Axis.horizontal,
      children: [
        _DividerLine(isVertical: isVertical, isFirst: true),
        _CenterStars(isVertical: isVertical),
        _DividerLine(isVertical: isVertical, isFirst: false),
      ],
    );
  }
}

class _DividerLine extends StatelessWidget {
  const _DividerLine({
    required this.isVertical,
    required this.isFirst,
  });

  final bool isVertical;
  final bool isFirst;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: isVertical ? 0 : AppSpacing.v8,
          vertical: isVertical ? AppSpacing.v8 : 0,
        ),
        width: isVertical ? 1 : null,
        height: isVertical ? null : 1,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: isVertical ? Alignment.topCenter : Alignment.centerLeft,
            end: isVertical ? Alignment.bottomCenter : Alignment.centerRight,
            colors: isFirst
                ? [
                    context.color.primary.withValues(alpha: 0),
                    context.color.primary.withValues(alpha: 0.5),
                  ]
                : [
                    context.color.primary.withValues(alpha: 0.5),
                    context.color.primary.withValues(alpha: 0),
                  ],
          ),
        ),
      ),
    );
  }
}

class _CenterStars extends StatelessWidget {
  const _CenterStars({required this.isVertical});

  final bool isVertical;

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: isVertical ? Axis.vertical : Axis.horizontal,
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          SolarIconsBold.star,
          color: context.color.primary.withValues(alpha: 0.4),
          size: 8,
        ),
        const SizedBox.square(dimension: AppSpacing.v4),
        Container(
          padding: const EdgeInsets.all(AppSpacing.v4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: context.color.primary.withValues(alpha: 0.5),
            ),
          ),
          child: Icon(
            SolarIconsBold.star,
            color: context.color.primary,
            size: 12,
          ),
        ),
        const SizedBox.square(dimension: AppSpacing.v4),
        Icon(
          SolarIconsBold.star,
          color: context.color.primary.withValues(alpha: 0.4),
          size: 8,
        ),
      ],
    );
  }
}

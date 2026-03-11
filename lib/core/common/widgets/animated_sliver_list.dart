import 'package:flutter/material.dart';
import 'package:sana/core/common/animations/app_animations.dart';

class AnimatedSliverList<T> extends StatelessWidget {
  const AnimatedSliverList({
    required this.items,
    required this.itemBuilder,
    super.key,
    this.padding,
    this.maxAnimatedIndex = 8,
    this.animationDuration = const Duration(milliseconds: 400),
    this.delayPerItem = const Duration(milliseconds: 50),
  });

  final List<T> items;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final EdgeInsetsGeometry? padding;
  final int maxAnimatedIndex;
  final Duration animationDuration;
  final Duration delayPerItem;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding:
          padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final item = items[index];
            final child = Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: itemBuilder(context, item, index),
            );

            // Optimization: Only animate up to maxAnimatedIndex to save GPU resources
            if (index > maxAnimatedIndex) return child;

            return AppAnimations.fadeInUp(
              child,
              duration: animationDuration,
              delay: Duration(milliseconds: index * delayPerItem.inMilliseconds),
            );
          },
          childCount: items.length,
        ),
      ),
    );
  }
}

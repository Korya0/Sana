import 'package:flutter/material.dart';
import 'package:sana/core/common/animations/app_animations.dart';

class AnimatedSliverList<T> extends StatelessWidget {

  const AnimatedSliverList({
    required this.items, required this.itemBuilder, super.key,
    this.padding,
  });
  final List<T> items;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding:
          padding ??
          const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          final item = items[index];
          final child = Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: itemBuilder(context, item, index),
          );

          // Only animate the first 6 items to avoid overwhelming the GPU on low-end devices
          if (index > 6) return child;

          return AppAnimations.fadeInUp(
            child,
            duration: const Duration(milliseconds: 400),
            delay: Duration(milliseconds: index * 50),
          );
        }, childCount: items.length),
      ),
    );
  }
}

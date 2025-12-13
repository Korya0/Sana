import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

class AnimatedSliverList<T> extends StatelessWidget {
  final List<T> items;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final EdgeInsetsGeometry? padding;

  const AnimatedSliverList({
    super.key,
    required this.items,
    required this.itemBuilder,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding:
          padding ?? EdgeInsets.symmetric(horizontal: (16), vertical: (16)),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          final item = items[index];
          return Padding(
            padding: EdgeInsets.only(bottom: (12)),
            child: FadeInUp(
              duration: const Duration(milliseconds: 500),
              delay: Duration(milliseconds: index > 10 ? 0 : index * 50),
              child: itemBuilder(context, item, index),
            ),
          );
        }, childCount: items.length),
      ),
    );
  }
}

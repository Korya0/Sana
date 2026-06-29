import 'package:flutter/material.dart';
import 'package:sana/core/theme/style/app_spacing.dart';
import 'package:sana/core/utils/utils.dart';

typedef ItemAnimationBuilder =
    Widget Function(
      BuildContext context,
      Widget child,
      int index,
      Duration duration,
      Duration delay,
    );

class AnimatedSliverList<T> extends StatelessWidget {
  const AnimatedSliverList({
    required this.dataList,
    required this.itemContentBuilder,
    super.key,
    this.listPadding,
    this.animationLimitIndex = 8,
    this.animationDuration = const Duration(milliseconds: 400),
    this.staggerDelay = const Duration(milliseconds: 50),
    this.itemSpacing = const EdgeInsets.only(bottom: AppSpacing.v12),
    this.customAnimationBuilder,
    this.emptyStateWidget,
    this.keyFinder,
    this.footerSliver,
  });

  /// Global default animation applied to all [AnimatedSliverList] instances unless overridden.
  static ItemAnimationBuilder? globalDefaultAnimation;

  /// The data source for the list.
  final List<T> dataList;

  /// Builder function to create the UI for each data item.
  final Widget Function(BuildContext context, T item, int index)
  itemContentBuilder;

  /// Optional padding around the entire list.
  final EdgeInsetsGeometry? listPadding;

  /// Limit animations to the first N items to optimize GPU performance on long lists.
  final int animationLimitIndex;

  /// Duration of the entrance animation for each item.
  final Duration animationDuration;

  /// Delay added to each subsequent item to create a staggered entrance effect.
  final Duration staggerDelay;

  /// Spacing (usually bottom padding) applied to each list item.
  final EdgeInsetsGeometry itemSpacing;

  /// Optional builder to provide a specific animation for this instance.
  final ItemAnimationBuilder? customAnimationBuilder;

  /// Widget to display when the [dataList] is empty.
  final Widget? emptyStateWidget;

  /// Function to extract a unique [Key] for each item, improving list performance.
  final Key? Function(T item, int index)? keyFinder;

  /// An optional sliver (like a loader or button) to display at the end of the list.
  final Widget? footerSliver;

  @override
  Widget build(BuildContext context) {
    // 1. Handle Empty State
    if (dataList.isEmpty && emptyStateWidget != null) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: emptyStateWidget,
      );
    }

    // 2. Build the Main Animated List
    final mainListSliver = SliverPadding(
      padding:
          listPadding ??
          EdgeInsets.symmetric(
            horizontal: AppSpacing.v16.r(context),
            vertical: AppSpacing.v16.r(context),
          ),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final item = dataList[index];

            // Wrap item with spacing and a unique Key for better performance
            final itemWithSpacing = Padding(
              key: keyFinder?.call(item, index),
              padding: itemSpacing,
              child: itemContentBuilder(context, item, index),
            );

            // Optimization: Stop animating items beyond the visible limit
            if (index > animationLimitIndex) return itemWithSpacing;

            final duration = animationDuration;
            final delay = Duration(
              milliseconds: index * staggerDelay.inMilliseconds,
            );

            // Resolve Animation (Priority: Custom -> Global -> None)
            if (customAnimationBuilder != null) {
              return customAnimationBuilder!(
                context,
                itemWithSpacing,
                index,
                duration,
                delay,
              );
            }

            if (globalDefaultAnimation != null) {
              return globalDefaultAnimation!(
                context,
                itemWithSpacing,
                index,
                duration,
                delay,
              );
            }

            return itemWithSpacing;
          },
          childCount: dataList.length,
        ),
      ),
    );

    // 3. Attach Footer if provided
    if (footerSliver != null) {
      return SliverMainAxisGroup(
        slivers: [mainListSliver, footerSliver!],
      );
    }

    return mainListSliver;
  }
}

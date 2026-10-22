import 'package:flutter/material.dart';

/// Lazy sliver list — the standard replacement for `ListView.builder`,
/// `ListView.separated` and `ListView` with children.
class AppSliverList extends StatelessWidget {
  const AppSliverList({
    required this.itemCount,
    required this.itemBuilder,
    this.separatorBuilder,
    this.padding = EdgeInsets.zero,
    super.key,
  });

  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final IndexedWidgetBuilder? separatorBuilder;
  final EdgeInsetsGeometry padding;

  // Separator is optional — it maps to SliverList.separated
  @override
  Widget build(BuildContext context) => SliverPadding(
    padding: padding,
    sliver: switch (separatorBuilder) {
      final builder? => SliverList.separated(
        itemCount: itemCount,
        itemBuilder: itemBuilder,
        separatorBuilder: builder,
      ),
      null => SliverList.builder(
        itemCount: itemCount,
        itemBuilder: itemBuilder,
      ),
    },
  );
}

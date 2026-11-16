import 'package:flutter/material.dart';

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

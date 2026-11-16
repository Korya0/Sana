import 'package:flutter/material.dart';

class AppSliverGrid extends StatelessWidget {
  const AppSliverGrid.extent({
    required this.itemCount,
    required this.itemBuilder,
    required this.maxCrossAxisExtent,
    this.childAspectRatio = 1,
    this.mainAxisSpacing = 0,
    this.crossAxisSpacing = 0,
    this.padding = EdgeInsets.zero,
    super.key,
  }) : crossAxisCount = null;

  const AppSliverGrid.count({
    required this.itemCount,
    required this.itemBuilder,
    required this.crossAxisCount,
    this.childAspectRatio = 1,
    this.mainAxisSpacing = 0,
    this.crossAxisSpacing = 0,
    this.padding = EdgeInsets.zero,
    super.key,
  }) : maxCrossAxisExtent = null;

  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final double? maxCrossAxisExtent;
  final int? crossAxisCount;
  final double childAspectRatio;
  final double mainAxisSpacing;
  final double crossAxisSpacing;
  final EdgeInsetsGeometry padding;

  // Tiles grow by width, or by a fixed column count
  @override
  Widget build(BuildContext context) => SliverPadding(
    padding: padding,
    sliver: SliverGrid.builder(
      itemCount: itemCount,
      itemBuilder: itemBuilder,
      gridDelegate: crossAxisCount != null
          ? SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount!,
              mainAxisSpacing: mainAxisSpacing,
              crossAxisSpacing: crossAxisSpacing,
              childAspectRatio: childAspectRatio,
            )
          : SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: maxCrossAxisExtent!,
              mainAxisSpacing: mainAxisSpacing,
              crossAxisSpacing: crossAxisSpacing,
              childAspectRatio: childAspectRatio,
            ),
    ),
  );
}

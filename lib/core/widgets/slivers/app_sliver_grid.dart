import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_sizes.dart';

class AppSliverGrid extends StatelessWidget {
  const AppSliverGrid.extent({
    required this.itemCount,
    required this.itemBuilder,
    required this.maxCrossAxisExtent,
    this.childAspectRatio = 1,
    this.mainAxisSpacing,
    this.crossAxisSpacing,
    this.padding = EdgeInsets.zero,
    this.mainAxisExtent,
    super.key,
  }) : crossAxisCount = null;

  const AppSliverGrid.count({
    required this.itemCount,
    required this.itemBuilder,
    required this.crossAxisCount,
    this.childAspectRatio = 1,
    this.mainAxisSpacing,
    this.crossAxisSpacing,
    this.padding = EdgeInsets.zero,
    super.key,
  }) : maxCrossAxisExtent = null,
       mainAxisExtent = null;

  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final double? maxCrossAxisExtent;
  final int? crossAxisCount;
  final double? mainAxisExtent;
  final double childAspectRatio;
  final double? mainAxisSpacing;
  final double? crossAxisSpacing;
  final EdgeInsetsGeometry padding;

  // Tiles grow by width, or by a fixed column count
  @override
  Widget build(BuildContext context) {
    // Nullable fields keep every existing caller source-compatible; unresolved
    // spacings fall back to a token instead of a raw zero.
    final mainSpacing = mainAxisSpacing ?? AppSize.p4;
    final crossSpacing = crossAxisSpacing ?? AppSize.p4;
    return SliverPadding(
      padding: padding,
      sliver: SliverGrid.builder(
        itemCount: itemCount,
        itemBuilder: itemBuilder,
        gridDelegate: crossAxisCount != null
            ? SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount!,
                mainAxisSpacing: mainSpacing,
                crossAxisSpacing: crossSpacing,
                childAspectRatio: childAspectRatio,
              )
            : SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: maxCrossAxisExtent!,
                mainAxisExtent: mainAxisExtent,
                mainAxisSpacing: mainSpacing,
                crossAxisSpacing: crossSpacing,
                childAspectRatio: mainAxisExtent == null ? childAspectRatio : 1,
              ),
      ),
    );
  }
}

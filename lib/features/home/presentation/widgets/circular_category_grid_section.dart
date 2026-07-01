import 'package:flutter/material.dart';
import 'package:sana/core/theme/app_spacing.dart';
import 'package:sana/features/home/data/models/category_item.dart';
import 'package:sana/features/home/presentation/widgets/category/feature_circular_card.dart';

class CircularCategoryGridSection extends StatelessWidget {
  const CircularCategoryGridSection({
    required this.title,
    required this.categories,
    required this.onCategoryTap,
    super.key,
    this.headerChild,
  });

  final String title;
  final List<CategoryItem> categories;
  final Widget? headerChild;
  final void Function(CategoryItem) onCategoryTap;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.v18),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 100,
          mainAxisSpacing: 2,
          crossAxisSpacing: 8,
          childAspectRatio: 0.8,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final item = categories[index];
            return FeatureCircularCard(
              title: item.title,
              icon: item.icon,
              isFaded: item.isComingSoon || item.isRestricted,
              onTap: () => onCategoryTap(item),
            );
          },
          childCount: categories.length,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:sana/core/theme/style/app_spacing.dart';
import 'package:sana/features/home/data/models/category_item.dart';
import 'package:sana/features/home/presentation/widgets/category/category_section_header.dart';
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CategorySectionHeader(title: title, child: headerChild),
        const SizedBox(height: AppSpacing.v12),
        GridView.builder(
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.v18),
          physics: const NeverScrollableScrollPhysics(),
          clipBehavior: Clip.none,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 2,
            crossAxisSpacing: 8,
            childAspectRatio: 0.8,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final item = categories[index];
            return FeatureCircularCard(
              title: item.title,
              icon: item.icon as IconData,
              isFaded: item.isComingSoon || item.isRestricted,
              onTap: () => onCategoryTap(item),
            );
          },
        ),
      ],
    );
  }
}

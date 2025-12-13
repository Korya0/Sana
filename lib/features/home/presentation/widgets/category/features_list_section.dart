import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_spacing.dart';
import 'package:sana/features/home/data/model/category_item.dart';
import 'package:sana/features/home/presentation/widgets/category/category_card.dart';
import 'package:sana/features/home/presentation/widgets/category/category_section_header.dart';

class CategoryListSection extends StatelessWidget {
  final String title;
  final List<CategoryItem> features;
  final String usageKey;
  final bool isGrid;
  final Widget? headerChild;

  const CategoryListSection({
    super.key,
    required this.title,
    required this.features,
    required this.usageKey,
    this.isGrid = false,
    this.headerChild,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CategorySectionHeader(title: title, child: headerChild),
        SizedBox(height: (12)),
        SizedBox(
          height: isGrid ? (240) : (120),
          child: isGrid
              ? GridView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.horizontalP18,
                  ),
                  scrollDirection: Axis.horizontal,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: (12),
                    crossAxisSpacing: (12),
                    childAspectRatio: 1.1,
                  ),
                  itemCount: features.length,
                  itemBuilder: (context, index) => _buildItem(context, index),
                )
              : ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.horizontalP18,
                  ),
                  scrollDirection: Axis.horizontal,
                  itemCount: features.length,
                  separatorBuilder: (context, index) => SizedBox(width: (12)),
                  itemBuilder: (context, index) => _buildItem(context, index),
                ),
        ),
      ],
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    final item = features[index];
    return CategoryCard(
      title: item.title,
      icon: item.icon,
      onTap: () async {
        if (item.onTap != null) {
          await item.onTap!(context);
        }
      },
    );
  }
}

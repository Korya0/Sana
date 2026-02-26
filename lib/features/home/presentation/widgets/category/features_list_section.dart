import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_design.dart';

import 'package:sana/features/home/data/models/category_item.dart';
import 'package:sana/features/home/presentation/widgets/category/category_card.dart';
import 'package:sana/features/home/presentation/widgets/category/category_section_header.dart';

class CategoryListSection extends StatelessWidget {
  const CategoryListSection({
    required this.title,
    required this.features,
    super.key,
    this.isGrid = false,
    this.headerChild,
  });
  final String title;
  final List<CategoryItem> features;
  final bool isGrid;
  final Widget? headerChild;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 8,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        CategorySectionHeader(title: title, child: headerChild),

        SizedBox(
          height: isGrid ? 240 : 120,
          child: isGrid
              ? GridView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDesign.horizontalP18,
                  ),
                  scrollDirection: Axis.horizontal,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 10,
                    childAspectRatio: 1.1,
                  ),
                  itemCount: features.length,
                  itemBuilder: _buildItem,
                )
              : ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDesign.horizontalP18,
                  ),
                  scrollDirection: Axis.horizontal,
                  itemCount: features.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 12),
                  itemBuilder: _buildItem,
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
      isRestricted: item.isRestricted,
      onTap: () async {
        if (item.onTap != null) {
          await item.onTap!(context);
        }
      },
    );
  }
}

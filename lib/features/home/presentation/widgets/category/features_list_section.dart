import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/features/home/data/model/category_item.dart';
import 'package:sana/features/home/presentation/widgets/category/category_card.dart';
import 'package:sana/features/home/presentation/widgets/category/category_section_header.dart';

class CategoryListSection extends StatelessWidget {
  final String title;
  final List<CategoryItem> features;
  final bool isGrid;
  final Widget? headerChild;
  const CategoryListSection({
    super.key,
    required this.title,
    required this.features,
    this.isGrid = false,
    this.headerChild,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CategorySectionHeader(title: title, child: headerChild),
        const SizedBox(height: (12)),
        SizedBox(
          height: isGrid ? (240) : (120),
          child: isGrid
              ? GridView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.horizontalP18,
                  ),
                  scrollDirection: Axis.horizontal,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: (12),
                    crossAxisSpacing: 10,
                    childAspectRatio: 1.1,
                  ),
                  itemCount: features.length,
                  itemBuilder: _buildItem,
                )
              : ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.horizontalP18,
                  ),
                  scrollDirection: Axis.horizontal,
                  itemCount: features.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: (12)),
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

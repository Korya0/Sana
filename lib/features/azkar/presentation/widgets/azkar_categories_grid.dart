import 'package:flutter/material.dart';
import 'package:sana/core/theme/app_spacing.dart';
import 'package:sana/features/azkar/domain/entities/category_entity.dart';
import 'package:sana/features/azkar/presentation/widgets/category_card.dart';

class AzkarCategoriesGrid extends StatelessWidget {
  const AzkarCategoriesGrid({
    required this.categories,
    required this.onCategoryTap,
    super.key,
  });

  final List<CategoryEntity> categories;
  final void Function(CategoryEntity) onCategoryTap;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.all(AppSpacing.v20),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: AppSpacing.v16,
          crossAxisSpacing: AppSpacing.v16,
          childAspectRatio: 1.1,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final category = categories[index];
            return CategoryCard(
              category: category,
              onTap: () => onCategoryTap(category),
            );
          },
          childCount: categories.length,
        ),
      ),
    );
  }
}

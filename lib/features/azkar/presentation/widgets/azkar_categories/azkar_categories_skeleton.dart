import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/features/azkar/domain/entities/azkar_category_entity.dart';
import 'package:sana/features/azkar/presentation/widgets/azkar_categories/azkar_categories_grid.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AzkarCategoriesSkeleton extends StatelessWidget {
  // Creates skeleton
  const AzkarCategoriesSkeleton({super.key});

  // Builds skeleton
  @override
  Widget build(BuildContext context) => Skeletonizer.sliver(
    child: SliverIgnorePointer(
      sliver: AzkarCategoriesGrid(
        categories: List.generate(
          AppConstants.azkarCategorySkeletonCount,
          (index) => AzkarCategoryEntity(
            key: 'skeleton_$index',
            title: AppStrings.loading,
            cardTitle: AppStrings.loading,
          ),
        ),
      ),
    ),
  );
}

import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/features/azkar/domain/entities/category_entity.dart';
import 'package:sana/features/azkar/presentation/widgets/categories/azkar_categories_grid.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AzkarCategoriesSkeleton extends StatelessWidget {
  const AzkarCategoriesSkeleton({super.key});

  @override
  Widget build(BuildContext context) => Skeletonizer.sliver(
    child: SliverIgnorePointer(
      sliver: AzkarCategoriesGrid(
        categories: List.generate(
          AppConstants.azkarCategorySkeletonCount,
          (index) => CategoryEntity(
            key: 'skeleton_$index',
            title: AppStrings.loading,
            cardTitle: AppStrings.loading,
          ),
        ),
      ),
    ),
  );
}

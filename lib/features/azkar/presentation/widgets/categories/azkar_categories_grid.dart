import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/router/app_navigator.dart';
import 'package:sana/core/router/app_routes.dart';
import 'package:sana/core/widgets/headers/app_section_header.dart';
import 'package:sana/core/widgets/slivers/app_sliver_grid.dart';
import 'package:sana/features/azkar/domain/entities/azkar_category_type.dart';
import 'package:sana/features/azkar/domain/entities/category_entity.dart';
import 'package:sana/features/azkar/presentation/widgets/categories/azkar_category_card.dart';

class AzkarCategoriesGrid extends StatelessWidget {
  const AzkarCategoriesGrid({required this.categories, super.key});

  /// JSON order is the display order; no runtime sorting or rank table.
  final List<CategoryEntity> categories;

  @override
  Widget build(BuildContext context) => SliverPadding(
    padding: AppSize.shp,
    sliver: SliverMainAxisGroup(
      slivers: [
        // Header
        const SliverToBoxAdapter(
          child: AppSectionHeader(title: AppStrings.azkarHeader),
        ),

        // Grid
        AppSliverGrid.extent(
          maxCrossAxisExtent: AppSize.categoryTileMaxExtent,
          mainAxisSpacing: AppSize.p4,
          crossAxisSpacing: AppSize.p8,
          childAspectRatio: AppConstants.azkarCategoryTileAspectRatio,
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return AzkarCategoryCard(
              type: AzkarCategoryType.fromKey(category.key),
              title: category.cardTitle,
              onTap: () => AppNavigator.pushNamed(
                context,
                AppRoutes.azkarCategoryPath,
                pathParameters: {AppRoutes.categoryKeyParam: category.key},
                extra: category.title,
              ),
            );
          },
        ),
      ],
    ),
  );
}

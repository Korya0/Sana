import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/router/app_routes.dart';
import 'package:sana/core/widgets/buttons/app_text_button.dart';
import 'package:sana/core/widgets/headers/app_section_header.dart';
import 'package:sana/core/widgets/slivers/app_sliver_grid.dart';
import 'package:sana/features/azkar/domain/entities/azkar_category_type.dart';
import 'package:sana/features/azkar/domain/entities/category_entity.dart';
import 'package:sana/features/azkar/presentation/cubits/categories/azkar_categories_cubit.dart';
import 'package:sana/features/azkar/presentation/widgets/categories/azkar_category_card.dart';

class AzkarCategoriesGrid extends StatelessWidget {
  const AzkarCategoriesGrid({required this.categories, super.key});

  /// Custom categories appear first, followed by standard JSON categories.
  final List<CategoryEntity> categories;

  @override
  Widget build(BuildContext context) {
    final hasCustomCategories = categories.any((c) => c.isCustom);

    return SliverPadding(
      padding: AppSize.shp,
      sliver: SliverMainAxisGroup(
        slivers: [
          // Header
          SliverToBoxAdapter(
            child: AppSectionHeader(
              title: AppStrings.azkarCategoriesSectionTitle,
              trailing: AppTextButton(
                label: hasCustomCategories
                    ? AppStrings.customAzkar
                    : AppStrings.customZikrWithPlus,
                onPressed: () async {
                  if (hasCustomCategories) {
                    await context.pushNamed(AppRoutes.customAzkarListPath);
                  } else {
                    await context.pushNamed(AppRoutes.customZikrFormPath);
                  }
                  if (context.mounted) {
                    unawaited(
                      context.read<AzkarCategoriesCubit>().loadCategories(),
                    );
                  }
                },
              ),
            ),
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
                type: category.isCustom
                    ? null
                    : AzkarCategoryType.fromKey(category.key),
                title: category.cardTitle,
                onTap: () async {
                  await context.pushNamed(
                    AppRoutes.azkarCategoryPath,
                    pathParameters: {AppRoutes.categoryKeyParam: category.key},
                    extra: category.title,
                  );
                  if (context.mounted) {
                    unawaited(
                      context.read<AzkarCategoriesCubit>().loadCategories(),
                    );
                  }
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

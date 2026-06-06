import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sana/core/utils/context_extension.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/routing/app_routes.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_spacing.dart';
import 'package:sana/features/azkar/data/models/azkar_category_model.dart';
import 'package:sana/features/azkar/presentation/cubit/azkar_categories_cubit.dart';
import 'package:sana/features/azkar/presentation/utils/azkar_ui_helpers.dart';
import 'package:sana/features/home/data/models/category_item.dart';
import 'package:sana/features/home/presentation/widgets/category/category_section_header.dart';
import 'package:sana/features/home/presentation/widgets/circular_category_grid_section.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomeAzkarCategorySection extends StatelessWidget {
  const HomeAzkarCategorySection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AzkarCategoriesCubit, AzkarCategoriesState>(
      builder: (context, state) {
        return switch (state) {
          AzkarCategoriesLoaded(:final azkarCategories) => _AzkarLoadedSection(
            categories: azkarCategories,
          ),
          AzkarCategoriesError() => const SizedBox.shrink(),
          _ => const _AzkarSkeletonLoader(),
        };
      },
    );
  }
}

class _AzkarLoadedSection extends StatelessWidget {
  const _AzkarLoadedSection({required this.categories});
  final List<AzkarCategoryModel> categories;

  @override
  Widget build(BuildContext context) {
    final azkarFeatures = categories
        .map(
          (category) => CategoryItem(
            id: category.id,
            title: category.category,
            icon: AzkarUIHelpers.getCategoryIcon(category.id),
            route: AppRoutes.azkar,
          ),
        )
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Skeleton.keep(
          child: CategorySectionHeader(
            title: AppStrings.azkarHeader,
            child: GestureDetector(
              onTap: () {
                unawaited(context.pushNamed(AppRoutes.allAzkar));
              },
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  AppStrings.showMore,
                  style: AppTextStyles.font12W700(context).copyWith(color: context.color.textAccent),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.v12),
        CircularCategoryGridSection(
          categories: azkarFeatures.take(8).toList(),
          title: AppStrings.azkarHeader,
          onCategoryTap: (item) async {
            final category = categories.firstWhere((c) => c.id == item.id);
            await context.pushNamed(
              AppRoutes.azkar,
              pathParameters: {AppRoutes.categoryIdKey: item.id},
              extra: category,
            );
          },
        ),
      ],
    );
  }
}

class _AzkarSkeletonLoader extends StatelessWidget {
  const _AzkarSkeletonLoader();

  @override
  Widget build(BuildContext context) {
    final dummyCategories = List.generate(
      8,
      (index) => AzkarCategoryModel(
        id: (index + 1).toString(),
        category: 'أذكار الصباح',
        array: const [],
      ),
    );

    return Skeletonizer(
      child: _AzkarLoadedSection(categories: dummyCategories),
    );
  }
}

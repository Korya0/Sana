import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sana/core/constants/constants.dart';
import 'package:sana/core/routing/app_routes.dart';
import 'package:sana/core/theme/app_spacing.dart';
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
            title: category.category.replaceFirst(RegExp(r'^(أذكار|اذكار)\s+'), ''),
            icon: AzkarUIHelpers.getCategoryIcon(category.id),
            route: AppRoutes.azkar,
          ),
        )
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Skeleton.keep(
          child: CategorySectionHeader(
            title: AppStrings.azkarHeader,
          ),
        ),
        const SizedBox(height: AppSpacing.v12),
        CircularCategoryGridSection(
          categories: azkarFeatures,
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

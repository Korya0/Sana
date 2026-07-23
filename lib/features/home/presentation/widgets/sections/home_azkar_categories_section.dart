import 'package:sana/core/routing/app_navigator.dart';
import 'package:sana/core/common/common.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/constants/constants.dart';
import 'package:sana/core/di/service_locator.dart';
import 'package:sana/core/routing/app_routes.dart';
import 'package:sana/core/constants/app_spacing.dart';
import 'package:sana/features/azkar/domain/entities/category_entity.dart';
import 'package:sana/features/azkar/presentation/cubit/categories/azkar_categories_cubit.dart';
import 'package:sana/features/azkar/presentation/cubit/categories/azkar_categories_state.dart';
import 'package:sana/features/azkar/presentation/utils/category_icon_mapper.dart';
import 'package:sana/features/home/data/models/category_item.dart';
import 'package:sana/features/home/presentation/widgets/category/category_section_header.dart';
import 'package:sana/features/home/presentation/widgets/circular_category_grid_section.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomeAzkarCategoriesSection extends StatelessWidget {
  const HomeAzkarCategoriesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = sl<AzkarCategoriesCubit>();
        unawaited(cubit.loadCategories());
        return cubit;
      },
      child: BlocBuilder<AzkarCategoriesCubit, AzkarCategoriesState>(
        builder: (context, state) {
          if (state is AzkarCategoriesLoaded) {
            return _AzkarCategoriesLoaded(state: state);
          } else if (state is AzkarCategoriesError) {
            return const SliverToBoxAdapter(child: SizedBox.shrink());
          }
          return const _AzkarCategoriesSkeleton();
        },
      ),
    );
  }
}

class _AzkarCategoriesLoaded extends StatelessWidget {
  const _AzkarCategoriesLoaded({required this.state});
  final AzkarCategoriesLoaded state;

  static const List<int> _orderedIds = [
    2,
    3,
    5,
    4,
    1,
    6,
    7,
    8,
    9,
    10,
    11,
    12,
    13,
    14,
    15,
    16,
    17,
    18,
    19,
    20,
    21,
    22,
    23,
  ];

  @override
  Widget build(BuildContext context) {
    final orderedCategories = List<CategoryEntity>.from(state.categories)
      ..sort((a, b) {
        final indexA = _orderedIds.indexOf(a.id);
        final indexB = _orderedIds.indexOf(b.id);
        return indexA.compareTo(indexB);
      });

    final categories = orderedCategories.map((c) {
      final cleanTitle = c.title.startsWith('أذكار ')
          ? c.title.substring(6)
          : c.title;

      return CategoryItem(
        id: c.id.toString(),
        title: cleanTitle,
        icon: CategoryIconMapper.getIcon(c.id),
        route: AppRoutes.azkarList,
      );
    }).toList();

    return SliverMainAxisGroup(
      slivers: [
        const SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Skeleton.keep(
                child: CategorySectionHeader(
                  title: AppStrings.azkarHeader,
                ),
              ),
              AppGap.h(AppSpacing.v12),
            ],
          ),
        ),
        CircularCategoryGridSection(
          categories: categories,
          title: AppStrings.azkarHeader,
          onCategoryTap: (item) async {
            // Find original category to pass original title as extra
            final originalCategory = state.categories.firstWhere(
              (c) => c.id.toString() == item.id,
            );
            await AppNavigator.pushNamed(context, 
              item.route,
              pathParameters: {
                AppRoutes.categoryIdKey: item.id,
              },
              extra: originalCategory.title,
            );
          },
        ),
      ],
    );
  }
}

class _AzkarCategoriesSkeleton extends StatelessWidget {
  const _AzkarCategoriesSkeleton();

  @override
  Widget build(BuildContext context) {
    final dummyState = AzkarCategoriesLoaded(
      List.generate(
        8,
        (index) => CategoryEntity(
          id: index + 1,
          title: 'تحميل القسم...',
        ),
      ),
    );

    return SliverSkeletonizer(
      child: _AzkarCategoriesLoaded(state: dummyState),
    );
  }
}

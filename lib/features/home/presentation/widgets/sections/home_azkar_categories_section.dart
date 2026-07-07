import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sana/core/constants/constants.dart';
import 'package:sana/core/di/service_locator.dart';
import 'package:sana/core/routing/app_routes.dart';
import 'package:sana/core/theme/app_spacing.dart';
import 'package:sana/features/azkar/domain/entities/category_entity.dart';
import 'package:sana/features/azkar/presentation/cubits/categories/azkar_categories_cubit.dart';
import 'package:sana/features/azkar/presentation/cubits/categories/azkar_categories_state.dart';
import 'package:sana/features/azkar/presentation/widgets/category_icon_mapper.dart';
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

  @override
  Widget build(BuildContext context) {
    final categories = state.categories.map((c) {
      return CategoryItem(
        id: c.id.toString(),
        title: c.title,
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
              SizedBox(height: AppSpacing.v12),
            ],
          ),
        ),
        CircularCategoryGridSection(
          categories: categories,
          title: AppStrings.azkarHeader,
          onCategoryTap: (item) async {
            await context.pushNamed(
              item.route,
              pathParameters: {
                AppRoutes.categoryIdKey: item.id,
              },
              extra: item.title,
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

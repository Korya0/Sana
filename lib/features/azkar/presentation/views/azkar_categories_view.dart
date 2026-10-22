import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/di/app_injector.dart';
import 'package:sana/core/widgets/views/app_empty_view.dart';
import 'package:sana/core/widgets/views/app_error_view.dart';
import 'package:sana/features/azkar/presentation/cubits/categories/azkar_categories_cubit.dart';
import 'package:sana/features/azkar/presentation/cubits/categories/azkar_categories_state.dart';
import 'package:sana/features/azkar/presentation/widgets/categories/azkar_categories_grid.dart';
import 'package:sana/features/azkar/presentation/widgets/categories/azkar_categories_skeleton.dart';

class AzkarCategoriesView extends StatelessWidget {
  const AzkarCategoriesView({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (context) {
      final cubit = sl<AzkarCategoriesCubit>();
      unawaited(cubit.loadCategories());
      return cubit;
    },
    child: Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverSafeArea(
            bottom: false,
            sliver: SliverPadding(
              padding: EdgeInsets.only(top: AppSize.stp),
              sliver: const _AzkarCategoriesSection(),
            ),
          ),
        ],
      ),
    ),
  );
}

class _AzkarCategoriesSection extends StatelessWidget {
  const _AzkarCategoriesSection();

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<AzkarCategoriesCubit, AzkarCategoriesState>(
        builder: (context, state) => switch (state) {
          AzkarCategoriesLoaded(:final categories) => AzkarCategoriesGrid(
            categories: categories,
          ),
          AzkarCategoriesEmpty() => const SliverFillRemaining(
            hasScrollBody: false,
            child: AppEmptyView(title: AppStrings.azkarCategoriesEmpty),
          ),

          AzkarCategoriesError(:final message) => SliverFillRemaining(
            hasScrollBody: false,
            child: AppErrorView(
              message: message,
              onRetry: () => unawaited(
                context.read<AzkarCategoriesCubit>().loadCategories(),
              ),
            ),
          ),
          AzkarCategoriesInitial() ||
          AzkarCategoriesLoading() => const AzkarCategoriesSkeleton(),
        },
      );
}

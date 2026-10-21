import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/widgets/views/app_empty_view.dart';
import 'package:sana/core/widgets/views/app_error_view.dart';
import 'package:sana/features/azkar/presentation/cubits/categories/azkar_categories_cubit.dart';
import 'package:sana/features/azkar/presentation/cubits/categories/azkar_categories_state.dart';
import 'package:sana/features/azkar/presentation/widgets/categories/azkar_categories_grid.dart';
import 'package:sana/features/azkar/presentation/widgets/categories/azkar_categories_skeleton.dart';

class AzkarCategoriesSection extends StatelessWidget {
  const AzkarCategoriesSection({super.key});

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<AzkarCategoriesCubit, AzkarCategoriesState>(
        builder: (context, state) => switch (state) {
          AzkarCategoriesLoaded(:final categories) => AzkarCategoriesGrid(
            categories: categories,
          ),
          AzkarCategoriesEmpty() => const SliverFillRemaining(
            hasScrollBody: false,
            child: AppEmptyView(message: AppStrings.azkarCategoriesEmpty),
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

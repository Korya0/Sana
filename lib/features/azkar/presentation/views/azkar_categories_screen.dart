import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:sana/core/common/common.dart';
import 'package:sana/core/routing/app_routes.dart';
import 'package:sana/features/azkar/presentation/cubits/categories/azkar_categories_cubit.dart';
import 'package:sana/features/azkar/presentation/cubits/categories/azkar_categories_state.dart';
import 'package:sana/features/azkar/presentation/widgets/azkar_categories_grid.dart';

final GetIt sl = GetIt.instance;

class AzkarCategoriesScreen extends StatelessWidget {
  const AzkarCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = sl<AzkarCategoriesCubit>();
        unawaited(cubit.loadCategories());
        return cubit;
      },
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            CommonSliverAppBar(
              title: AppStrings.azkarHeader,
              onBackPressed: () {
                context.pop();
              },
            ),
            BlocBuilder<AzkarCategoriesCubit, AzkarCategoriesState>(
              builder: (context, state) {
                if (state is AzkarCategoriesLoading) {
                  return const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  );
                } else if (state is AzkarCategoriesError) {
                  return SliverFillRemaining(
                    child: Center(child: Text(state.message)),
                  );
                } else if (state is AzkarCategoriesLoaded) {
                  return AzkarCategoriesGrid(
                    categories: state.categories,
                    onCategoryTap: (category) {
                      unawaited(
                        context.pushNamed(
                          AppRoutes.azkarList,
                          pathParameters: {
                            AppRoutes.categoryIdKey: category.id.toString(),
                          },
                          extra: category.title,
                        ),
                      );
                    },
                  );
                }
                return const SliverFillRemaining(child: SizedBox.shrink());
              },
            ),
          ],
        ),
      ),
    );
  }
}

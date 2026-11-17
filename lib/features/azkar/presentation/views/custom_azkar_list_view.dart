import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/di/app_injector.dart';
import 'package:sana/core/router/app_routes.dart';
import 'package:sana/core/widgets/app_gap.dart';
import 'package:sana/core/widgets/buttons/app_primary_button.dart';
import 'package:sana/core/widgets/slivers/common_sliver_app_bar.dart';
import 'package:sana/core/widgets/views/app_empty_view.dart';
import 'package:sana/core/widgets/views/app_error_view.dart';
import 'package:sana/features/azkar/domain/entities/custom_category_entity.dart';
import 'package:sana/features/azkar/presentation/cubits/custom_azkar/custom_azkar_cubit.dart';
import 'package:sana/features/azkar/presentation/cubits/custom_azkar/custom_azkar_state.dart';
import 'package:sana/features/azkar/presentation/widgets/custom_azkar_list/custom_azkar_list_section.dart';
import 'package:sana/features/azkar/presentation/widgets/custom_azkar_list/custom_azkar_list_skeleton.dart';

class CustomAzkarListView extends StatelessWidget {
  // Creates view
  const CustomAzkarListView({super.key});

  // Builds view
  @override
  Widget build(BuildContext context) => BlocProvider<CustomAzkarCubit>(
    create: (context) {
      final cubit = sl<CustomAzkarCubit>();
      unawaited(cubit.loadCustomCategories());
      return cubit;
    },
    child: Builder(
      builder: (context) => Scaffold(
        body: CustomScrollView(
          slivers: [
            // Header
            const CommonSliverAppBar(
              title: AppStrings.customAzkar,
            ),

            // Body
            BlocBuilder<CustomAzkarCubit, CustomAzkarState>(
              builder: (context, state) => switch (state) {
                CustomAzkarLoading() ||
                CustomAzkarInitial() => const CustomAzkarListSkeleton(),
                CustomAzkarError(:final message) => SliverFillRemaining(
                  hasScrollBody: false,
                  child: AppErrorView(
                    message: message,
                    onRetry: () => unawaited(
                      context.read<CustomAzkarCubit>().loadCustomCategories(),
                    ),
                  ),
                ),
                CustomAzkarEmpty() => SliverFillRemaining(
                  hasScrollBody: false,
                  child: Padding(
                    padding: AppSize.shp,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const AppEmptyView(
                          message: AppStrings.noCustomAzkarYet,
                        ),
                        AppGap.h(AppSize.p16),
                        AppPrimaryButton(
                          label: AppStrings.addCustomAzkar,
                          onPressed: () async {
                            final created = await context
                                .pushNamed<CustomCategoryEntity>(
                                  AppRoutes.customAzkarFormView,
                                );
                            if (created != null && context.mounted) {
                              unawaited(
                                context
                                    .read<CustomAzkarCubit>()
                                    .loadCustomCategories(),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                CustomAzkarLoaded(:final categories) => CustomAzkarListSection(
                  categories: categories,
                ),
              },
            ),
          ],
        ),
      ),
    ),
  );
}

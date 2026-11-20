import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/icons/app_icons.dart';
import 'package:sana/core/widgets/buttons/app_icon_button.dart';
import 'package:sana/core/widgets/buttons/app_primary_button.dart';
import 'package:sana/core/widgets/cards/app_section_card.dart';
import 'package:sana/core/widgets/headers/app_section_header.dart';
import 'package:sana/core/widgets/views/app_state_view.dart';
import 'package:sana/features/azkar/presentation/cubits/categories/azkar_categories_cubit.dart';
import 'package:sana/features/azkar/presentation/cubits/categories/azkar_categories_state.dart';
import 'package:sana/features/azkar/presentation/utils/open_custom_azkar_form.dart';
import 'package:sana/features/azkar/presentation/widgets/azkar_tasbeeh_home/azkar/azkar_categories_grid.dart';
import 'package:sana/features/azkar/presentation/widgets/azkar_tasbeeh_home/azkar/azkar_categories_skeleton.dart';

class AzkarSectionWidget extends StatelessWidget {
  const AzkarSectionWidget({super.key, this.onOptionsPressed});

  final VoidCallback? onOptionsPressed;

  Future<void> _create(BuildContext context) => OpenCustomAzkarForm.andReload(
    context,
    reload: () => context.read<AzkarCategoriesCubit>().loadCategories(),
  );

  @override
  Widget build(BuildContext context) => SliverMainAxisGroup(
    slivers: [
      SliverPadding(
        padding: AppSize.shp.copyWith(top: AppSize.p12),
        sliver: SliverToBoxAdapter(
          child: AppSectionHeader(
            title: AppStrings.azkarHeader,
            trailing: onOptionsPressed == null
                ? null
                : AppIconButton(
                    icon: AppIcons.more,
                    tooltip: AppStrings.azkarHomeOptions,
                    onPressed: onOptionsPressed,
                  ),
          ),
        ),
      ),
      BlocBuilder<AzkarCategoriesCubit, AzkarCategoriesState>(
        builder: (context, state) => switch (state) {
          AzkarCategoriesLoaded(:final categories) => AzkarCategoriesGrid(
            categories: categories,
          ),
          AzkarCategoriesEmpty() => SliverPadding(
            padding: AppSize.shp,
            sliver: SliverToBoxAdapter(
              child: AppSectionCard(
                child: AppStateView(
                  icon: AppIcons.adhkar,
                  title: AppStrings.azkarCategoriesEmpty,
                  action: AppPrimaryButton(
                    label: AppStrings.addCustomAzkar,
                    onPressed: () => unawaited(_create(context)),
                  ),
                ),
              ),
            ),
          ),
          AzkarCategoriesError(:final message) => SliverPadding(
            padding: AppSize.shp,
            sliver: SliverToBoxAdapter(
              child: AppSectionCard(
                child: AppStateView(
                  icon: AppIcons.error,
                  title: AppStrings.azkarLoadError,
                  message: message,
                  action: AppPrimaryButton(
                    label: AppStrings.tryAgain,
                    onPressed: () => unawaited(
                      context.read<AzkarCategoriesCubit>().loadCategories(),
                    ),
                  ),
                ),
              ),
            ),
          ),
          AzkarCategoriesInitial() ||
          AzkarCategoriesLoading() => const AzkarCategoriesSkeleton(),
        },
      ),
    ],
  );
}

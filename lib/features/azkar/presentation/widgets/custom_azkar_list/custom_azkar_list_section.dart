import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/widgets/app_gap.dart';
import 'package:sana/core/widgets/slivers/app_sliver_list.dart';
import 'package:sana/features/azkar/domain/entities/custom_category_entity.dart';
import 'package:sana/features/azkar/domain/extensions/custom_category_id_extension.dart';
import 'package:sana/features/azkar/presentation/cubits/custom_azkar/custom_azkar_cubit.dart';
import 'package:sana/features/azkar/presentation/utils/azkar_destructive_action.dart';
import 'package:sana/features/azkar/presentation/utils/open_custom_azkar_form.dart';
import 'package:sana/features/azkar/presentation/widgets/custom_azkar_list/custom_azkar_category_list_tile.dart';

class CustomAzkarListSection extends StatelessWidget {
  const CustomAzkarListSection({required this.categories, super.key});

  final List<CustomCategoryEntity> categories;

  Future<void> _handleDelete(
    BuildContext context,
    CustomCategoryEntity category,
  ) => AzkarDestructiveAction.run(
    context,
    title: AppStrings.deleteCustomAzkarDialogTitle,
    message: AppStrings.deleteCustomAzkarDialogMessage,
    confirmText: AppStrings.delete,
    successMessage: AppStrings.customAzkarDeletedSuccess,
    action: () => context.read<CustomAzkarCubit>().deleteCustomCategory(
      category.id,
    ),
  );

  Future<void> _handleRestore(
    BuildContext context,
    CustomCategoryEntity category,
  ) => AzkarDestructiveAction.run(
    context,
    title: AppStrings.restoreCategoryDialogTitle,
    message: AppStrings.restoreCategoryDialogMessage,
    confirmText: AppStrings.restoreOriginal,
    action: () => context.read<CustomAzkarCubit>().deleteCustomCategory(
      category.id,
    ),
  );

  Future<void> _reload(BuildContext context) async {
    await context.read<CustomAzkarCubit>().loadCustomCategories();
  }

  @override
  Widget build(BuildContext context) => SliverPadding(
    padding: AppSize.shp,
    sliver: SliverMainAxisGroup(
      slivers: [
        AppSliverList(
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            final isBuiltIn = !category.id.isCustomCategoryId;

            return Padding(
              padding: EdgeInsets.only(bottom: AppSize.p12),
              child: CustomAzkarCategoryListTile(
                category: category,
                isBuiltIn: isBuiltIn,
                onEdit: () => unawaited(
                  OpenCustomAzkarForm.andReload(
                    context,
                    category: category,
                    reload: () => _reload(context),
                  ),
                ),
                onDelete: () => unawaited(_handleDelete(context, category)),
                onRestore: () => unawaited(_handleRestore(context, category)),
              ),
            );
          },
        ),
        // Bottom breathing room; the app bar owns the create action when
        // the list is not empty.
        SliverToBoxAdapter(child: AppGap.h(AppSize.sbp)),
      ],
    ),
  );
}

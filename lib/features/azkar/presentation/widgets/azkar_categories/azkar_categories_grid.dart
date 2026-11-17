import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/error/result.dart';
import 'package:sana/core/router/app_routes.dart';
import 'package:sana/core/widgets/headers/app_section_header.dart';
import 'package:sana/core/widgets/overlays/app_bottom_sheet.dart';
import 'package:sana/core/widgets/overlays/app_toast.dart';
import 'package:sana/core/widgets/overlays/custom_confirmation_dialog.dart';
import 'package:sana/core/widgets/slivers/app_sliver_grid.dart';
import 'package:sana/features/azkar/domain/enums/azkar_category_type.dart';
import 'package:sana/features/azkar/domain/entities/azkar_category_entity.dart';
import 'package:sana/features/azkar/domain/entities/custom_category_entity.dart';
import 'package:sana/features/azkar/presentation/cubits/categories/azkar_categories_cubit.dart';
import 'package:sana/features/azkar/presentation/cubits/azkar_tasbeeh_settings/azkar_tasbeeh_settings_cubit.dart';
import 'package:sana/features/azkar/presentation/cubits/custom_azkar/custom_azkar_cubit.dart';
import 'package:sana/features/azkar/presentation/cubits/custom_azkar/custom_azkar_state.dart';
import 'package:sana/features/azkar/presentation/widgets/azkar_categories/azkar_category_card.dart';
import 'package:sana/features/azkar/presentation/widgets/azkar_categories/azkar_category_actions_bottom_sheet.dart';
import 'package:sana/features/azkar/presentation/widgets/azkar_tasbeeh_settings/azkar_tasbeeh_settings_bottom_sheet.dart';

class AzkarCategoriesGrid extends StatelessWidget {
  // Creates grid
  const AzkarCategoriesGrid({required this.categories, super.key});

  final List<AzkarCategoryEntity> categories;

  // Opens actions
  Future<void> _openActions(
    BuildContext context,
    AzkarCategoryEntity category,
  ) async {
    final action = await AppBottomSheet.show<AzkarCategoryAction>(
      context: context,
      child: AzkarCategoryActionsBottomSheet(
        isCustom: category.isCustom,
        canRestore: category.isModified,
      ),
    );

    if (!context.mounted || action == null) return;

    switch (action) {
      case AzkarCategoryAction.fontSize:
        await AppBottomSheet.show<bool>(
          context: context,
          child: AzkarTasbeehSettingsBottomSheet(
            cubit: context.read<AzkarTasbeehSettingsCubit>(),
            showBackButton: true,
          ),
        );
      case AzkarCategoryAction.edit:
        await _editCategory(context, category);
      case AzkarCategoryAction.restore:
        await _restoreCategory(context, category);
      case AzkarCategoryAction.delete:
        await _deleteCategory(context, category);
    }
  }

  // Opens edit
  Future<void> _editCategory(
    BuildContext context,
    AzkarCategoryEntity category,
  ) async {
    final result = await context
        .read<AzkarCategoriesCubit>()
        .getAzkarForCategory(category.key);
    if (!context.mounted) return;

    switch (result) {
      case Success(data: final azkar):
        final saved = await context.pushNamed<CustomCategoryEntity>(
          AppRoutes.customAzkarFormView,
          extra: CustomCategoryEntity(
            id: category.key,
            name: category.title,
            azkar: azkar,
          ),
        );
        if (saved != null && context.mounted) {
          unawaited(context.read<AzkarCategoriesCubit>().loadCategories());
        }
      case FailureResult(:final failure):
        AppToast.show(context, failure.message, type: AppToastType.error);
    }
  }

  // Deletes category
  Future<void> _deleteCategory(
    BuildContext context,
    AzkarCategoryEntity category,
  ) => _removeCategory(
    context,
    category,
    title: AppStrings.deleteCustomAzkarDialogTitle,
    message: AppStrings.deleteCustomAzkarDialogMessage,
    confirmText: AppStrings.delete,
    successMessage: AppStrings.customAzkarDeletedSuccess,
  );

  // Restores category
  Future<void> _restoreCategory(
    BuildContext context,
    AzkarCategoryEntity category,
  ) => _removeCategory(
    context,
    category,
    title: AppStrings.restoreCategoryDialogTitle,
    message: AppStrings.restoreCategoryDialogMessage,
    confirmText: AppStrings.restoreOriginal,
    successMessage: null,
  );

  // Removes category
  Future<void> _removeCategory(
    BuildContext context,
    AzkarCategoryEntity category, {
    required String title,
    required String message,
    required String confirmText,
    required String? successMessage,
  }) async {
    final confirmed = await CustomConfirmationDialog.show(
      context: context,
      title: title,
      message: message,
      confirmText: confirmText,
      cancelText: AppStrings.cancel,
    );
    if (confirmed != true || !context.mounted) return;

    final cubit = context.read<CustomAzkarCubit>();
    final result = await cubit.deleteCustomCategory(category.key);
    if (!context.mounted) return;

    if (result is FailureResult<void>) {
      final state = cubit.state;
      if (state is CustomAzkarError) {
        AppToast.show(context, state.message, type: AppToastType.error);
      }
      return;
    }

    if (successMessage case final message?) {
      AppToast.show(context, message, type: AppToastType.success);
    }
    unawaited(context.read<AzkarCategoriesCubit>().loadCategories());
  }

  // Builds grid
  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: AppSize.shp,
      sliver: SliverMainAxisGroup(
        slivers: [
          // Header
          const SliverToBoxAdapter(
            child: AppSectionHeader(
              title: AppStrings.azkarHeader,
            ),
          ),

          // Body
          AppSliverGrid.extent(
            maxCrossAxisExtent: AppSize.categoryTileMaxExtent,
            mainAxisSpacing: AppSize.p4,
            crossAxisSpacing: AppSize.p8,
            childAspectRatio: AppConstants.azkarCategoryTileAspectRatio,
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return AzkarCategoryCard(
                type: category.isCustom
                    ? null
                    : AzkarCategoryType.fromKey(category.key),
                title: category.cardTitle,
                onTap: () async {
                  await context.pushNamed(
                    AppRoutes.zikrListView,
                    pathParameters: {AppRoutes.categoryParam: category.key},
                    extra: category.title,
                  );
                  if (context.mounted) {
                    unawaited(
                      context.read<AzkarCategoriesCubit>().loadCategories(),
                    );
                  }
                },
                onLongPress: () => unawaited(_openActions(context, category)),
              );
            },
          ),
        ],
      ),
    );
  }
}

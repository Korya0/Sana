import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/router/app_routes.dart';
import 'package:sana/core/widgets/app_gap.dart';
import 'package:sana/core/widgets/buttons/app_primary_button.dart';
import 'package:sana/core/widgets/overlays/app_toast.dart';
import 'package:sana/core/widgets/overlays/custom_confirmation_dialog.dart';
import 'package:sana/core/widgets/slivers/app_sliver_list.dart';
import 'package:sana/features/azkar/data/constants/azkar_constants.dart';
import 'package:sana/features/azkar/domain/entities/custom_category_entity.dart';
import 'package:sana/features/azkar/presentation/cubits/custom_azkar/custom_azkar_cubit.dart';
import 'package:sana/features/azkar/presentation/cubits/custom_azkar/custom_azkar_state.dart';
import 'package:sana/features/azkar/presentation/widgets/custom_azkar/custom_azkar_category_list_tile.dart';

class CustomAzkarListSection extends StatelessWidget {
  // Creates section
  const CustomAzkarListSection({required this.categories, super.key});

  final List<CustomCategoryEntity> categories;

  // Deletes category
  Future<void> _handleDelete(
    BuildContext context,
    CustomCategoryEntity category,
  ) async {
    final confirmed = await CustomConfirmationDialog.show(
      context: context,
      title: AppStrings.deleteCustomAzkarDialogTitle,
      message: AppStrings.deleteCustomAzkarDialogMessage,
      confirmText: AppStrings.delete,
      cancelText: AppStrings.cancel,
    );

    if (confirmed == true && context.mounted) {
      final success = await context
          .read<CustomAzkarCubit>()
          .deleteCustomCategory(category.id);
      if (success && context.mounted) {
        AppToast.show(
          context,
          AppStrings.customAzkarDeletedSuccess,
          type: AppToastType.success,
        );
      }
    }
  }

  // Resets category
  Future<void> _handleReset(
    BuildContext context,
    CustomCategoryEntity category,
  ) async {
    final confirmed = await CustomConfirmationDialog.show(
      context: context,
      title: AppStrings.resetCategoryDialogTitle,
      message: AppStrings.resetCategoryDialogMessage,
      confirmText: AppStrings.restoreOriginal,
      cancelText: AppStrings.cancel,
    );

    if (confirmed != true || !context.mounted) return;

    final cubit = context.read<CustomAzkarCubit>();
    final success = await cubit.deleteCustomCategory(category.id);
    if (success || !context.mounted) return;

    final state = cubit.state;
    if (state is CustomAzkarError) {
      AppToast.show(context, state.message, type: AppToastType.error);
    }
  }

  // Builds section
  @override
  Widget build(BuildContext context) => SliverPadding(
    padding: AppSize.shp,
    sliver: SliverMainAxisGroup(
      slivers: [
        // Body
        // List
        AppSliverList(
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            final isBuiltIn = !category.id.startsWith(customCategoryIdPrefix);

            return Padding(
              padding: EdgeInsets.only(bottom: AppSize.p12),
              child: CustomAzkarCategoryListTile(
                category: category,
                isBuiltIn: isBuiltIn,
                onEdit: () async {
                  final updated = await context.pushNamed<CustomCategoryEntity>(
                    AppRoutes.customZikrFormPath,
                    extra: category,
                  );
                  if (updated != null && context.mounted) {
                    unawaited(
                      context.read<CustomAzkarCubit>().loadCustomCategories(),
                    );
                  }
                },
                onDelete: () => unawaited(_handleDelete(context, category)),
                onReset: () => unawaited(_handleReset(context, category)),
              ),
            );
          },
        ),

        // Add action
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppGap.h(AppSize.p8),
              AppPrimaryButton(
                label: AppStrings.addCustomAzkar,
                expand: true,
                onPressed: () async {
                  final created = await context.pushNamed<CustomCategoryEntity>(
                    AppRoutes.customZikrFormPath,
                  );
                  if (created != null && context.mounted) {
                    unawaited(
                      context.read<CustomAzkarCubit>().loadCustomCategories(),
                    );
                  }
                },
              ),
              AppGap.h(AppSize.sbp),
            ],
          ),
        ),
      ],
    ),
  );
}

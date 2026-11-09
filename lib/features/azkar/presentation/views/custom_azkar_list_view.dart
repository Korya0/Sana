import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/di/app_injector.dart';
import 'package:sana/core/router/app_routes.dart';
import 'package:sana/core/theme/colors/app_colors_common.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/icons/app_icons.dart';
import 'package:sana/core/utils/context_extension.dart';
import 'package:sana/core/widgets/app_gap.dart';
import 'package:sana/core/widgets/buttons/app_icon_button.dart';
import 'package:sana/core/widgets/buttons/app_primary_button.dart';
import 'package:sana/core/widgets/cards/app_section_card.dart';
import 'package:sana/core/widgets/interaction/app_pressable.dart';
import 'package:sana/core/widgets/overlays/app_toast.dart';
import 'package:sana/core/widgets/overlays/custom_confirmation_dialog.dart';
import 'package:sana/core/widgets/slivers/app_sliver_list.dart';
import 'package:sana/core/widgets/slivers/common_sliver_app_bar.dart';
import 'package:sana/core/widgets/views/app_empty_view.dart';
import 'package:sana/core/widgets/views/app_error_view.dart';
import 'package:sana/features/azkar/domain/entities/custom_category_entity.dart';
import 'package:sana/features/azkar/presentation/cubits/custom_azkar/custom_azkar_cubit.dart';
import 'package:sana/features/azkar/presentation/cubits/custom_azkar/custom_azkar_state.dart';

class CustomAzkarListView extends StatelessWidget {
  const CustomAzkarListView({super.key});

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
            // App bar
            const CommonSliverAppBar(
              title: AppStrings.customAzkar,
            ),

            // Body
            BlocBuilder<CustomAzkarCubit, CustomAzkarState>(
              builder: (context, state) => switch (state) {
                CustomAzkarLoading() || CustomAzkarInitial() =>
                  const SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: CircularProgressIndicator.adaptive(),
                    ),
                  ),
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
                          label: '+ ${AppStrings.createCustomZikr}',
                          onPressed: () async {
                            final created = await context.pushNamed<bool>(
                              AppRoutes.customZikrFormPath,
                            );
                            if (created == true && context.mounted) {
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
                CustomAzkarLoaded(:final categories) =>
                  _CustomAzkarListSection(categories: categories),
                CustomAzkarOperationSuccess() => const SliverToBoxAdapter(
                  child: SizedBox.shrink(),
                ),
              },
            ),
          ],
        ),
      ),
    ),
  );
}

class _CustomAzkarListSection extends StatelessWidget {
  const _CustomAzkarListSection({required this.categories});

  final List<CustomCategoryEntity> categories;

  Future<void> _handleDelete(
    BuildContext context,
    CustomCategoryEntity category,
  ) async {
    final confirmed = await CustomConfirmationDialog.show(
      context: context,
      title: AppStrings.deleteCustomZikrDialogTitle,
      message: AppStrings.deleteCustomZikrDialogMessage,
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
          AppStrings.customZikrDeletedSuccess,
          type: AppToastType.success,
        );
      }
    }
  }

  Future<void> _handleReset(
    BuildContext context,
    CustomCategoryEntity category,
  ) async {
    final confirmed = await CustomConfirmationDialog.show(
      context: context,
      title: AppStrings.resetCategoryDialogTitle,
      message: AppStrings.resetCategoryDialogMessage,
      confirmText: AppStrings.resetCategoryToDefault,
      cancelText: AppStrings.cancel,
    );

    if (confirmed == true && context.mounted) {
      final success = await context
          .read<CustomAzkarCubit>()
          .deleteCustomCategory(category.id);
      if (success && context.mounted) {
        AppToast.show(
          context,
          AppStrings.resetCategorySuccess,
          type: AppToastType.success,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) => SliverPadding(
    padding: AppSize.shp,
    sliver: SliverMainAxisGroup(
      slivers: [
        // List of tiles
        AppSliverList(
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            final isBuiltIn = !category.id.startsWith('custom_');

            return Padding(
              padding: EdgeInsets.only(bottom: AppSize.p12),
              child: _CustomCategoryTile(
                category: category,
                isBuiltIn: isBuiltIn,
                onTap: () async {
                  await context.pushNamed(
                    AppRoutes.azkarCategoryPath,
                    pathParameters: {
                      AppRoutes.categoryKeyParam: category.id,
                    },
                    extra: category.name,
                  );
                  if (context.mounted) {
                    unawaited(
                      context.read<CustomAzkarCubit>().loadCustomCategories(),
                    );
                  }
                },
                onEdit: () async {
                  final updated = await context.pushNamed<bool>(
                    AppRoutes.customZikrFormPath,
                    extra: category,
                  );
                  if (updated == true && context.mounted) {
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

        // Add button under list
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppGap.h(AppSize.p8),
              AppPrimaryButton(
                label: '+ ${AppStrings.createCustomZikr}',
                expand: true,
                onPressed: () async {
                  final created = await context.pushNamed<bool>(
                    AppRoutes.customZikrFormPath,
                  );
                  if (created == true && context.mounted) {
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

class _CustomCategoryTile extends StatelessWidget {
  const _CustomCategoryTile({
    required this.category,
    required this.isBuiltIn,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
    required this.onReset,
  });

  final CustomCategoryEntity category;
  final bool isBuiltIn;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) => AppSectionCard(
    padding: EdgeInsets.zero,
    child: AppPressable(
      onPressed: onTap,
      child: Padding(
        padding: EdgeInsets.all(AppSize.p16),
        child: Row(
          children: [
            // Leading icon
            Container(
              width: AppSize.w40,
              height: AppSize.h40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: context.color.primary.withValues(
                  alpha: AppConstants.opacitySubtle,
                ),
                border: Border.all(
                  color: context.color.borderBrand.withValues(
                    alpha: AppConstants.opacityMuted,
                  ),
                  width: AppSize.borderWidth,
                ),
              ),
              child: Center(
                child: Icon(
                  AppIcons.adhkar,
                  size: AppSize.icon24,
                  color: context.color.iconBrand,
                ),
              ),
            ),
            AppGap.w(AppSize.p12),

            // Name + count
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category.name,
                    maxLines: AppConstants.maxOneLine,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.font16W700Primary(context),
                  ),
                  AppGap.h(AppSize.p4),
                  Text(
                    AppStrings.azkarCountLabel(category.azkar.length),
                    maxLines: AppConstants.maxOneLine,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.font12W500Secondary(context),
                  ),
                ],
              ),
            ),
            AppGap.w(AppSize.p8),

            // Edit button (only for user-created custom categories)
            if (!isBuiltIn)
              AppIconButton(
                icon: AppIcons.edit,
                tooltip: AppStrings.editCustomZikr,
                onPressed: onEdit,
              ),

            // Delete or Reset button
            if (isBuiltIn)
              AppIconButton(
                icon: AppIcons.refresh,
                tooltip: AppStrings.resetCategoryToDefault,
                onPressed: onReset,
              )
            else
              AppIconButton(
                icon: AppIcons.delete,
                color: AppColorsCommon.errorColor,
                tooltip: AppStrings.deleteCustomZikrDialogTitle,
                onPressed: onDelete,
              ),
          ],
        ),
      ),
    ),
  );
}

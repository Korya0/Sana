import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/error/result.dart';
import 'package:sana/core/router/app_routes.dart';
import 'package:sana/core/utils/context_extension.dart';
import 'package:sana/core/widgets/overlays/app_bottom_sheet.dart';
import 'package:sana/core/widgets/overlays/app_toast.dart';
import 'package:sana/core/widgets/slivers/app_sliver_grid.dart';
import 'package:sana/features/azkar/domain/enums/azkar_category_type.dart';
import 'package:sana/features/azkar/domain/entities/azkar_category_entity.dart';
import 'package:sana/features/azkar/domain/entities/custom_category_entity.dart';
import 'package:sana/features/azkar/presentation/cubits/categories/azkar_categories_cubit.dart';
import 'package:sana/features/azkar/presentation/cubits/custom_azkar/custom_azkar_cubit.dart';
import 'package:sana/features/azkar/presentation/utils/azkar_destructive_action.dart';
import 'package:sana/features/azkar/presentation/utils/azkar_settings_flow.dart';
import 'package:sana/features/azkar/presentation/utils/open_custom_azkar_form.dart';
import 'package:sana/features/azkar/presentation/widgets/azkar_tasbeeh_home/azkar/azkar_category_card.dart';
import 'package:sana/features/azkar/presentation/widgets/common/azkar_category_actions_bottom_sheet.dart';

class AzkarCategoriesGrid extends StatefulWidget {
  const AzkarCategoriesGrid({
    required this.categories,
    super.key,
    this.animate = true,
  });

  final List<AzkarCategoryEntity> categories;
  final bool animate;

  @override
  State<AzkarCategoriesGrid> createState() => _AzkarCategoriesGridState();
}

class _AzkarCategoriesGridState extends State<AzkarCategoriesGrid>
    with SingleTickerProviderStateMixin {
  static const _staggerMs = 40;
  static const _fadeMs = 200;

  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: _fadeMs + _staggerMs * widget.categories.length,
      ),
    );
    if (widget.animate) {
      unawaited(_controller.forward());
    } else {
      _controller.value = 1;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (context.reduceMotion) _controller.value = 1;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _staggered(int index, Widget child) => AnimatedBuilder(
    animation: _controller,
    builder: (context, child) {
      final elapsed = _controller.value * _controller.duration!.inMilliseconds;
      final t = ((elapsed - index * _staggerMs) / _fadeMs).clamp(0.0, 1.0);
      final eased = Curves.easeOut.transform(t);
      return Opacity(
        key: ValueKey('azkar_tile_fade_$index'),
        opacity: eased,
        child: Transform.translate(
          offset: Offset(0, (1 - eased) * AppSize.p8),
          child: child,
        ),
      );
    },
    child: child,
  );

  @override
  Widget build(BuildContext context) => AppSliverGrid.extent(
    maxCrossAxisExtent: AppSize.categoryTileMaxExtent,
    mainAxisSpacing: AppSize.p12,
    crossAxisSpacing: AppSize.p8,
    childAspectRatio: AppConstants.azkarCategoryTileAspectRatio,
    itemCount: widget.categories.length,
    itemBuilder: (context, index) {
      final category = widget.categories[index];
      return _staggered(
        index,
        AzkarCategoryCard(
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
              unawaited(context.read<AzkarCategoriesCubit>().loadCategories());
            }
          },
          onLongPress: () => unawaited(_openActions(context, category)),
        ),
      );
    },
  );

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
        await AzkarSettingsFlow.openWithGoBack(
          context,
          reopenOptions: () => _openActions(context, category),
        );
      case AzkarCategoryAction.edit:
        await _editCategory(context, category);
      case AzkarCategoryAction.restore:
        await _restoreCategory(context, category);
      case AzkarCategoryAction.delete:
        await _deleteCategory(context, category);
    }
  }

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
        await OpenCustomAzkarForm.andReload(
          context,
          category: CustomCategoryEntity(
            id: category.key,
            name: category.title,
            azkar: azkar,
          ),
          reload: () async {
            await context.read<AzkarCategoriesCubit>().loadCategories();
          },
        );
      case FailureResult(:final failure):
        AppToast.show(context, failure.message, type: AppToastType.error);
    }
  }

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

  Future<void> _removeCategory(
    BuildContext context,
    AzkarCategoryEntity category, {
    required String title,
    required String message,
    required String confirmText,
    required String? successMessage,
  }) async {
    final succeeded = await AzkarDestructiveAction.run(
      context,
      title: title,
      message: message,
      confirmText: confirmText,
      successMessage: successMessage,
      action: () => context
          .read<CustomAzkarCubit>()
          .deleteCustomCategory(category.key),
    );
    if (succeeded && context.mounted) {
      unawaited(context.read<AzkarCategoriesCubit>().loadCategories());
    }
  }
}


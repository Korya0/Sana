import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/di/app_injector.dart';
import 'package:sana/core/error/result.dart';
import 'package:sana/core/router/app_routes.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/icons/app_icons.dart';
import 'package:sana/core/utils/context_extension.dart';
import 'package:sana/core/widgets/app_gap.dart';
import 'package:sana/core/widgets/buttons/app_primary_button.dart';
import 'package:sana/core/widgets/headers/app_section_header.dart';
import 'package:sana/core/widgets/interaction/app_pressable.dart';
import 'package:sana/core/widgets/overlays/app_bottom_sheet.dart';
import 'package:sana/core/widgets/overlays/app_toast.dart';
import 'package:sana/core/widgets/overlays/custom_confirmation_dialog.dart';
import 'package:sana/features/azkar/domain/entities/tasbeeh_item_entity.dart';
import 'package:sana/features/azkar/presentation/cubits/tasbeeh/tasbeeh_cubit.dart';
import 'package:sana/features/azkar/presentation/cubits/tasbeeh/tasbeeh_state.dart';
import 'package:sana/features/azkar/presentation/cubits/reading_settings/reading_settings_cubit.dart';
import 'package:sana/features/azkar/presentation/widgets/reading_settings/reading_settings_bottom_sheet.dart';
import 'package:sana/features/azkar/presentation/widgets/tasbeeh/tasbeeh_counter_widgets.dart';
import 'package:sana/features/azkar/presentation/widgets/tasbeeh/tasbeeh_item_form_bottom_sheet.dart';
import 'package:sana/features/azkar/presentation/widgets/tasbeeh/tasbeeh_options_bottom_sheet.dart';
import 'package:sana/features/azkar/presentation/widgets/tasbeeh/tasbeeh_preset_grid.dart';

class TasbeehHomeCard extends StatelessWidget {
  // Creates card
  const TasbeehHomeCard({super.key});

  // Opens add
  Future<void> _openAdd(BuildContext context, TasbeehCubit cubit) async {
    final result = await AppBottomSheet.show<({String text, int? targetCount})>(
      context: context,
      enableDrag: false,
      child: const TasbeehItemFormBottomSheet(),
    );
    if (result == null || !context.mounted) return;

    final saveResult = await cubit.addItem(
      text: result.text,
      targetCount: result.targetCount,
    );
    if (!context.mounted) return;
    if (saveResult case FailureResult(:final failure)) {
      AppToast.show(context, failure.message, type: AppToastType.error);
      return;
    }

    await _openScreen(context, cubit, selectedId: _selectedId(cubit));
  }

  // Adds preset
  Future<void> _addPreset(
    BuildContext context,
    TasbeehCubit cubit,
    String text,
  ) async {
    final result = await cubit.addItem(text: text);
    if (!context.mounted) return;
    if (result case FailureResult(:final failure)) {
      AppToast.show(context, failure.message, type: AppToastType.error);
      return;
    }

    await _openScreen(context, cubit, selectedId: _selectedId(cubit));
  }

  // Opens screen
  Future<void> _openScreen(
    BuildContext context,
    TasbeehCubit cubit, {
    String? selectedId,
  }) async {
    await context.pushNamed(AppRoutes.tasbeehPath, extra: selectedId);
    if (context.mounted) {
      unawaited(cubit.loadItems());
    }
  }

  // Opens all
  Future<void> _openAll(BuildContext context, TasbeehCubit cubit) async {
    final state = cubit.state;
    if (state is! TasbeehLoaded) return;

    final result = await AppBottomSheet.show<TasbeehManagerResult>(
      context: context,
      child: TasbeehOptionsBottomSheet(
        items: state.items,
        selectedId: state.selectedId,
        readingSettingsCubit: context.read<ReadingSettingsCubit>(),
      ),
    );
    if (result == null || !context.mounted) return;

    switch (result.action) {
      case TasbeehManagerAction.fontSize:
        await _openReadingSettings(context, cubit);
      case TasbeehManagerAction.create:
        await _openAdd(context, cubit);
      case TasbeehManagerAction.select:
        final id = result.itemId;
        if (id != null) await _openScreen(context, cubit, selectedId: id);
      case TasbeehManagerAction.edit:
        final id = result.itemId;
        if (id == null) return;
        final item = _findItem(state.items, id);
        if (item != null) await _editItem(context, cubit, item);
      case TasbeehManagerAction.delete:
        final id = result.itemId;
        if (id == null) return;
        final item = _findItem(state.items, id);
        if (item != null) await _deleteItem(context, cubit, item);
    }
  }

  // Opens settings
  Future<void> _openReadingSettings(
    BuildContext context,
    TasbeehCubit cubit,
  ) async {
    final goBack = await AppBottomSheet.show<bool>(
      context: context,
      child: ReadingSettingsBottomSheet(
        cubit: context.read<ReadingSettingsCubit>(),
        showBackButton: true,
      ),
    );

    if (goBack != true || !context.mounted) return;
    await _openAll(context, cubit);
  }

  // Finds item
  TasbeehItemEntity? _findItem(List<TasbeehItemEntity> items, String id) {
    for (final item in items) {
      if (item.id == id) return item;
    }
    return null;
  }

  // Edits item
  Future<void> _editItem(
    BuildContext context,
    TasbeehCubit cubit,
    TasbeehItemEntity item,
  ) async {
    final result = await AppBottomSheet.show<({String text, int? targetCount})>(
      context: context,
      enableDrag: false,
      child: TasbeehItemFormBottomSheet(initialItem: item),
    );
    if (result == null || !context.mounted) return;

    final saveResult = await cubit.updateItem(
      id: item.id,
      text: result.text,
      targetCount: () => result.targetCount,
    );
    if (!context.mounted) return;
    if (saveResult case FailureResult(:final failure)) {
      AppToast.show(context, failure.message, type: AppToastType.error);
    }
  }

  // Deletes item
  Future<void> _deleteItem(
    BuildContext context,
    TasbeehCubit cubit,
    TasbeehItemEntity item,
  ) async {
    final confirmed = await CustomConfirmationDialog.show(
      context: context,
      title: AppStrings.deleteTasbeehDialogTitle,
      message: AppStrings.deleteTasbeehDialogMessage,
      confirmText: AppStrings.delete,
      cancelText: AppStrings.cancel,
    );
    if (confirmed != true || !context.mounted) return;

    final result = await cubit.deleteItem(item.id);
    if (!context.mounted) return;
    if (result case FailureResult(:final failure)) {
      AppToast.show(context, failure.message, type: AppToastType.error);
    }
  }

  // Reads selected id
  String? _selectedId(TasbeehCubit cubit) {
    final state = cubit.state;
    return state is TasbeehLoaded ? state.selectedId : null;
  }

  // Builds card
  @override
  Widget build(BuildContext context) => BlocProvider<TasbeehCubit>(
    create: (context) {
      final cubit = sl<TasbeehCubit>();
      unawaited(cubit.loadItems());
      return cubit;
    },
    child: SliverPadding(
      padding: EdgeInsets.fromLTRB(
        AppSize.p16,
        AppSize.p8,
        AppSize.p16,
        AppSize.p16,
      ),
      sliver: SliverMainAxisGroup(
        slivers: [
          // Header
          const SliverToBoxAdapter(
            child: AppSectionHeader(title: AppStrings.tasbeehTitle),
          ),

          // Body
          SliverToBoxAdapter(
            child: BlocBuilder<TasbeehCubit, TasbeehState>(
              builder: (context, state) {
                final cubit = context.read<TasbeehCubit>();
                final recentItem = state is TasbeehLoaded && state.items.isNotEmpty
                    ? state.recentItems.first
                    : null;

                return switch (state) {
                  TasbeehLoaded() when recentItem == null => TasbeehPresetGrid(
                    onSelect: (text) =>
                        unawaited(_addPreset(context, cubit, text)),
                    onCustomPressed: () => unawaited(_openAdd(context, cubit)),
                  ),
                  TasbeehLoaded() => _TasbeehRecentItem(
                    item: recentItem!,
                    onContinue: () => unawaited(
                      _openScreen(context, cubit, selectedId: recentItem.id),
                    ),
                    onOpenAll: () => unawaited(_openAll(context, cubit)),
                  ),
                  TasbeehError() => AppPrimaryButton(
                    label: AppStrings.tryAgain,
                    onPressed: () => unawaited(cubit.loadItems()),
                  ),
                  TasbeehInitial() || TasbeehLoading() => SizedBox(
                    height: AppSize.h56,
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                };
              },
            ),
          ),
        ],
      ),
    ),
  );
}

class _TasbeehRecentItem extends StatelessWidget {
  // Creates recent item
  const _TasbeehRecentItem({
    required this.item,
    required this.onContinue,
    required this.onOpenAll,
  });

  final TasbeehItemEntity item;
  final VoidCallback onContinue;
  final VoidCallback onOpenAll;

  // Builds recent item
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      // Recent
      AppPressable(
        onPressed: onContinue,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: AppSize.p8),
          child: Row(
            children: [
              // Counter
              TasbeehCounter(
                currentCount: item.currentCount,
                targetCount: item.targetCount,
                dimension: AppSize.h48,
                strokeWidth: AppSize.progressStrokeWidth,
                numberStyle: AppTextStyles.font14W700Brand(context),
              ),
              AppGap.w(AppSize.p12),

              // Name
              Expanded(
                child: Text(
                  item.text,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.start,
                  style: AppTextStyles.font14W700Primary(context),
                ),
              ),
            ],
          ),
        ),
      ),
      AppGap.h(AppSize.p12),

      // Actions
      Row(
        children: [
          Expanded(
            child: _ActionButton(
              label: AppStrings.continueTasbeeh,
              icon: AppIcons.next,
              onPressed: onContinue,
            ),
          ),
          AppGap.w(AppSize.p8),
          Expanded(
            child: _ActionButton(
              label: AppStrings.allTasbeeh,
              icon: AppIcons.list,
              onPressed: onOpenAll,
            ),
          ),
        ],
      ),
    ],
  );
}

class _ActionButton extends StatelessWidget {
  // Creates button
  const _ActionButton({
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  // Builds button
  @override
  Widget build(BuildContext context) => AppPressable(
    onPressed: onPressed,
    child: Padding(
      padding: EdgeInsets.symmetric(vertical: AppSize.p8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon
          Icon(
            icon,
            size: AppSize.icon16,
            color: context.color.iconBrand,
          ),
          AppGap.w(AppSize.p4),

          // Label
          Flexible(
            child: Text(
              label,
              maxLines: AppConstants.maxOneLine,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.font12W700Brand(context),
            ),
          ),
        ],
      ),
    ),
  );
}

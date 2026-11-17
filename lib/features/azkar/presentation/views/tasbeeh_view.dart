import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/di/app_injector.dart';
import 'package:sana/core/error/result.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/icons/app_icons.dart';
import 'package:sana/core/utils/context_extension.dart';
import 'package:sana/core/widgets/app_gap.dart';
import 'package:sana/core/widgets/buttons/app_icon_button.dart';
import 'package:sana/core/widgets/interaction/app_pressable.dart';
import 'package:sana/core/widgets/overlays/app_bottom_sheet.dart';
import 'package:sana/core/widgets/overlays/app_toast.dart';
import 'package:sana/core/widgets/overlays/custom_confirmation_dialog.dart';
import 'package:sana/core/widgets/slivers/common_sliver_app_bar.dart';
import 'package:sana/core/widgets/views/app_error_view.dart';
import 'package:sana/features/azkar/domain/entities/tasbeeh_item_entity.dart';
import 'package:sana/features/azkar/presentation/cubits/azkar_tasbeeh_settings/azkar_tasbeeh_settings_cubit.dart';
import 'package:sana/features/azkar/presentation/cubits/tasbeeh/tasbeeh_cubit.dart';
import 'package:sana/features/azkar/presentation/cubits/tasbeeh/tasbeeh_state.dart';
import 'package:sana/features/azkar/presentation/widgets/tasbeeh/tasbeeh_counter_content.dart';
import 'package:sana/features/azkar/presentation/widgets/common/azkar_tasbeeh_settings_bottom_sheet.dart';
import 'package:sana/features/azkar/presentation/widgets/common/tasbeeh_item_form_bottom_sheet.dart';
import 'package:sana/features/azkar/presentation/widgets/common/tasbeeh_options_bottom_sheet.dart';
import 'package:sana/features/azkar/presentation/widgets/common/tasbeeh_preset_grid.dart';
import 'package:sana/features/azkar/presentation/widgets/tasbeeh/tasbeeh_preset_grid_skeleton.dart';

class TasbeehView extends StatelessWidget {
  // Creates view
  const TasbeehView({super.key, this.initialSelectedItemId});

  final String? initialSelectedItemId;

  // Opens add
  Future<void> _openAdd(BuildContext context) async {
    final result = await AppBottomSheet.show<({String text, int? targetCount})>(
      context: context,
      enableDrag: false,
      child: const TasbeehItemFormBottomSheet(),
    );
    if (result == null || !context.mounted) return;

    final saveResult = await context.read<TasbeehCubit>().addItem(
      text: result.text,
      targetCount: result.targetCount,
    );
    if (!context.mounted) return;
    if (saveResult case FailureResult(:final failure)) {
      AppToast.show(context, failure.message, type: AppToastType.error);
    }
  }

  // Adds preset
  Future<void> _addPreset(BuildContext context, String text) async {
    final result = await context.read<TasbeehCubit>().addItem(text: text);
    if (!context.mounted) return;
    if (result case FailureResult(:final failure)) {
      AppToast.show(context, failure.message, type: AppToastType.error);
    }
  }

  // Opens options
  Future<void> _openOptions(BuildContext context) async {
    final state = context.read<TasbeehCubit>().state;
    if (state is! TasbeehLoaded) {
      await _openAdd(context);
      return;
    }

    final result = await AppBottomSheet.show<TasbeehOptionResult>(
      context: context,
      child: TasbeehOptionsBottomSheet(
        items: state.items,
        selectedItemId: state.selectedItemId,
        azkarTasbeehSettingsCubit: context.read<AzkarTasbeehSettingsCubit>(),
      ),
    );
    if (result == null || !context.mounted) return;

    switch (result.action) {
      case TasbeehOption.fontSize:
        await _openAzkarTasbeehSettings(context);
      case TasbeehOption.create:
        await _openAdd(context);
      case TasbeehOption.select:
        final id = result.selectedItemId;
        if (id != null) context.read<TasbeehCubit>().selectItem(id);
      case TasbeehOption.edit:
        final id = result.selectedItemId;
        if (id == null) return;
        final item = _findItem(state.items, id);
        if (item != null) await _editItem(context, item);
      case TasbeehOption.delete:
        final id = result.selectedItemId;
        if (id == null) return;
        final item = _findItem(state.items, id);
        if (item != null) await _deleteTasbeehItem(context, item);
    }
  }

  // Opens settings
  Future<void> _openAzkarTasbeehSettings(BuildContext context) async {
    final goBack = await AppBottomSheet.show<bool>(
      context: context,
      child: AzkarTasbeehSettingsBottomSheet(
        cubit: context.read<AzkarTasbeehSettingsCubit>(),
        showBackButton: true,
      ),
    );

    if (goBack != true || !context.mounted) return;
    await _openOptions(context);
  }

  // Finds item
  TasbeehItemEntity? _findItem(List<TasbeehItemEntity> items, String id) {
    for (final item in items) {
      if (item.id == id) return item;
    }
    return null;
  }

  // Edits item
  Future<void> _editItem(BuildContext context, TasbeehItemEntity item) async {
    final result = await AppBottomSheet.show<({String text, int? targetCount})>(
      context: context,
      enableDrag: false,
      child: TasbeehItemFormBottomSheet(initialItem: item),
    );
    if (result == null || !context.mounted) return;

    final saveResult = await context.read<TasbeehCubit>().updateItem(
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
  Future<void> _deleteTasbeehItem(
    BuildContext context,
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

    final result = await context.read<TasbeehCubit>().deleteTasbeehItem(
      item.id,
    );
    if (!context.mounted) return;
    if (result case FailureResult(:final failure)) {
      AppToast.show(context, failure.message, type: AppToastType.error);
    }
  }

  // Builds view
  @override
  Widget build(BuildContext context) => MultiBlocProvider(
    providers: [
      BlocProvider<TasbeehCubit>(
        create: (context) {
          final cubit = sl<TasbeehCubit>();
          unawaited(cubit.loadItems(selectedItemId: initialSelectedItemId));
          return cubit;
        },
      ),
      BlocProvider<AzkarTasbeehSettingsCubit>(
        create: (context) {
          final cubit = sl<AzkarTasbeehSettingsCubit>();
          unawaited(cubit.loadSettings());
          return cubit;
        },
      ),
    ],
    child: Builder(
      builder: (context) => Scaffold(
        body: CustomScrollView(
          slivers: [
            // Header
            CommonSliverAppBar(
              title: AppStrings.tasbeehTitle,
              isPinned: true,
              actions: [
                AppIconButton(
                  icon: AppIcons.tuning,
                  tooltip: AppStrings.tasbeehOptions,
                  onPressed: () => unawaited(_openOptions(context)),
                ),
              ],
            ),

            // Body
            BlocBuilder<TasbeehCubit, TasbeehState>(
              builder: (context, state) => switch (state) {
                TasbeehLoaded(:final items, :final selectedItemId)
                    when items.isNotEmpty =>
                  _TasbeehLoadedBody(
                    items: items,
                    selectedItemId: selectedItemId,
                  ),
                TasbeehLoaded() => SliverFillRemaining(
                  hasScrollBody: true,
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(AppSize.p16),
                    child: TasbeehPresetGrid(
                      onSelect: (text) => unawaited(_addPreset(context, text)),
                      onCustomTap: () => unawaited(_openAdd(context)),
                    ),
                  ),
                ),
                TasbeehError(:final message) => SliverFillRemaining(
                  hasScrollBody: false,
                  child: AppErrorView(
                    message: message,
                    onRetry: () =>
                        unawaited(context.read<TasbeehCubit>().loadItems()),
                  ),
                ),
                TasbeehInitial() ||
                TasbeehLoading() => const SliverFillRemaining(
                  hasScrollBody: true,
                  child: TasbeehPresetGridSkeleton(),
                ),
              },
            ),
          ],
        ),
      ),
    ),
  );
}

class _TasbeehLoadedBody extends StatelessWidget {
  // Creates body
  const _TasbeehLoadedBody({required this.items, required this.selectedItemId});

  final List<TasbeehItemEntity> items;
  final String? selectedItemId;

  // Builds body
  @override
  Widget build(BuildContext context) {
    final loaded = TasbeehLoaded(items: items, selectedItemId: selectedItemId);
    final selected = loaded.selectedItem ?? items.first;
    final previous = loaded.previousItem;
    final next = loaded.nextItem;
    final canReset = loaded.canResetSelected;

    return SliverFillRemaining(
      hasScrollBody: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          AppSize.p16,
          AppSize.p8,
          AppSize.p16,
          AppSize.p16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Navigation
            Directionality(
              textDirection: TextDirection.ltr,
              child: Row(
                children: [
                  Expanded(
                    child: _TasbeehNeighborButton(
                      text: previous?.text ?? AppStrings.previousTasbeeh,
                      icon: Icons.chevron_left_rounded,
                      onPressed: previous == null
                          ? null
                          : () => context.read<TasbeehCubit>().selectItem(
                              previous.id,
                            ),
                    ),
                  ),

                  // Reset
                  AppIconButton(
                    icon: AppIcons.refresh,
                    tooltip: AppStrings.resetCounter,
                    color: canReset
                        ? context.color.iconBrand
                        : context.color.iconDisabled,
                    onPressed: canReset
                        ? () => unawaited(
                            context.read<TasbeehCubit>().resetCounter(
                              selected.id,
                            ),
                          )
                        : null,
                  ),

                  Expanded(
                    child: _TasbeehNeighborButton(
                      text: next?.text ?? AppStrings.nextTasbeeh,
                      icon: Icons.chevron_right_rounded,
                      isNext: true,
                      onPressed: next == null
                          ? null
                          : () => context.read<TasbeehCubit>().selectItem(
                              next.id,
                            ),
                    ),
                  ),
                ],
              ),
            ),
            AppGap.h(AppSize.p24),

            // Counter
            Expanded(
              child: TasbeehCounterContent(item: selected),
            ),
          ],
        ),
      ),
    );
  }
}

class _TasbeehNeighborButton extends StatelessWidget {
  // Creates button
  const _TasbeehNeighborButton({
    required this.text,
    required this.icon,
    required this.onPressed,
    this.isNext = false,
  });

  final String text;
  final IconData icon;
  final VoidCallback? onPressed;
  final bool isNext;

  // Builds button
  @override
  Widget build(BuildContext context) => AppPressable(
    onPressed: onPressed,
    child: Padding(
      padding: EdgeInsets.symmetric(vertical: AppSize.p8),
      child: Row(
        mainAxisAlignment: isNext
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          if (!isNext) ...[
            // Arrow
            Icon(
              icon,
              size: AppSize.icon24,
              color: onPressed == null
                  ? context.color.iconDisabled
                  : context.color.iconBrand,
            ),
            AppGap.w(AppSize.p4),
          ],

          // Name
          Flexible(
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: isNext ? TextAlign.end : TextAlign.start,
              style: onPressed == null
                  ? AppTextStyles.font12W500Secondary(context)
                  : AppTextStyles.font14W700Primary(context),
            ),
          ),
          if (isNext) ...[
            AppGap.w(AppSize.p4),

            // Arrow
            Icon(
              icon,
              size: AppSize.icon24,
              color: onPressed == null
                  ? context.color.iconDisabled
                  : context.color.iconBrand,
            ),
          ],
        ],
      ),
    ),
  );
}

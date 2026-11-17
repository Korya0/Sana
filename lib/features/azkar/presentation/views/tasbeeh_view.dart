import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/di/app_injector.dart';
import 'package:sana/core/error/result.dart';
import 'package:sana/core/theme/icons/app_icons.dart';
import 'package:sana/core/widgets/buttons/app_icon_button.dart';
import 'package:sana/core/widgets/overlays/app_bottom_sheet.dart';
import 'package:sana/core/widgets/overlays/app_toast.dart';
import 'package:sana/core/widgets/slivers/common_sliver_app_bar.dart';
import 'package:sana/core/widgets/views/app_error_view.dart';
import 'package:sana/features/azkar/domain/entities/tasbeeh_item_entity.dart';
import 'package:sana/features/azkar/domain/extensions/tasbeeh_item_list_extensions.dart';
import 'package:sana/features/azkar/presentation/cubits/azkar_tasbeeh_settings/azkar_tasbeeh_settings_cubit.dart';
import 'package:sana/features/azkar/presentation/cubits/tasbeeh/tasbeeh_cubit.dart';
import 'package:sana/features/azkar/presentation/cubits/tasbeeh/tasbeeh_state.dart';
import 'package:sana/features/azkar/presentation/utils/azkar_destructive_action.dart';
import 'package:sana/features/azkar/presentation/utils/azkar_settings_flow.dart';
import 'package:sana/features/azkar/presentation/widgets/common/tasbeeh_item_form_bottom_sheet.dart';
import 'package:sana/features/azkar/presentation/widgets/common/tasbeeh_options_bottom_sheet.dart';
import 'package:sana/features/azkar/presentation/widgets/common/tasbeeh_preset_grid.dart';
import 'package:sana/features/azkar/presentation/widgets/tasbeeh/tasbeeh_loaded_body.dart';
import 'package:sana/features/azkar/presentation/widgets/tasbeeh/tasbeeh_preset_grid_skeleton.dart';

class TasbeehView extends StatelessWidget {
  const TasbeehView({super.key, this.initialSelectedItemId});

  final String? initialSelectedItemId;

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

  Future<void> _addPreset(BuildContext context, String text) async {
    final result = await context.read<TasbeehCubit>().addItem(text: text);
    if (!context.mounted) return;
    if (result case FailureResult(:final failure)) {
      AppToast.show(context, failure.message, type: AppToastType.error);
    }
  }

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
        await AzkarSettingsFlow.openWithGoBack(
          context,
          reopenOptions: () => _openOptions(context),
        );
      case TasbeehOption.create:
        await _openAdd(context);
      case TasbeehOption.select:
        final id = result.selectedItemId;
        if (id != null) context.read<TasbeehCubit>().selectItem(id);
      case TasbeehOption.edit:
      case TasbeehOption.delete:
        final id = result.selectedItemId;
        if (id == null) return;
        final fresh = context.read<TasbeehCubit>().state;
        if (fresh is! TasbeehLoaded) return;
        final item = fresh.items.byId(id);
        if (item == null) return;
        if (result.action == TasbeehOption.edit) {
          await _editItem(context, item);
        } else {
          await _deleteTasbeehItem(context, item);
        }
    }
  }

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

  Future<void> _deleteTasbeehItem(
    BuildContext context,
    TasbeehItemEntity item,
  ) async {
    await AzkarDestructiveAction.run(
      context,
      title: AppStrings.deleteTasbeehDialogTitle,
      message: AppStrings.deleteTasbeehDialogMessage,
      confirmText: AppStrings.delete,
      action: () => context.read<TasbeehCubit>().deleteTasbeehItem(item.id),
    );
  }

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
            CommonSliverAppBar(
              title: AppStrings.tasbeehTitle,
              isPinned: true,
              actions: [
                // Options action
                AppIconButton(
                  icon: AppIcons.tuning,
                  tooltip: AppStrings.tasbeehOptions,
                  onPressed: () => unawaited(_openOptions(context)),
                ),
              ],
            ),
            BlocBuilder<TasbeehCubit, TasbeehState>(
              builder: (context, state) => switch (state) {
                TasbeehLoaded(
                  :final items,
                  :final selectedItem,
                  :final previousItem,
                  :final nextItem,
                  :final canResetSelected,
                )
                    when items.isNotEmpty && selectedItem != null =>
                  TasbeehLoadedBody(
                    selectedItem: selectedItem,
                    previousItem: previousItem,
                    nextItem: nextItem,
                    canReset: canResetSelected,
                    onSelect: (id) =>
                        context.read<TasbeehCubit>().selectItem(id),
                    onReset: () => unawaited(
                      context.read<TasbeehCubit>().resetCounter(selectedItem.id),
                    ),
                  ),
                TasbeehLoaded() => SliverPadding(
                  padding: AppSize.shp,
                  sliver: SliverToBoxAdapter(
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

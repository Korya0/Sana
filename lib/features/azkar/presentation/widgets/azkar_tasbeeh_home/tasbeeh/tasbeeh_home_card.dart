import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/di/app_injector.dart';
import 'package:sana/core/error/result.dart';
import 'package:sana/core/router/app_routes.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/icons/app_icons.dart';
import 'package:sana/core/widgets/app_gap.dart';
import 'package:sana/core/widgets/buttons/app_primary_button.dart';
import 'package:sana/core/widgets/cards/app_section_card.dart';
import 'package:sana/core/widgets/views/app_state_view.dart';
import 'package:sana/core/widgets/overlays/app_bottom_sheet.dart';
import 'package:sana/core/widgets/overlays/app_toast.dart';
import 'package:sana/features/azkar/domain/entities/tasbeeh_item_entity.dart';
import 'package:sana/features/azkar/domain/extensions/tasbeeh_item_list_extensions.dart';
import 'package:sana/features/azkar/presentation/cubits/azkar_tasbeeh_settings/azkar_tasbeeh_settings_cubit.dart';
import 'package:sana/features/azkar/presentation/cubits/tasbeeh/tasbeeh_cubit.dart';
import 'package:sana/features/azkar/presentation/cubits/tasbeeh/tasbeeh_state.dart';
import 'package:sana/features/azkar/presentation/utils/azkar_destructive_action.dart';
import 'package:sana/features/azkar/presentation/utils/azkar_settings_flow.dart';
import 'package:sana/features/azkar/presentation/widgets/azkar_tasbeeh_home/tasbeeh/tasbeeh_recent_item.dart';
import 'package:sana/features/azkar/presentation/widgets/common/tasbeeh_item_form_bottom_sheet.dart';
import 'package:sana/features/azkar/presentation/widgets/common/tasbeeh_options_bottom_sheet.dart';
import 'package:sana/features/azkar/presentation/widgets/common/tasbeeh_preset_grid.dart';
import 'package:sana/features/azkar/presentation/widgets/tasbeeh/tasbeeh_preset_grid_skeleton.dart';

class TasbeehHomeCard extends StatelessWidget {
  const TasbeehHomeCard({super.key});

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

    await _openScreen(context, cubit, selectedItemId: _selectedItemId(cubit));
  }

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

    await _openScreen(context, cubit, selectedItemId: _selectedItemId(cubit));
  }

  Future<void> _openScreen(
    BuildContext context,
    TasbeehCubit cubit, {
    String? selectedItemId,
  }) async {
    await context.pushNamed(AppRoutes.tasbeehView, extra: selectedItemId);
    if (context.mounted) {
      unawaited(cubit.loadItems());
    }
  }

  Future<void> _openAll(BuildContext context, TasbeehCubit cubit) async {
    final state = cubit.state;
    if (state is! TasbeehLoaded) return;

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
          reopenOptions: () => _openAll(context, cubit),
        );
      case TasbeehOption.create:
        await _openAdd(context, cubit);
      case TasbeehOption.select:
        final id = result.selectedItemId;
        if (id != null) await _openScreen(context, cubit, selectedItemId: id);
      case TasbeehOption.edit:
      case TasbeehOption.delete:
        final id = result.selectedItemId;
        if (id == null) return;
        final fresh = context.read<TasbeehCubit>().state;
        if (fresh is! TasbeehLoaded) return;
        final item = fresh.items.byId(id);
        if (item == null) return;
        if (result.action == TasbeehOption.edit) {
          await _editItem(context, cubit, item);
        } else {
          await _deleteTasbeehItem(context, cubit, item);
        }
    }
  }

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

  Future<void> _deleteTasbeehItem(
    BuildContext context,
    TasbeehCubit cubit,
    TasbeehItemEntity item,
  ) async {
    await AzkarDestructiveAction.run(
      context,
      title: AppStrings.deleteTasbeehDialogTitle,
      message: AppStrings.deleteTasbeehDialogMessage,
      confirmText: AppStrings.delete,
      action: () => cubit.deleteTasbeehItem(item.id),
    );
  }

  String? _selectedItemId(TasbeehCubit cubit) {
    final state = cubit.state;
    return state is TasbeehLoaded ? state.selectedItemId : null;
  }

  @override
  Widget build(BuildContext context) => BlocProvider<TasbeehCubit>(
    create: (context) {
      final cubit = sl<TasbeehCubit>();
      unawaited(cubit.loadItems());
      return cubit;
    },
    child: BlocBuilder<TasbeehCubit, TasbeehState>(
      builder: (context, state) {
        final cubit = context.read<TasbeehCubit>();
        final recentItem =
            state is TasbeehLoaded && state.items.isNotEmpty
            ? state.recentItems.first
            : null;

        return AppSectionCard(
          padding: EdgeInsets.all(AppSize.p16),
          child: switch (state) {
            TasbeehLoaded() when recentItem == null => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  AppStrings.startTasbeeh,
                  style: AppTextStyles.font14W700Primary(context),
                ),
                AppGap.h(AppSize.p12),
                TasbeehPresetGrid(
                  onSelect: (text) =>
                      unawaited(_addPreset(context, cubit, text)),
                  onCustomTap: () => unawaited(_openAdd(context, cubit)),
                ),
              ],
            ),
            TasbeehLoaded() => TasbeehRecentItem(
              item: recentItem!,
              onContinue: () => unawaited(
                _openScreen(context, cubit, selectedItemId: recentItem.id),
              ),
              onOpenAll: () => unawaited(_openAll(context, cubit)),
            ),
            TasbeehError(:final message) => AppStateView(
              icon: AppIcons.error,
              title: AppStrings.tasbeehLoadError,
              message: message,
              action: AppPrimaryButton(
                label: AppStrings.tryAgain,
                onPressed: () => unawaited(cubit.loadItems()),
              ),
            ),
            TasbeehInitial() ||
            TasbeehLoading() => const TasbeehPresetGridSkeleton(),
          },
        );
      },
    ),
  );
}

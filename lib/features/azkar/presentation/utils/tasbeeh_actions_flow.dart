import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/error/result.dart';
import 'package:sana/core/widgets/overlays/app_bottom_sheet.dart';
import 'package:sana/core/widgets/overlays/app_toast.dart';
import 'package:sana/features/azkar/domain/entities/tasbeeh_item_entity.dart';
import 'package:sana/features/azkar/domain/extensions/tasbeeh_item_list_extensions.dart';
import 'package:sana/features/azkar/presentation/cubits/azkar_tasbeeh_settings/azkar_tasbeeh_settings_cubit.dart';
import 'package:sana/features/azkar/presentation/cubits/tasbeeh/tasbeeh_cubit.dart';
import 'package:sana/features/azkar/presentation/cubits/tasbeeh/tasbeeh_state.dart';
import 'package:sana/features/azkar/presentation/utils/azkar_destructive_action.dart';
import 'package:sana/features/azkar/presentation/utils/azkar_settings_flow.dart';
import 'package:sana/features/azkar/presentation/widgets/common/tasbeeh_item_form_bottom_sheet.dart';
import 'package:sana/features/azkar/presentation/widgets/common/tasbeeh_options_bottom_sheet.dart';

class TasbeehActionsFlow {
  const TasbeehActionsFlow._();

  // Adds a custom tasbeeh and returns the selected id on success.
  static Future<String?> openAdd(
    BuildContext context,
    TasbeehCubit cubit,
  ) async {
    final result = await AppBottomSheet.show<({String text, int? targetCount})>(
      context: context,
      enableDrag: false,
      child: const TasbeehItemFormBottomSheet(),
    );
    if (result == null || !context.mounted) return null;

    final saveResult = await cubit.addItem(
      text: result.text,
      targetCount: result.targetCount,
    );
    if (!context.mounted) return null;
    if (saveResult case FailureResult(:final failure)) {
      AppToast.show(context, failure.message, type: AppToastType.error);
      return null;
    }
    return _selectedItemId(cubit);
  }

  // Adds a preset tasbeeh and returns the selected id on success.
  static Future<String?> addPreset(
    BuildContext context,
    TasbeehCubit cubit,
    String text,
  ) async {
    final result = await cubit.addItem(text: text);
    if (!context.mounted) return null;
    if (result case FailureResult(:final failure)) {
      AppToast.show(context, failure.message, type: AppToastType.error);
      return null;
    }
    return _selectedItemId(cubit);
  }

  // Opens the tasbeeh options sheet and routes the selected action.
  static Future<void> openOptions(
    BuildContext context,
    TasbeehCubit cubit, {
    required bool showReadingSettings,
    Future<void> Function(String id)? onSelect,
    Future<void> Function(String? selectedItemId)? onAdded,
  }) async {
    final state = cubit.state;
    if (state is! TasbeehLoaded) {
      final id = await openAdd(context, cubit);
      if (id != null) await onAdded?.call(id);
      return;
    }

    final result = await AppBottomSheet.show<TasbeehOptionResult>(
      context: context,
      child: TasbeehOptionsBottomSheet(
        items: state.items,
        selectedItemId: state.selectedItemId,
        azkarTasbeehSettingsCubit: context.read<AzkarTasbeehSettingsCubit>(),
        showReadingSettings: showReadingSettings,
      ),
    );
    if (result == null || !context.mounted) return;

    switch (result.action) {
      case TasbeehOption.fontSize:
        await AzkarSettingsFlow.openWithGoBack(
          context,
          reopenOptions: () => openOptions(
            context,
            cubit,
            showReadingSettings: showReadingSettings,
            onSelect: onSelect,
            onAdded: onAdded,
          ),
        );
      case TasbeehOption.create:
        final id = await openAdd(context, cubit);
        if (id != null) await onAdded?.call(id);
      case TasbeehOption.select:
        final id = result.selectedItemId;
        if (id != null) await onSelect?.call(id);
      case TasbeehOption.edit:
      case TasbeehOption.delete:
        final id = result.selectedItemId;
        if (id == null) return;
        final fresh = cubit.state;
        if (fresh is! TasbeehLoaded) return;
        final item = fresh.items.byId(id);
        if (item == null) return;
        if (result.action == TasbeehOption.edit) {
          await _editItem(context, cubit, item);
        } else {
          await _deleteItem(context, cubit, item);
        }
    }
  }

  static Future<void> _editItem(
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

  static Future<void> _deleteItem(
    BuildContext context,
    TasbeehCubit cubit,
    TasbeehItemEntity item,
  ) => AzkarDestructiveAction.run(
    context,
    title: AppStrings.deleteTasbeehDialogTitle,
    message: AppStrings.deleteTasbeehDialogMessage,
    confirmText: AppStrings.delete,
    action: () => cubit.deleteTasbeehItem(item.id),
  );

  static String? _selectedItemId(TasbeehCubit cubit) {
    final state = cubit.state;
    return state is TasbeehLoaded ? state.selectedItemId : null;
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/error/result.dart';
import 'package:sana/core/widgets/overlays/app_bottom_sheet.dart';
import 'package:sana/core/widgets/overlays/app_toast.dart';
import 'package:sana/features/azkar/presentation/utils/azkar_destructive_action.dart';
import 'package:sana/features/azkar/presentation/widgets/common/tasbeeh_item_form_bottom_sheet.dart';

import 'package:sana/features/azkar/domain/entities/tasbeeh_item_entity.dart';
import 'package:sana/features/azkar/presentation/cubits/common/counter_increment_result.dart';
import 'package:sana/features/azkar/presentation/cubits/azkar_tasbeeh_settings/azkar_tasbeeh_settings_cubit.dart';
import 'package:sana/features/azkar/presentation/cubits/azkar_tasbeeh_settings/azkar_tasbeeh_settings_state.dart';
import 'package:sana/features/azkar/presentation/cubits/tasbeeh/tasbeeh_cubit.dart';
import 'package:sana/features/azkar/presentation/utils/haptic_feedback.dart';
import 'package:sana/features/azkar/presentation/widgets/common/card_action_menu.dart';
import 'package:sana/features/azkar/presentation/widgets/common/counter_ring.dart';
import 'package:sana/features/azkar/presentation/widgets/common/reading_text_content.dart';
import 'package:sana/features/azkar/presentation/widgets/common/zikr_card_shell.dart';

class TasbeehItemCard extends StatelessWidget {
  const TasbeehItemCard({required this.item, super.key});

  final TasbeehItemEntity item;

  Future<void> _handleCount(BuildContext context) async {
    final result = await context.read<TasbeehCubit>().increment(item.id);
    if (!context.mounted || result is CounterIgnored) return;
    playIncrementHapticFeedback(context, result);
  }

  Future<void> _handleDecrement(BuildContext context) async {
    final changed = await context.read<TasbeehCubit>().decrement(item.id);
    if (changed && context.mounted) playDecrementHapticFeedback(context);
  }

  Future<void> _handleReset(BuildContext context) async {
    await context.read<TasbeehCubit>().resetCounter(item.id);
  }

  Future<void> _handleEdit(BuildContext context) async {
    final result = await AppBottomSheet.show<({String text, int? targetCount})>(
      context: context,
      child: TasbeehItemFormBottomSheet(initialItem: item),
    );
    if (result == null || !context.mounted) return;
    final save = await context.read<TasbeehCubit>().updateItem(
      id: item.id,
      text: result.text,
      targetCount: () => result.targetCount,
    );
    if (!context.mounted) return;
    if (save case FailureResult(:final failure)) {
      AppToast.show(context, failure.message, type: AppToastType.error);
    }
  }

  Future<void> _handleDelete(BuildContext context) => AzkarDestructiveAction.run(
    context,
    title: AppStrings.deleteTasbeehDialogTitle,
    message: AppStrings.deleteTasbeehDialogMessage,
    confirmText: AppStrings.delete,
    action: () => context.read<TasbeehCubit>().deleteTasbeehItem(item.id),
  );

  @override
  Widget build(BuildContext context) => BlocBuilder<
    AzkarTasbeehSettingsCubit,
    AzkarTasbeehSettingsState
  >(
    builder: (context, settingsState) {
      final fontSize = settingsState.settingsOrDefault.fontSize;
      final canCount =
          item.targetCount != null ||
          item.currentCount < AppConstants.tasbeehMaxCount;
      final canReset = item.currentCount > 0;
      final isCompleted = item.isCompleted;

      return ZikrCardShell(
        showBadge: false,
        isCompleted: isCompleted,
        semanticButton: canCount,
        onTap: canCount ? () => _handleCount(context) : null,
        onLongPress: canCount ? () => _handleCount(context) : null,
        content: ReadingTextContent(text: item.text, fontSize: fontSize),
        footer: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CardActionMenu(
              canAdjust: canReset,
              onDecrement: () => _handleDecrement(context),
              onReset: () => _handleReset(context),
              onEdit: () => _handleEdit(context),
              onDelete: () => _handleDelete(context),
              editLabel: AppStrings.editTasbeeh,
              deleteLabel: AppStrings.deleteTasbeeh,
            ),
            Semantics(
              label: AppStrings.remainingCounterLabel,
              value: isCompleted
                  ? AppStrings.completed
                  : item.targetCount == null
                  ? '${item.currentCount}'
                  : '${item.remaining}',
              excludeSemantics: true,
              child: CounterRing(
                currentCount: item.currentCount,
                targetCount: item.targetCount,
              ),
            ),
          ],
        ),
      );
    },
  );
}

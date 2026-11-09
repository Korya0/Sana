import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/utils/app_haptics.dart';
import 'package:sana/core/widgets/app_gap.dart';
import 'package:sana/core/widgets/cards/app_section_card.dart';
import 'package:sana/core/widgets/dividers/custom_app_divider.dart';
import 'package:sana/core/widgets/interaction/app_pressable.dart';
import 'package:sana/core/widgets/overlays/app_bottom_sheet.dart';
import 'package:sana/core/widgets/overlays/app_toast.dart';
import 'package:sana/core/widgets/overlays/custom_confirmation_dialog.dart';
import 'package:sana/features/azkar/domain/entities/reading_settings_entity.dart';
import 'package:sana/features/azkar/domain/entities/zikr_entity.dart';
import 'package:sana/features/azkar/presentation/cubits/azkar/azkar_cubit.dart';
import 'package:sana/features/azkar/presentation/cubits/azkar/azkar_state.dart';
import 'package:sana/features/azkar/presentation/cubits/azkar/zikr_increment_result.dart';
import 'package:sana/features/azkar/presentation/cubits/reading_settings/reading_settings_cubit.dart';
import 'package:sana/features/azkar/presentation/cubits/reading_settings/reading_settings_state.dart';
import 'package:sana/features/azkar/presentation/widgets/zikr_list/zikr_card/edit_target_count_bottom_sheet.dart';
import 'package:sana/features/azkar/presentation/widgets/zikr_list/zikr_card/zikr_actions_row.dart';
import 'package:sana/features/azkar/presentation/widgets/zikr_list/zikr_card/zikr_content.dart';
import 'package:sana/features/azkar/presentation/widgets/zikr_list/zikr_card/zikr_options_bottom_sheet.dart';

class ZikrItemCard extends StatelessWidget {
  const ZikrItemCard({
    required this.zikr,
    required this.categoryKey,
    super.key,
    this.onCompleted,
  });

  final ZikrEntity zikr;
  final String categoryKey;
  final VoidCallback? onCompleted;

  void _handlePress(BuildContext context) {
    final result = context.read<AzkarCubit>().incrementZikr(zikr.id);
    if (result is ZikrIgnored) return;

    unawaited(AppHaptics.light());

    if (result is ZikrCompleted) {
      unawaited(AppHaptics.doubleTap());
      onCompleted?.call();
    }
  }

  Future<void> _handleOptions(BuildContext context) async {
    final cubit = context.read<AzkarCubit>();
    final state = cubit.state;
    final currentCount =
        state is AzkarLoaded ? (state.counters[zikr.id] ?? 0) : 0;
    final isCustomCategory = categoryKey.startsWith('custom_');
    final canDelete = isCustomCategory || zikr.canBeDeleted;

    final action = await AppBottomSheet.show<ZikrOptionAction>(
      context: context,
      child: ZikrOptionsBottomSheet(
        canReset: currentCount > 0,
        canDelete: canDelete,
      ),
    );

    if (!context.mounted || action == null) return;

    switch (action) {
      case ZikrOptionAction.resetCounter:
        context.read<AzkarCubit>().resetCounter(zikr.id);
        if (context.mounted) {
          AppToast.show(
            context,
            AppStrings.counterResetSuccess,
            type: AppToastType.success,
          );
        }
      case ZikrOptionAction.editTarget:
        final newCount = await AppBottomSheet.show<int>(
          context: context,
          child: EditTargetCountBottomSheet(initialCount: zikr.count),
        );

        if (newCount != null && newCount != zikr.count && context.mounted) {
          final cubit = context.read<AzkarCubit>();
          final state = cubit.state;
          final title = state is AzkarLoaded ? state.resolvedTitle : '';
          await cubit.updateTargetCount(
            zikr.id,
            newCount,
            categoryKey: categoryKey,
            categoryTitle: title,
          );
          if (context.mounted) {
            AppToast.show(
              context,
              AppStrings.targetCountUpdatedSuccess,
              type: AppToastType.success,
            );
          }
        }
      case ZikrOptionAction.delete:
        final confirmed = await CustomConfirmationDialog.show(
          context: context,
          title: AppStrings.deleteItemDialogTitle,
          message: AppStrings.deleteItemDialogMessage,
          confirmText: AppStrings.delete,
          cancelText: AppStrings.cancel,
        );

        if (confirmed == true && context.mounted) {
          final cubit = context.read<AzkarCubit>();
          final state = cubit.state;
          final title = state is AzkarLoaded ? state.resolvedTitle : '';
          final success = await cubit.deleteZikr(
            zikr.id,
            categoryKey: categoryKey,
            categoryTitle: title,
          );
          if (success && context.mounted) {
            AppToast.show(
              context,
              AppStrings.zikrDeletedSuccess,
              type: AppToastType.success,
            );
          }
        }
    }
  }

  @override
  Widget build(BuildContext context) => BlocBuilder<AzkarCubit, AzkarState>(
    buildWhen: (previous, current) {
      if (previous is AzkarLoaded && current is AzkarLoaded) {
        return (previous.counters[zikr.id] ?? 0) !=
                (current.counters[zikr.id] ?? 0) ||
            previous.azkar != current.azkar;
      }
      return previous.runtimeType != current.runtimeType;
    },
    builder: (context, state) {
      if (state is! AzkarLoaded) return const SizedBox.shrink();

      var currentZikr = zikr;
      for (final z in state.azkar) {
        if (z.id == zikr.id) {
          currentZikr = z;
          break;
        }
      }

      final currentCount = state.counters[currentZikr.id] ?? 0;
      final isCompleted = currentCount >= currentZikr.count;

      return BlocBuilder<ReadingSettingsCubit, ReadingSettingsState>(
        builder: (context, settingsState) {
          final fontSize = switch (settingsState) {
            ReadingSettingsLoaded(:final settings) => settings.fontSize,
            ReadingSettingsError(:final settings?) => settings.fontSize,
            _ => ReadingSettingsEntity.defaultFontSize,
          };

          return ZikrItemCardContent(
            zikr: currentZikr,
            completedCount: currentCount,
            isCompleted: isCompleted,
            fontSize: fontSize,
            onTap: isCompleted ? null : () => _handlePress(context),
            onLongPress: isCompleted ? null : () => _handlePress(context),
            onOptionsPressed: () => unawaited(_handleOptions(context)),
          );
        },
      );
    },
  );
}

class ZikrItemCardContent extends StatelessWidget {
  const ZikrItemCardContent({
    required this.zikr,
    required this.completedCount,
    required this.isCompleted,
    required this.fontSize,
    super.key,
    this.onTap,
    this.onLongPress,
    this.onOptionsPressed,
  });

  final ZikrEntity zikr;
  final int completedCount;
  final bool isCompleted;
  final double fontSize;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final VoidCallback? onOptionsPressed;

  @override
  Widget build(BuildContext context) => RepaintBoundary(
    child: Semantics(
      label: AppStrings.zikrLabel(zikr.text),
      value: isCompleted
          ? AppStrings.completed
          : AppStrings.remainingCountOfTotal(
              zikr.count - completedCount,
              zikr.count,
            ),
      button: !isCompleted,
      hint: isCompleted
          ? AppStrings.completedRepetitions
          : AppStrings.tapToCount,
      child: Padding(
        padding: EdgeInsets.only(bottom: AppSize.p16),
        child: AppSectionCard(
          padding: EdgeInsets.zero,
          child: AppPressable(
            onPressed: onTap,
            onLongPress: onLongPress,
            semanticButton: !isCompleted,
            disabledOpacity: AppConstants.opacityFull,
            fadeOpacity: AppConstants.opacityFull,
            child: Padding(
              padding: EdgeInsets.all(AppSize.p20),
              child: AnimatedOpacity(
                duration: AppConstants.animationSlow400ms,
                opacity: isCompleted
                    ? AppConstants.opacityMuted
                    : AppConstants.opacityFull,
                child: AnimatedScale(
                  duration: AppConstants.animationSlow400ms,
                  scale: isCompleted
                      ? AppConstants.scaleCompleted
                      : AppConstants.scaleNormal,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Content
                      ZikrContent(
                        text: zikr.text,
                        subText: zikr.description,
                        fontSize: fontSize,
                      ),
                      AppGap.h(AppSize.p24),

                      // Divider
                      const CustomAppDivider(),
                      AppGap.h(AppSize.p24),

                      // Actions + Counter Row
                      ZikrActionsRow(
                        completedCount: completedCount,
                        totalCount: zikr.count,
                        onOptionsPressed: onOptionsPressed,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

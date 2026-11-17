import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/services/clipboard/clipboard_copy.dart';
import 'package:sana/core/widgets/app_gap.dart';
import 'package:sana/core/widgets/cards/app_section_card.dart';
import 'package:sana/core/widgets/dividers/custom_app_divider.dart';
import 'package:sana/core/widgets/interaction/app_pressable.dart';
import 'package:sana/features/azkar/domain/entities/zikr_entity.dart';
import 'package:sana/features/azkar/domain/extensions/zikr_list_extensions.dart';
import 'package:sana/features/azkar/presentation/cubits/azkar/azkar_cubit.dart';
import 'package:sana/features/azkar/presentation/cubits/azkar/azkar_state.dart';
import 'package:sana/features/azkar/presentation/cubits/common/counter_increment_result.dart';
import 'package:sana/features/azkar/presentation/cubits/azkar/zikr_progress.dart';
import 'package:sana/features/azkar/presentation/cubits/azkar_tasbeeh_settings/azkar_tasbeeh_settings_cubit.dart';
import 'package:sana/features/azkar/presentation/cubits/azkar_tasbeeh_settings/azkar_tasbeeh_settings_state.dart';
import 'package:sana/features/azkar/presentation/utils/haptic_feedback.dart';
import 'package:sana/features/azkar/presentation/widgets/common/zikr_badge.dart';
import 'package:sana/features/azkar/presentation/widgets/zikr_list/zikr_card/zikr_actions_row.dart';
import 'package:sana/features/azkar/presentation/widgets/common/reading_text_content.dart';

class ZikrItemCard extends StatelessWidget {
  // Creates card
  const ZikrItemCard({
    required this.zikr,
    required this.categoryTitle,
    super.key,
    this.onCounterCompleted,
  });

  final ZikrEntity zikr;
  final String categoryTitle;
  final VoidCallback? onCounterCompleted;

  // Handles press
  void _handlePress(BuildContext context) {
    final result = context.read<AzkarCubit>().incrementZikr(zikr.id);
    if (result is CounterIgnored) return;

    playIncrementHapticFeedback(context, result);
    if (result is CounterCompleted) onCounterCompleted?.call();
  }

  // Handles reset
  void _handleReset(BuildContext context) {
    context.read<AzkarCubit>().resetCounter(zikr.id);
  }

  Future<void> _copyZikrText(
    BuildContext context,
    ZikrEntity currentZikr,
  ) async {
    final text = AppStrings.zikrCopyText(
      categoryTitle: categoryTitle,
      zikrText: currentZikr.text,
      description: currentZikr.description,
    );
    await copyText(
      context,
      text,
      errorMessage: AppStrings.zikrCopyError,
    );
  }

  // Builds card
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

      final currentZikr = state.azkar.byId(zikr.id) ?? zikr;
      final progress = state.getProgressFor(zikr.id);

      return BlocBuilder<AzkarTasbeehSettingsCubit, AzkarTasbeehSettingsState>(
        builder: (context, settingsState) {
          final fontSize = settingsState.settingsOrDefault.fontSize;

          return ZikrItemCardContent(
            zikr: currentZikr,
            progress: progress,
            fontSize: fontSize,
            onTap: progress.isCompleted ? null : () => _handlePress(context),
            onLongPress: progress.isCompleted
                ? null
                : () => _handlePress(context),
            onReset: () => _handleReset(context),
            onCopyTap: () => unawaited(_copyZikrText(context, currentZikr)),
          );
        },
      );
    },
  );
}

class ZikrItemCardContent extends StatelessWidget {
  // Creates content
  const ZikrItemCardContent({
    required this.zikr,
    required this.progress,
    required this.fontSize,
    super.key,
    this.onTap,
    this.onLongPress,
    this.onReset,
    this.onCopyTap,
  });

  final ZikrEntity zikr;
  final ZikrProgress progress;
  final double fontSize;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final VoidCallback? onReset;
  final VoidCallback? onCopyTap;

  // Builds content
  @override
  Widget build(BuildContext context) => RepaintBoundary(
    child: Semantics(
      label: AppStrings.zikrLabel(zikr.text),
      value: progress.isCompleted
          ? AppStrings.completed
          : AppStrings.remainingCountOfTotal(
              progress.remaining,
              progress.totalCount,
            ),
      button: !progress.isCompleted,
      hint: progress.isCompleted
          ? AppStrings.completedRepetitions
          : AppStrings.tapToCount,
      child: Padding(
        padding: EdgeInsets.only(bottom: AppSize.p16),
        child: Stack(
          children: [
            // Body
            AppSectionCard(
              padding: EdgeInsets.zero,
              child: AppPressable(
                onPressed: onTap,
                onLongPress: onLongPress,
                semanticButton: !progress.isCompleted,
                disabledOpacity: AppConstants.opacityFull,
                fadeOpacity: AppConstants.opacityFull,
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(
                    AppSize.p20,
                    zikr.canBeDeleted ? AppSize.p20 + AppSize.p16 : AppSize.p20,
                    AppSize.p20,
                    AppSize.p20,
                  ),
                  child: AnimatedOpacity(
                    duration: AppConstants.animationSlow400ms,
                    opacity: progress.isCompleted
                        ? AppConstants.opacityMuted
                        : AppConstants.opacityFull,
                    child: AnimatedScale(
                      duration: AppConstants.animationSlow400ms,
                      scale: progress.isCompleted
                          ? AppConstants.scaleCompleted
                          : AppConstants.scaleNormal,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Content
                          ReadingTextContent(
                            text: zikr.text,
                            subText: zikr.description,
                            fontSize: fontSize,
                          ),
                          AppGap.h(AppSize.p24),

                          // Divider
                          const CustomAppDivider(),
                          AppGap.h(AppSize.p24),

                          // Actions + counter
                          ZikrActionsRow(
                            progress: progress,
                            onResetTap: onReset,
                            onCopyTap: onCopyTap,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Badge
            if (zikr.canBeDeleted)
              PositionedDirectional(
                top: AppSize.p8,
                end: AppSize.p8,
                child: const ZikrBadge(),
              ),
          ],
        ),
      ),
    ),
  );
}

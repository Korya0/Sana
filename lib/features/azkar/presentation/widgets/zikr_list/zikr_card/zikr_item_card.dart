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
import 'package:sana/features/azkar/domain/entities/reading_settings_entity.dart';
import 'package:sana/features/azkar/domain/entities/zikr_entity.dart';
import 'package:sana/features/azkar/presentation/cubits/azkar/azkar_cubit.dart';
import 'package:sana/features/azkar/presentation/cubits/azkar/azkar_state.dart';
import 'package:sana/features/azkar/presentation/cubits/azkar/zikr_increment_result.dart';
import 'package:sana/features/azkar/presentation/cubits/reading_settings/reading_settings_cubit.dart';
import 'package:sana/features/azkar/presentation/cubits/reading_settings/reading_settings_state.dart';
import 'package:sana/features/azkar/presentation/widgets/zikr_list/zikr_card/custom_zikr_badge.dart';
import 'package:sana/features/azkar/presentation/widgets/zikr_list/zikr_card/zikr_actions_row.dart';
import 'package:sana/features/azkar/presentation/widgets/zikr_list/zikr_card/zikr_content.dart';

class ZikrItemCard extends StatelessWidget {
  // Creates card
  const ZikrItemCard({
    required this.zikr,
    super.key,
    this.onCompleted,
  });

  final ZikrEntity zikr;
  final VoidCallback? onCompleted;

  // Handles press
  void _handlePress(BuildContext context) {
    final result = context.read<AzkarCubit>().incrementZikr(zikr.id);
    if (result is ZikrIgnored) return;

    unawaited(AppHaptics.light());

    if (result is ZikrCompleted) {
      unawaited(AppHaptics.doubleTap());
      onCompleted?.call();
    }
  }

  // Handles reset
  void _handleReset(BuildContext context) {
    context.read<AzkarCubit>().resetCounter(zikr.id);
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
            onReset: () => _handleReset(context),
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
    required this.completedCount,
    required this.isCompleted,
    required this.fontSize,
    super.key,
    this.onTap,
    this.onLongPress,
    this.onReset,
  });

  final ZikrEntity zikr;
  final int completedCount;
  final bool isCompleted;
  final double fontSize;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final VoidCallback? onReset;

  // Builds content
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
        child: Stack(
          children: [
            // Body
            AppSectionCard(
              padding: EdgeInsets.zero,
              child: AppPressable(
                onPressed: onTap,
                onLongPress: onLongPress,
                semanticButton: !isCompleted,
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

                          // Actions + counter
                          ZikrActionsRow(
                            completedCount: completedCount,
                            totalCount: zikr.count,
                            onResetPressed: onReset,
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
                child: const CustomZikrBadge(),
              ),
          ],
        ),
      ),
    ),
  );
}

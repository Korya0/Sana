import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/utils/app_haptics.dart';
import 'package:sana/core/widgets/app_gap.dart';
import 'package:sana/core/widgets/interaction/app_pressable.dart';
import 'package:sana/features/azkar/domain/entities/reading_settings_entity.dart';
import 'package:sana/features/azkar/domain/entities/tasbeeh_item_entity.dart';
import 'package:sana/features/azkar/presentation/cubits/azkar/zikr_increment_result.dart';
import 'package:sana/features/azkar/presentation/cubits/reading_settings/reading_settings_cubit.dart';
import 'package:sana/features/azkar/presentation/cubits/reading_settings/reading_settings_state.dart';
import 'package:sana/features/azkar/presentation/cubits/tasbeeh/tasbeeh_cubit.dart';
import 'package:sana/features/azkar/presentation/widgets/tasbeeh/tasbeeh_counter_widgets.dart';
import 'package:sana/features/azkar/presentation/widgets/zikr_list/zikr_card/zikr_content.dart';

class TasbeehCounterContent extends StatelessWidget {
  // Creates content
  const TasbeehCounterContent({required this.item, super.key});

  final TasbeehItemEntity item;

  // Handles press
  Future<void> _handlePress(BuildContext context) async {
    final result = await context.read<TasbeehCubit>().increment(item.id);
    if (result is ZikrIgnored || !context.mounted) return;

    final settingsState = context.read<ReadingSettingsCubit>().state;
    final hapticEnabled = switch (settingsState) {
      ReadingSettingsLoaded(:final settings) => settings.hapticFeedbackEnabled,
      ReadingSettingsError(:final settings?) => settings.hapticFeedbackEnabled,
      _ => ReadingSettingsEntity.defaultHapticFeedbackEnabled,
    };

    if (hapticEnabled) {
      unawaited(AppHaptics.light());
    }
    if (result is ZikrCompleted && hapticEnabled) {
      unawaited(AppHaptics.doubleTap());
    }
  }

  // Builds content
  @override
  Widget build(BuildContext context) =>
      BlocBuilder<ReadingSettingsCubit, ReadingSettingsState>(
        builder: (context, settingsState) {
          final fontSize = switch (settingsState) {
            ReadingSettingsLoaded(:final settings) => settings.fontSize,
            ReadingSettingsError(:final settings?) => settings.fontSize,
            _ => ReadingSettingsEntity.defaultFontSize,
          };

          final isCompleted = item.isCompleted;
          final remaining = item.hasTarget
              ? item.targetCount! - item.currentCount
              : item.currentCount;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Zikr
              Expanded(
                child: SingleChildScrollView(
                  child: ZikrContent(text: item.text, fontSize: fontSize),
                ),
              ),
              AppGap.h(AppSize.p16),

              // Counter
              Center(
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
                    child: AppPressable(
                      onPressed: isCompleted
                          ? null
                          : () => unawaited(_handlePress(context)),
                      onLongPress: isCompleted
                          ? null
                          : () => unawaited(_handlePress(context)),
                      semanticButton: !isCompleted,
                      disabledOpacity: AppConstants.opacityFull,
                      fadeOpacity: AppConstants.opacityFull,
                      child: Semantics(
                        label: AppStrings.remainingCounterLabel,
                        value:
                            isCompleted ? AppStrings.completed : '$remaining',
                        excludeSemantics: true,
                        child: TasbeehCounter(
                          currentCount: item.currentCount,
                          targetCount: item.targetCount,
                          dimension: AppSize.h200,
                          strokeWidth: AppSize.progressStrokeWidth * 2,
                          numberStyle: AppTextStyles.font48W700Brand(context),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      );
}

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
import 'package:sana/features/azkar/presentation/widgets/zikr_list/zikr_card/zikr_actions_row.dart';
import 'package:sana/features/azkar/presentation/widgets/zikr_list/zikr_card/zikr_content.dart';

class ZikrItemCard extends StatefulWidget {
  const ZikrItemCard({
    required this.zikr,
    super.key,
    this.onCompleted,
  });

  final ZikrEntity zikr;
  final VoidCallback? onCompleted;

  @override
  State<ZikrItemCard> createState() => _ZikrItemCardState();
}

class _ZikrItemCardState extends State<ZikrItemCard> {
  void _handlePress() {
    final result = context.read<AzkarCubit>().incrementZikr(widget.zikr.id);
    if (result is ZikrIgnored) return;

    unawaited(AppHaptics.light());

    if (result is ZikrCompleted) {
      unawaited(AppHaptics.doubleTap());
      widget.onCompleted?.call();
    }
  }

  @override
  Widget build(BuildContext context) => BlocBuilder<AzkarCubit, AzkarState>(
    buildWhen: (previous, current) {
      if (previous is AzkarLoaded && current is AzkarLoaded) {
        return (previous.counters[widget.zikr.id] ?? 0) !=
            (current.counters[widget.zikr.id] ?? 0);
      }
      return previous.runtimeType != current.runtimeType;
    },
    builder: (context, state) {
      if (state is! AzkarLoaded) return const SizedBox.shrink();

      final currentCount = state.counters[widget.zikr.id] ?? 0;
      final isCompleted = currentCount >= widget.zikr.count;

      return BlocBuilder<ReadingSettingsCubit, ReadingSettingsState>(
        builder: (context, settingsState) {
          final fontSize = switch (settingsState) {
            ReadingSettingsLoaded(:final settings) => settings.fontSize,
            ReadingSettingsError(:final settings?) => settings.fontSize,
            _ => ReadingSettingsEntity.defaultFontSize,
          };

          return ZikrItemCardContent(
            zikr: widget.zikr,
            remainingCount: widget.zikr.count - currentCount,
            progress: widget.zikr.count > 0
                ? currentCount / widget.zikr.count
                : AppConstants.progressStart,
            isCompleted: isCompleted,
            fontSize: fontSize,
            onTap: isCompleted ? null : _handlePress,
            onLongPress: isCompleted ? null : _handlePress,
          );
        },
      );
    },
  );
}

class ZikrItemCardContent extends StatelessWidget {
  const ZikrItemCardContent({
    required this.zikr,
    required this.remainingCount,
    required this.progress,
    required this.isCompleted,
    required this.fontSize,
    super.key,
    this.onTap,
    this.onLongPress,
  });

  final ZikrEntity zikr;
  final int remainingCount;
  final double progress;
  final bool isCompleted;
  final double fontSize;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) => RepaintBoundary(
    child: Semantics(
      label: AppStrings.zikrLabel(zikr.text),
      value: isCompleted
          ? AppStrings.completed
          : AppStrings.remainingCountOfTotal(remainingCount, zikr.count),
      button: !isCompleted,
      hint: isCompleted
          ? AppStrings.completedRepetitions
          : AppStrings.tapToCount,
      child: Padding(
        padding: EdgeInsets.only(bottom: AppSize.p16),
        // The card surface is painted outside the press effect and stays
        // solid; the counter change is the press feedback.
        child: AppSectionCard(
          padding: EdgeInsets.zero,
          child: AppPressable(
            onPressed: onTap,
            onLongPress: onLongPress,
            semanticButton: !isCompleted,
            disabledOpacity: AppConstants.opacityFull,
            // A zikr card does not fade on press: the counter and progress
            // circle changing are the feedback. The surface stays solid too.
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

                      // Counter
                      ZikrActionsRow(
                        remainingCount: remainingCount,
                        progress: progress,
                        isCompleted: isCompleted,
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

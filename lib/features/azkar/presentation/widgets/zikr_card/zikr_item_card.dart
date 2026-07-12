import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/common/common.dart';
import 'package:sana/core/constants/constants.dart';
import 'package:sana/core/theme/app_spacing.dart';
import 'package:sana/core/utils/utils.dart';
import 'package:sana/features/azkar/data/constants/azkar_constants.dart';
import 'package:sana/features/azkar/domain/entities/zikr_entity.dart';
import 'package:sana/features/azkar/presentation/cubits/azkar/azkar_cubit.dart';
import 'package:sana/features/azkar/presentation/cubits/azkar/azkar_state.dart';
import 'package:sana/features/azkar/presentation/cubits/azkar/zikr_increment_result.dart';
import 'package:sana/features/azkar/presentation/cubits/reading_settings/reading_settings_cubit.dart';
import 'package:sana/features/azkar/presentation/cubits/reading_settings/reading_settings_state.dart';
import 'package:sana/features/azkar/presentation/widgets/zikr_card/zikr_actions_row.dart';
import 'package:sana/features/azkar/presentation/widgets/zikr_card/zikr_content.dart';

class ZikrItemCard extends StatefulWidget {
  const ZikrItemCard({
    required this.zikr,
    required this.index,
    super.key,
    this.onCompleted,
    this.onSharePressed,
    this.onCopyPressed,
  });
  final ZikrEntity zikr;
  final int index;
  final VoidCallback? onCompleted;
  final VoidCallback? onSharePressed;
  final VoidCallback? onCopyPressed;

  @override
  State<ZikrItemCard> createState() => _ZikrItemCardState();
}

class _ZikrItemCardState extends State<ZikrItemCard> {
  DateTime? _lastPressTime;
  static const _debounceDuration = Duration(milliseconds: 200);

  void _handlePress() {
    final now = DateTime.now();

    if (_lastPressTime != null &&
        now.difference(_lastPressTime!) < _debounceDuration) {
      return;
    }

    _lastPressTime = now;
    unawaited(playVibrate());

    final cubit = context.read<AzkarCubit>();
    final result = cubit.incrementZikr(widget.zikr.id);

    if (result is ZikrCompleted) {
      unawaited(playVibrate());
      unawaited(
        Future<void>.delayed(
          const Duration(milliseconds: 200),
          playVibrate,
        ),
      );
      widget.onCompleted?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AzkarCubit, AzkarState>(
      buildWhen: (previous, current) {
        if (previous is AzkarLoaded && current is AzkarLoaded) {
          final prevCount = previous.counters[widget.zikr.id] ?? 0;
          final currCount = current.counters[widget.zikr.id] ?? 0;
          return prevCount != currCount;
        }
        return previous.runtimeType != current.runtimeType;
      },
      builder: (context, state) {
        if (state is! AzkarLoaded) {
          return const SizedBox.shrink();
        }

        final currentCount = state.counters[widget.zikr.id] ?? 0;
        final progress = widget.zikr.count > 0
            ? currentCount / widget.zikr.count
            : 0.0;
        final isCompleted = currentCount >= widget.zikr.count;
        final remainingCount = widget.zikr.count - currentCount;

        return RepaintBoundary(
          child: Semantics(
            label: AppStrings.zikrLabel(widget.zikr.text),
            value: isCompleted
                ? AppStrings.completedText
                : AppStrings.remainingCountOfTotal(
                    remainingCount,
                    widget.zikr.count,
                  ),
            button: !isCompleted,
            hint: isCompleted
                ? AppStrings.completedRepetitions
                : AppStrings.tapToCount,
            child: GestureDetector(
              onLongPress: isCompleted ? null : _handlePress,
              onTap: isCompleted ? null : _handlePress,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 400),
              margin: const EdgeInsets.only(bottom: AppSpacing.v16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppSpacing.radiusXL),
                color: context.color.secondaryScaffoldBackgroundColor
                    .withValues(alpha: 0.4),
                border: Border.all(
                  color: isCompleted
                      ? context.color.primary.withValues(alpha: 0.05)
                      : context.color.primary.withValues(alpha: 0.15),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.v20),
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 400),
                  opacity: isCompleted ? 0.5 : 1.0,
                  child: AnimatedScale(
                    duration: const Duration(milliseconds: 400),
                    scale: isCompleted ? 0.98 : 1.0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        BlocBuilder<ReadingSettingsCubit, ReadingSettingsState>(
                          builder: (context, state) {
                            final fontSize = state is ReadingSettingsLoaded
                                ? state.settings.fontSize
                                : AzkarConstants.defaultFontSize;
                            return ZikrContent(
                              text: widget.zikr.text,
                              subText: widget.zikr.description,
                              fontSize: fontSize,
                            );
                          },
                        ),
                        const AppGap.h(AppSpacing.v24),
                        const CustomAppDivider(),
                        const AppGap.h(AppSpacing.v24),
                        ZikrActionsRow(
                          remainingCount: remainingCount,
                          progress: progress,
                          isCompleted: isCompleted,
                          onShare: widget.onSharePressed,
                          onCopy: widget.onCopyPressed,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    },
    );
  }
}

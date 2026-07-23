import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/common/common.dart';
import 'package:sana/core/constants/constants.dart';
import 'package:sana/core/constants/app_spacing.dart';
import 'package:sana/features/azkar/data/constants/azkar_constants.dart';
import 'package:sana/features/azkar/domain/entities/zikr_entity.dart';
import 'package:sana/features/azkar/presentation/cubit/azkar/azkar_cubit.dart';
import 'package:sana/features/azkar/presentation/cubit/azkar/azkar_state.dart';
import 'package:sana/features/azkar/presentation/cubit/azkar/zikr_increment_result.dart';
import 'package:sana/features/azkar/presentation/cubit/reading_settings/reading_settings_cubit.dart';
import 'package:sana/features/azkar/presentation/cubit/reading_settings/reading_settings_state.dart';
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
  final AsyncCallback? onSharePressed;
  final VoidCallback? onCopyPressed;

  @override
  State<ZikrItemCard> createState() => _ZikrItemCardState();
}

class _ZikrItemCardState extends State<ZikrItemCard> {
  void _handlePress() {
    final cubit = context.read<AzkarCubit>();
    final result = cubit.incrementZikr(widget.zikr.id);

    if (result is ZikrCompleted) {
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

        return BlocBuilder<ReadingSettingsCubit, ReadingSettingsState>(
          builder: (context, settingsState) {
            final fontSize = settingsState is ReadingSettingsLoaded
                ? settingsState.settings.fontSize
                : AzkarConstants.defaultFontSize;
            return ZikrItemCardContent(
              zikr: widget.zikr,
              remainingCount: remainingCount,
              progress: progress,
              isCompleted: isCompleted,
              fontSize: fontSize,
              onTap: isCompleted ? null : _handlePress,
              onLongPress: isCompleted ? null : _handlePress,
              onSharePressed: widget.onSharePressed,
              onCopyPressed: widget.onCopyPressed,
            );
          },
        );
      },
    );
  }
}

class ZikrItemCardContent extends StatelessWidget {
  const ZikrItemCardContent({
    required this.zikr,
    required this.remainingCount,
    required this.progress,
    required this.isCompleted,
    required this.fontSize,
    this.onTap,
    this.onLongPress,
    this.onSharePressed,
    this.onCopyPressed,
    super.key,
  });

  final ZikrEntity zikr;
  final int remainingCount;
  final double progress;
  final bool isCompleted;
  final double fontSize;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final AsyncCallback? onSharePressed;
  final VoidCallback? onCopyPressed;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Semantics(
        label: AppStrings.zikrLabel(zikr.text),
        value: isCompleted
            ? AppStrings.completedText
            : AppStrings.remainingCountOfTotal(
                remainingCount,
                zikr.count,
              ),
        button: !isCompleted,
        hint: isCompleted
            ? AppStrings.completedRepetitions
            : AppStrings.tapToCount,
        child: GestureDetector(
          onLongPress: onLongPress,
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.v16),
            child: AppSectionCard(
              padding: const EdgeInsets.all(AppSpacing.v20),
              child: AnimatedOpacity(
                duration: AppConstants.animationSlow400ms,
                opacity: isCompleted ? 0.5 : 1.0,
                child: AnimatedScale(
                  duration: AppConstants.animationSlow400ms,
                  scale: isCompleted ? 0.98 : 1.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ZikrContent(
                        text: zikr.text,
                        subText: zikr.description,
                        fontSize: fontSize,
                      ),
                      const AppGap.h(AppSpacing.v24),
                      const CustomAppDivider(),
                      const AppGap.h(AppSpacing.v24),
                      ZikrActionsRow(
                        remainingCount: remainingCount,
                        progress: progress,
                        isCompleted: isCompleted,
                        onShare: onSharePressed,
                        onCopy: onCopyPressed,
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
  }
}

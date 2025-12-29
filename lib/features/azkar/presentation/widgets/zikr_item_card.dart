import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/common/widgets/islamic_divider.dart';
import 'package:sana/core/di/service_locator.dart';
import 'package:sana/core/services/share_service.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:sana/core/utils/widget_to_image.dart';
import 'package:sana/features/azkar/data/models/zikr_model.dart';
import 'package:sana/features/azkar/presentation/cubit/azkar_list_cubit.dart';
import 'package:sana/features/azkar/presentation/cubit/azkar_list_state.dart';
import 'package:sana/features/azkar/presentation/widgets/zikr_card/zikr_actions_row.dart';
import 'package:sana/features/azkar/presentation/widgets/zikr_card/zikr_content.dart';
import 'package:sana/features/azkar/presentation/widgets/zikr_card/zikr_share_card.dart';

class ZikrItemCard extends StatefulWidget {
  final ZikrModel zikr;
  final int index;
  final VoidCallback? onCompleted;

  const ZikrItemCard({
    super.key,
    required this.zikr,
    required this.index,
    this.onCompleted,
  });

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
    HapticFeedback.vibrate();

    final cubit = context.read<AzkarListCubit>();
    final state = cubit.state;

    if (state is AzkarListInProgress) {
      final wasCompleted = state.isZikrCompleted(widget.index);
      cubit.incrementZikr(widget.index);

      final newState = cubit.state;
      if (newState is AzkarListInProgress &&
          !wasCompleted &&
          newState.isZikrCompleted(widget.index)) {
        HapticFeedback.vibrate();
        Future.delayed(
          const Duration(milliseconds: 200),
          HapticFeedback.vibrate,
        );

        if (widget.onCompleted != null) {
          widget.onCompleted!();
        }
      }
    }
  }

  Future<void> _shareCard() async {
    try {
      final imageBytes = await WidgetToImage.capture(
        context: context,
        widget: ZikrShareCard(
          text: widget.zikr.text,
          subText: widget.zikr.subText,
        ),
      );

      if (imageBytes == null) return;
      await sl<ShareService>().shareImage(imageBytes, text: widget.zikr.text);
    } catch (e) {
      debugPrint('Error sharing card: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AzkarListCubit, AzkarListState>(
      buildWhen: (previous, current) {
        if (previous is AzkarListInProgress && current is AzkarListInProgress) {
          return previous.getCurrentCount(widget.index) !=
              current.getCurrentCount(widget.index);
        }
        return previous != current;
      },
      builder: (context, state) {
        if (state is! AzkarListInProgress) {
          return const SizedBox.shrink();
        }

        final currentCount = state.getCurrentCount(widget.index);
        final progress = state.getProgress(widget.index);
        final isCompleted = state.isZikrCompleted(widget.index);
        final remainingCount = widget.zikr.count - currentCount;

        return RepaintBoundary(
          child: GestureDetector(
            onLongPress: isCompleted ? null : _handlePress,
            onTap: isCompleted ? null : _handlePress,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: isCompleted
                    ? Colors.white.withOpacity(0.02)
                    : AppColors.secondaryBackground.withOpacity(0.4),
                border: Border.all(
                  color: isCompleted
                      ? AppColors.gold.withOpacity(0.05)
                      : AppColors.gold.withOpacity(0.15),
                  width: 1,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 400),
                      opacity: isCompleted ? 0.5 : 1.0,
                      child: AnimatedScale(
                        duration: const Duration(milliseconds: 400),
                        scale: isCompleted ? 0.98 : 1.0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            ZikrContent(
                              text: widget.zikr.text,
                              subText: widget.zikr.subText,
                            ),
                            const SizedBox(height: 24),
                            const CustomAppDivider(),
                            const SizedBox(height: 24),
                            ZikrActionsRow(
                              text: widget.zikr.text,
                              remainingCount: remainingCount,
                              progress: progress,
                              isCompleted: isCompleted,
                              onShare: _shareCard,
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
      },
    );
  }
}

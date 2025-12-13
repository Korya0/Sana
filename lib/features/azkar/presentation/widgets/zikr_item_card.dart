// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/di/service_locator.dart';
import 'package:sana/core/services/share_service.dart';
import 'package:sana/core/utils/widget_to_image.dart';
import 'package:sana/features/azkar/presentation/widgets/zikr_card/zikr_share_card.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:sana/features/azkar/domain/entities/zikr.dart';
import 'package:sana/features/azkar/presentation/cubit/azkar_list_cubit.dart';
import 'package:sana/features/azkar/presentation/cubit/azkar_list_state.dart';
import 'package:sana/core/common/widgets/islamic_divider.dart';
import 'package:sana/features/azkar/presentation/widgets/zikr_card/zikr_actions_row.dart';
import 'package:sana/features/azkar/presentation/widgets/zikr_card/zikr_content.dart';

class ZikrItemCard extends StatefulWidget {
  final Zikr zikr;
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

    // Switch to standard vibrate as it's more universally supported
    HapticFeedback.vibrate();

    final cubit = context.read<AzkarListCubit>();
    final state = cubit.state;

    if (state is AzkarListInProgress) {
      final wasCompleted = state.isZikrCompleted(widget.index);

      cubit.incrementZikr(widget.index);

      // Check if just completed
      final newState = cubit.state;
      if (newState is AzkarListInProgress &&
          !wasCompleted &&
          newState.isZikrCompleted(widget.index)) {
        // Double vibration on completion
        HapticFeedback.vibrate();
        Future.delayed(const Duration(milliseconds: 200), () {
          HapticFeedback.vibrate();
        });

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
        final remainingCount = widget.zikr.totalCount - currentCount;

        return AnimatedOpacity(
          duration: const Duration(milliseconds: 300),
          opacity: isCompleted ? 0.5 : 1.0,
          child: GestureDetector(
            onTap: isCompleted ? null : _handlePress,
            child: Container(
              margin: EdgeInsets.only(bottom: (16)),
              padding: EdgeInsets.all((20)),
              decoration: BoxDecoration(
                color: AppColors.secondaryBackground,
                borderRadius: BorderRadius.circular((16)),
                border: Border.all(
                  color: isCompleted
                      ? AppColors.gold.withOpacity(0.1)
                      : AppColors.gold.withOpacity(0.2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Zikr text at top center
                  ZikrContent(
                    text: widget.zikr.text,
                    subText: widget.zikr.subText,
                  ),

                  SizedBox(height: (24)),

                  // Islamic Divider
                  const CustomAppDivider(),

                  SizedBox(height: (24)),

                  // Counter and buttons row at bottom
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
        );
      },
    );
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/utils/context_extension.dart';
import 'package:sana/core/widgets/app_gap.dart';
import 'package:sana/core/widgets/buttons/app_button.dart';
import 'package:sana/core/widgets/interaction/app_pressable.dart';
import 'package:sana/features/azkar/domain/entities/tasbeeh_item_entity.dart';
import 'package:sana/features/azkar/presentation/widgets/common/tasbeeh_counter_widgets.dart';

class TasbeehRecentItem extends StatefulWidget {
  const TasbeehRecentItem({
    required this.item,
    required this.onContinue,
    required this.onOpenAll,
    super.key,
  });

  final TasbeehItemEntity item;
  final VoidCallback onContinue;
  final VoidCallback onOpenAll;

  @override
  State<TasbeehRecentItem> createState() => _TasbeehRecentItemState();
}

class _TasbeehRecentItemState extends State<TasbeehRecentItem>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final Animation<double> _pulse;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: AppConstants.animationSlower500ms,
    );
    _pulse = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 1.05),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.05, end: 1.0),
        weight: 1,
      ),
    ]).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeOut),
    );
    unawaited(_pulseController.forward());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (context.reduceMotion) _pulseController.value = 1;
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      AppPressable(
        onPressed: widget.onContinue,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: AppSize.p8),
          child: Row(
            children: [
              ScaleTransition(
                key: const ValueKey('tasbeeh_counter_pulse'),
                scale: _pulse,
                child: TasbeehCounter(
                  currentCount: widget.item.currentCount,
                  targetCount: widget.item.targetCount,
                  dimension: AppSize.h64,
                  strokeWidth: AppSize.progressStrokeWidthLarge,
                  numberStyle: AppTextStyles.font20W700Brand(context),
                ),
              ),
              AppGap.w(AppSize.p12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.item.text,
                      maxLines: AppConstants.maxTwoLines,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.font16W700Primary(context),
                    ),
                    if (widget.item.targetCount != null) ...[
                      AppGap.h(AppSize.p4),
                      Text(
                        AppStrings.remainingCountOfTotal(
                          widget.item.remaining,
                          widget.item.targetCount!,
                        ),
                        style: AppTextStyles.font12W500Secondary(context),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      AppGap.h(AppSize.p16),
      Row(
        children: [
          Expanded(
            child: AppButton(
              label: AppStrings.continueTasbeeh,
              onPressed: widget.onContinue,
              expand: true,
            ),
          ),
          AppGap.w(AppSize.p8),
          Expanded(
            child: AppButton(
              label: AppStrings.allTasbeeh,
              onPressed: widget.onOpenAll,
              variant: AppButtonVariant.secondary,
              expand: true,
            ),
          ),
        ],
      ),
    ],
  );
}

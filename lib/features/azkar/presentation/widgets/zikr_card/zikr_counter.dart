import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/theme/colors/app_colors_common.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/icons/app_icons.dart';
import 'package:sana/core/utils/context_extension.dart';

class ZikrCounter extends StatefulWidget {
  const ZikrCounter({
    required this.remainingCount,
    required this.progress,
    required this.isCompleted,
    super.key,
  });

  final int remainingCount;
  final double progress;
  final bool isCompleted;

  @override
  State<ZikrCounter> createState() => _ZikrCounterState();
}

class _ZikrCounterState extends State<ZikrCounter>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late Animation<double> _animation;
  CurvedAnimation? _curve;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppConstants.animationNormal300ms,
    );
    _animation = _animate(widget.progress, widget.progress);
    unawaited(_controller.forward());
  }

  @override
  void didUpdateWidget(ZikrCounter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.progress == widget.progress) return;

    _animation = _animate(_animation.value, widget.progress);
    unawaited(_controller.forward(from: 0));
  }

  @override
  void dispose() {
    _curve?.dispose();
    _controller.dispose();
    super.dispose();
  }

  Animation<double> _animate(double begin, double end) {
    _curve?.dispose();
    _curve = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
    return Tween<double>(begin: begin, end: end).animate(_curve!);
  }

  @override
  Widget build(BuildContext context) {
    final ringSize = AppSize.h56;

    return SizedBox.square(
      dimension: ringSize,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Track
          SizedBox.square(
            dimension: ringSize,
            child: CircularProgressIndicator(
              value: AppConstants.progressComplete,
              strokeWidth: AppSize.progressStrokeWidth,
              color: context.color.dividerColor,
            ),
          ),

          // Progress
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) => SizedBox.square(
              dimension: ringSize,
              child: CircularProgressIndicator(
                value: _animation.value,
                strokeWidth: AppSize.progressStrokeWidth,
                strokeCap: StrokeCap.round,
                backgroundColor: AppColorsCommon.transparent,
                valueColor: AlwaysStoppedAnimation<Color>(
                  context.color.primary,
                ),
              ),
            ),
          ),

          // Remaining or done
          AnimatedSwitcher(
            duration: AppConstants.animationNormal300ms,
            transitionBuilder: (child, animation) =>
                ScaleTransition(scale: animation, child: child),
            child: widget.isCompleted
                ? Icon(
                    AppIcons.checkCircle,
                    key: const ValueKey('zikr_counter_done'),
                    size: AppSize.icon32,
                    color: context.color.iconPrimary,
                  )
                : Text(
                    '${widget.remainingCount}',
                    key: ValueKey(widget.remainingCount),
                    maxLines: AppConstants.maxOneLine,
                    overflow: TextOverflow.ellipsis,
                    style:
                        widget.remainingCount > AppConstants.counterCompactLimit
                        ? AppTextStyles.font20W700Brand(context)
                        : AppTextStyles.font24W700Brand(context),
                  ),
          ),
        ],
      ),
    );
  }
}

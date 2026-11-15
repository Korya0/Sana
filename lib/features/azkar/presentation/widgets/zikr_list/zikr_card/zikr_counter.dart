import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/icons/app_icons.dart';
import 'package:sana/core/utils/context_extension.dart';
import 'package:sana/features/azkar/presentation/widgets/zikr_list/zikr_card/rolling_number_text.dart';
import 'package:sana/features/azkar/presentation/widgets/zikr_list/zikr_card/zikr_progress_ring.dart';

class ZikrCounter extends StatefulWidget {
  // Creates counter
  const ZikrCounter({
    required this.completedCount,
    required this.totalCount,
    super.key,
  });

  final int completedCount;
  final int totalCount;

  @override
  State<ZikrCounter> createState() => _ZikrCounterState();
}

class _ZikrCounterState extends State<ZikrCounter>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late Animation<double> _animation;
  CurvedAnimation? _curve;
  bool _reduceMotion = false;

  // Returns remaining
  int get _remainingCount => widget.totalCount - widget.completedCount;

  // Checks completion
  bool get _isCompleted => widget.completedCount >= widget.totalCount;

  // Returns progress
  double get _progress => _progressOf(widget);

  // Initializes state
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppConstants.animationNormal300ms,
    );

    final progress = _progress;
    _animation = _animate(progress, progress);
  }

  // Updates motion
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final reduceMotion = context.reduceMotion;
    if (reduceMotion == _reduceMotion) return;

    _reduceMotion = reduceMotion;
    if (_reduceMotion && _controller.isAnimating) {
      _controller.value = AppConstants.progressComplete;
    }
  }

  // Updates progress
  @override
  void didUpdateWidget(ZikrCounter oldWidget) {
    super.didUpdateWidget(oldWidget);
    final progress = _progress;
    if (_progressOf(oldWidget) == progress) return;

    _animation = _animate(_animation.value, progress);
    if (_reduceMotion) {
      _controller.value = AppConstants.progressComplete;
      return;
    }

    unawaited(_controller.forward(from: 0));
  }

  // Disposes state
  @override
  void dispose() {
    _curve?.dispose();
    _controller.dispose();
    super.dispose();
  }

  // Calculates progress
  double _progressOf(ZikrCounter counter) {
    if (counter.totalCount <= 0) return AppConstants.progressStart;

    return (counter.completedCount / counter.totalCount)
        .clamp(0.0, 1.0)
        .toDouble();
  }

  // Builds animation
  Animation<double> _animate(double begin, double end) {
    _curve?.dispose();
    _curve = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
    return Tween<double>(begin: begin, end: end).animate(_curve!);
  }

  // Builds counter
  @override
  Widget build(BuildContext context) {
    final animate = !_reduceMotion;
    final isCompleted = _isCompleted;

    return RepaintBoundary(
      child: SizedBox.square(
        dimension: AppSize.h56,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Track
            ZikrProgressRing(
              value: AppConstants.progressComplete,
              color: context.color.dividerColor,
            ),

            // Progress
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) => ZikrProgressRing(
                value: _animation.value,
                color: context.color.primary,
                strokeCap: StrokeCap.round,
              ),
            ),

            // Value
            AnimatedSwitcher(
              duration: animate
                  ? AppConstants.animationFast200ms
                  : Duration.zero,
              switchInCurve: Curves.easeOutCubic,
              switchOutCurve: Curves.easeOutCubic,
              transitionBuilder: (child, animation) =>
                  FadeTransition(opacity: animation, child: child),
              child: isCompleted
                  ? Icon(
                      AppIcons.checkCircle,
                      key: const ValueKey('zikr_counter_done'),
                      size: AppSize.icon32,
                      color: context.color.iconPrimary,
                    )
                  : RollingNumberText(
                      key: const ValueKey('zikr_counter_number'),
                      value: '$_remainingCount',
                      style: _remainingCount > AppConstants.counterCompactLimit
                          ? AppTextStyles.font20W700Brand(context)
                          : AppTextStyles.font24W700Brand(context),
                      animate: animate,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

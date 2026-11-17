import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/icons/app_icons.dart';
import 'package:sana/core/utils/context_extension.dart';
import 'package:sana/features/azkar/presentation/widgets/common/rolling_number_text.dart';
import 'package:sana/features/azkar/presentation/widgets/common/progress_ring.dart';

class CounterRing extends StatefulWidget {
  // Creates counter
  const CounterRing({
    required this.currentCount,
    super.key,
    this.targetCount,
    this.dimension,
    this.strokeWidth,
    this.numberStyle,
    this.numberKeyBuilder,
    this.doneKey = const ValueKey('counter_done'),
  });

  final int currentCount;
  final int? targetCount;
  final double? dimension;
  final double? strokeWidth;
  final TextStyle? numberStyle;
  final Key Function(int display)? numberKeyBuilder;
  final Key doneKey;

  @override
  State<CounterRing> createState() => _CounterRingState();
}

class _CounterRingState extends State<CounterRing>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late Animation<double> _animation;
  CurvedAnimation? _curve;
  bool _reduceMotion = false;

  // Checks target
  bool get _hasTarget => widget.targetCount != null;

  // Checks completion
  bool get _isCompleted =>
      _hasTarget && widget.currentCount >= widget.targetCount!;

  // Returns display
  int get _displayValue => _hasTarget
      ? (widget.targetCount! - widget.currentCount).clamp(0, 1 << 30)
      : widget.currentCount;

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
  void didUpdateWidget(CounterRing oldWidget) {
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
  double _progressOf(CounterRing counter) {
    final target = counter.targetCount;
    if (target == null || target <= 0) return AppConstants.progressStart;
    return (counter.currentCount / target).clamp(0.0, 1.0).toDouble();
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
    final display = _displayValue;
    final size = widget.dimension ?? AppSize.h56;
    final numberKey =
        widget.numberKeyBuilder?.call(display) ?? ValueKey('counter_$display');

    return RepaintBoundary(
      child: SizedBox.square(
        dimension: size,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Track
            ProgressRing(
              value: AppConstants.progressComplete,
              color: context.color.dividerColor,
              dimension: size,
              strokeWidth: widget.strokeWidth,
            ),

            // Progress
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) => ProgressRing(
                value: _animation.value,
                color: context.color.primary,
                strokeCap: StrokeCap.round,
                dimension: size,
                strokeWidth: widget.strokeWidth,
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
                      key: widget.doneKey,
                      size: AppSize.icon32,
                      color: context.color.iconPrimary,
                    )
                  : RollingNumberText(
                      key: numberKey,
                      value: '$display',
                      style:
                          widget.numberStyle ??
                          (display > AppConstants.counterCompactLimit
                              ? AppTextStyles.font20W700Brand(context)
                              : AppTextStyles.font24W700Brand(context)),
                      animate: animate,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

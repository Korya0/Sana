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

  int get _remainingCount => widget.totalCount - widget.completedCount;

  bool get _isCompleted => widget.completedCount >= widget.totalCount;

  double get _progress => _progressOf(widget);

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

  @override
  void dispose() {
    _curve?.dispose();
    _controller.dispose();
    super.dispose();
  }

  double _progressOf(ZikrCounter counter) {
    if (counter.totalCount <= 0) return AppConstants.progressStart;

    return (counter.completedCount / counter.totalCount)
        .clamp(0.0, 1.0)
        .toDouble();
  }

  Animation<double> _animate(double begin, double end) {
    _curve?.dispose();
    _curve = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
    return Tween<double>(begin: begin, end: end).animate(_curve!);
  }

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
            _ProgressRing(
              value: AppConstants.progressComplete,
              color: context.color.dividerColor,
            ),

            // Progress
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) => _ProgressRing(
                value: _animation.value,
                color: context.color.primary,
                strokeCap: StrokeCap.round,
              ),
            ),

            // Remaining or done
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
                  : _RollingNumber(
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

class _ProgressRing extends StatelessWidget {
  const _ProgressRing({
    required this.value,
    required this.color,
    this.strokeCap = StrokeCap.butt,
  });

  final double value;
  final Color color;
  final StrokeCap strokeCap;

  @override
  Widget build(BuildContext context) => SizedBox.square(
    dimension: AppSize.h56,
    child: CircularProgressIndicator(
      value: value,
      strokeWidth: AppSize.progressStrokeWidth,
      strokeCap: strokeCap,
      backgroundColor: AppColorsCommon.transparent,
      color: color,
    ),
  );
}

class _RollingNumber extends StatefulWidget {
  const _RollingNumber({
    required this.value,
    required this.style,
    required this.animate,
    super.key,
  });

  final String value;
  final TextStyle style;
  final bool animate;

  @override
  State<_RollingNumber> createState() => _RollingNumberState();
}

class _RollingNumberState extends State<_RollingNumber>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late String _incoming;
  String? _outgoing;
  final Map<String, Widget> _digits = {};
  TextStyle? _digitsStyle;
  double? _slotWidth;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppConstants.animationFast200ms,
    )..addStatusListener(_handleStatus);
    _incoming = widget.value;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _slotWidth = null;
  }

  @override
  void didUpdateWidget(covariant _RollingNumber oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.style != widget.style) {
      _digitsStyle = null;
      _slotWidth = null;
    }

    final changed = oldWidget.value != widget.value;
    if (changed) {
      _outgoing = widget.animate ? _incoming : null;
      _incoming = widget.value;
    }

    if (!widget.animate) {
      _controller.stop();
      _outgoing = null;
      return;
    }

    if (changed) _controller.forward(from: 0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      setState(() => _outgoing = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.animate) return _digitText(widget.value);

    final slotWidth = _slotWidthFor(context);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final outgoing = _outgoing;
        final incoming = _incoming;
        final slots = outgoing == null
            ? incoming.length
            : (outgoing.length > incoming.length
                  ? outgoing.length
                  : incoming.length);
        final offset = outgoing == null
            ? null
            : Curves.easeOutCubic.transform(_controller.value);

        return Row(
          mainAxisSize: MainAxisSize.min,
          textDirection: TextDirection.ltr,
          children: [
            for (var slot = 0; slot < slots; slot++)
              _digitSlot(
                slotWidth: slotWidth,
                oldDigit: outgoing == null
                    ? null
                    : _slotDigit(outgoing, slot, slots),
                newDigit: _slotDigit(incoming, slot, slots),
                offset: offset,
              ),
          ],
        );
      },
    );
  }

  // Only changed digits roll: the old one leaves downwards while the new one
  // enters from above, so both travel the same direction.
  Widget _digitSlot({
    required double slotWidth,
    required String? oldDigit,
    required String newDigit,
    required double? offset,
  }) {
    final old = oldDigit;
    final rolls = offset != null && old != null && old != newDigit;

    return SizedBox(
      width: slotWidth,
      child: ClipRect(
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (rolls)
              FractionalTranslation(
                translation: Offset(0, offset),
                child: _digitText(old),
              ),
            FractionalTranslation(
              translation: Offset(0, rolls ? offset - 1 : 0),
              child: _digitText(newDigit),
            ),
          ],
        ),
      ),
    );
  }

  // Digits are right-aligned by place value: the last character is the units.
  String _slotDigit(String digits, int slot, int slots) {
    final offset = slots - digits.length;
    return slot < offset ? ' ' : digits[slot - offset];
  }

  Widget _digitText(String value) {
    if (_digitsStyle != widget.style) {
      _digitsStyle = widget.style;
      _digits.clear();
    }

    return _digits.putIfAbsent(
      value,
      () => Text(
        value,
        maxLines: AppConstants.maxOneLine,
        style: widget.style,
      ),
    );
  }

  // Measured once per style and text scale, never per frame.
  double _slotWidthFor(BuildContext context) {
    final cached = _slotWidth;
    if (cached != null) return cached;

    final scaler = MediaQuery.textScalerOf(context);
    var width = 0.0;

    for (var digit = 0; digit <= 9; digit++) {
      final painter = TextPainter(
        text: TextSpan(text: '$digit', style: widget.style),
        textDirection: TextDirection.ltr,
        textScaler: scaler,
      )..layout();

      if (painter.width > width) width = painter.width;
      painter.dispose();
    }

    return _slotWidth = width;
  }
}

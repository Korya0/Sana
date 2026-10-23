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
    final animate = !context.reduceMotion;

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
            duration: animate ? AppConstants.animationFast200ms : Duration.zero,
            switchInCurve: Curves.easeOutCubic,
            switchOutCurve: Curves.easeOutCubic,
            transitionBuilder: (child, animation) =>
                FadeTransition(opacity: animation, child: child),
            child: widget.isCompleted
                ? Icon(
                    AppIcons.checkCircle,
                    key: const ValueKey('zikr_counter_done'),
                    size: AppSize.icon32,
                    color: context.color.iconPrimary,
                  )
                : _RollingNumber(
                    key: const ValueKey('zikr_counter_number'),
                    value: '${widget.remainingCount}',
                    style:
                        widget.remainingCount > AppConstants.counterCompactLimit
                        ? AppTextStyles.font20W700Brand(context)
                        : AppTextStyles.font24W700Brand(context),
                    animate: animate,
                  ),
          ),
        ],
      ),
    );
  }
}

/// Rolls the counter like a wheel of digits.
///
/// Only the digits that actually change roll: the old digit leaves downwards
/// while the new one enters from above, so both travel in the same direction.
/// Unchanged digits stay perfectly still (e.g. 27 -> 28 rolls the 8 only).
///
/// The widget is keyed by position, not by value, so its state survives a
/// change and can animate it. If a new value arrives mid-roll, the roll
/// restarts towards the latest value only.
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
  void didUpdateWidget(covariant _RollingNumber oldWidget) {
    super.didUpdateWidget(oldWidget);

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

    // Every digit gets the same slot, so a roll in one place never nudges the
    // other digits sideways.
    final slotWidth = _maxDigitWidth(context);

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
        final progress = outgoing == null
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
                progress: progress,
              ),
          ],
        );
      },
    );
  }

  Widget _digitSlot({
    required double slotWidth,
    required String? oldDigit,
    required String newDigit,
    required double? progress,
  }) {
    final old = oldDigit;
    final offset = progress;
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

  Widget _digitText(String value) =>
      Text(value, maxLines: AppConstants.maxOneLine, style: widget.style);

  double _maxDigitWidth(BuildContext context) {
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

    return width;
  }
}

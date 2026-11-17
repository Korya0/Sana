import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_constants.dart';

class RollingNumberText extends StatefulWidget {
  const RollingNumberText({
    required this.value,
    required this.style,
    required this.animate,
    super.key,
  });

  final String value;
  final TextStyle style;
  final bool animate;

  @override
  State<RollingNumberText> createState() => _RollingNumberTextState();
}

class _RollingNumberTextState extends State<RollingNumberText>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late String _incoming;
  String? _outgoing;
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

  // Resets cache
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _slotWidth = null;
  }

  // Updates state
  @override
  void didUpdateWidget(covariant RollingNumberText oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.style != widget.style) {
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
    if (!widget.animate) {
      return _DigitText(value: widget.value, style: widget.style);
    }

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
              _RollingDigitSlot(
                slotWidth: slotWidth,
                oldDigit: outgoing == null
                    ? null
                    : _slotDigit(outgoing, slot, slots),
                newDigit: _slotDigit(incoming, slot, slots),
                offset: offset,
                style: widget.style,
              ),
          ],
        );
      },
    );
  }

  // Digits are right-aligned by place value: the last character is the units.
  String _slotDigit(String digits, int slot, int slots) {
    final offset = slots - digits.length;
    return slot < offset ? ' ' : digits[slot - offset];
  }

  // Measures width
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

class _RollingDigitSlot extends StatelessWidget {
  const _RollingDigitSlot({
    required this.slotWidth,
    required this.oldDigit,
    required this.newDigit,
    required this.offset,
    required this.style,
  });

  final double slotWidth;
  final String? oldDigit;
  final String newDigit;
  final double? offset;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
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
                translation: Offset(0, offset!),
                child: _DigitText(value: old, style: style),
              ),
            FractionalTranslation(
              translation: Offset(0, rolls ? offset! - 1 : 0),
              child: _DigitText(value: newDigit, style: style),
            ),
          ],
        ),
      ),
    );
  }
}

class _DigitText extends StatelessWidget {
  const _DigitText({required this.value, required this.style});

  final String value;
  final TextStyle style;

  @override
  Widget build(BuildContext context) => Text(
    value,
    maxLines: AppConstants.maxOneLine,
    style: style,
  );
}

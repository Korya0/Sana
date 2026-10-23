import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_constants.dart';

class AppMarqueeText extends StatelessWidget {
  const AppMarqueeText({
    required this.text,
    required this.style,
    this.textAlign = TextAlign.center,
    super.key,
  });

  final String text;
  final TextStyle style;

  /// Used only while the text fits; a scrolling line always starts at its
  /// leading edge.
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final contentWidth = _measure(context);
      final distance = contentWidth - constraints.maxWidth;
      final scrolls =
          constraints.hasBoundedWidth &&
          constraints.maxWidth > 0 &&
          distance > 0 &&
          !(MediaQuery.maybeOf(context)?.disableAnimations ?? false);

      if (!scrolls) {
        return Text(
          text,
          textAlign: textAlign,
          maxLines: AppConstants.maxOneLine,
          overflow: TextOverflow.ellipsis,
          style: style,
        );
      }

      return _MarqueeTextWidget(
        text: text,
        style: style,
        contentWidth: contentWidth,
        viewportWidth: constraints.maxWidth,
      );
    },
  );

  // Width of one unbroken line, shaped and scaled exactly like the rendered text.
  double _measure(BuildContext context) {
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: DefaultTextStyle.of(context).style.merge(style),
      ),
      textDirection: Directionality.of(context),
      textScaler: MediaQuery.textScalerOf(context),
      maxLines: AppConstants.maxOneLine,
    )..layout();
    final width = painter.width;
    painter.dispose();
    return width;
  }
}

class _MarqueeTextWidget extends StatefulWidget {
  const _MarqueeTextWidget({
    required this.text,
    required this.style,
    required this.contentWidth,
    required this.viewportWidth,
  });

  final String text;
  final TextStyle style;
  final double contentWidth;
  final double viewportWidth;

  @override
  State<_MarqueeTextWidget> createState() => _MarqueeTextWidgetState();
}

class _MarqueeTextWidgetState extends State<_MarqueeTextWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late Animation<double> _offset;
  Timer? _pauseTimer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: _scrollDuration,
    )..addStatusListener(_handleStatus);
    _offset = _buildOffset();
    _scheduleScroll();
  }

  @override
  void didUpdateWidget(covariant _MarqueeTextWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.contentWidth != widget.contentWidth ||
        oldWidget.viewportWidth != widget.viewportWidth) {
      _restart();
    }
  }

  @override
  void dispose() {
    _pauseTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  // One direction only: leave the leading edge, then re-enter from the
  // trailing edge. The reset happens off-screen, so the loop has no jump.
  Animation<double> _buildOffset() => TweenSequence<double>([
    TweenSequenceItem(
      tween: Tween<double>(begin: 0, end: widget.contentWidth),
      weight: widget.contentWidth,
    ),
    TweenSequenceItem(
      tween: Tween<double>(begin: -widget.viewportWidth, end: 0),
      weight: widget.viewportWidth,
    ),
  ]).animate(_controller);

  void _restart() {
    _pauseTimer?.cancel();
    _controller
      ..stop()
      ..duration = _scrollDuration
      ..reset();
    _offset = _buildOffset();
    _scheduleScroll();
  }

  // Read while the text rests, so the pause costs no frames.
  Duration get _scrollDuration {
    final travel = widget.contentWidth + widget.viewportWidth;
    final ms = (travel / AppConstants.marqueeSpeedPxPerSecond * 1000).round();
    return Duration(milliseconds: ms < 1 ? 1 : ms);
  }

  void _scheduleScroll() {
    _pauseTimer?.cancel();
    _pauseTimer = Timer(AppConstants.marqueePause1000ms, _play);
  }

  void _play() {
    if (mounted) _controller.forward(from: 0);
  }

  void _handleStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed) _scheduleScroll();
  }

  @override
  Widget build(BuildContext context) {
    // RTL leaves to the right and re-enters from the left; LTR is mirrored.
    final direction = Directionality.of(context) == TextDirection.rtl
        ? 1.0
        : -1.0;

    return RepaintBoundary(
      child: ClipRect(
        child: AnimatedBuilder(
          animation: _offset,
          builder: (context, child) => Transform.translate(
            offset: Offset(_offset.value * direction, 0),
            child: child,
          ),
          child: Align(
            alignment: AlignmentDirectional.centerStart,
            heightFactor: 1,
            child: SizedBox(
              width: widget.contentWidth,
              child: Text(
                widget.text,
                maxLines: AppConstants.maxOneLine,
                softWrap: false,
                overflow: TextOverflow.visible,
                style: widget.style,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

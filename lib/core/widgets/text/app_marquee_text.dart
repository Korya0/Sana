import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/core/widgets/app_gap.dart';

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
      final textWidth = _measureWidth(context);
      final scrolls =
          constraints.hasBoundedWidth &&
          constraints.maxWidth > 0 &&
          textWidth > constraints.maxWidth;

      if (!scrolls) {
        return Text(
          text,
          textAlign: textAlign,
          maxLines: AppConstants.maxOneLine,
          overflow: TextOverflow.ellipsis,
          style: style,
        );
      }

      return _MarqueeScrollerWidget(
        text: text,
        style: style,
        contentWidth: textWidth,
        viewportWidth: constraints.maxWidth,
      );
    },
  );

  // Width of one unbroken line, shaped and scaled like the rendered text.
  double _measureWidth(BuildContext context) {
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

class _MarqueeScrollerWidget extends StatefulWidget {
  const _MarqueeScrollerWidget({
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
  State<_MarqueeScrollerWidget> createState() => _MarqueeScrollerWidgetState();
}

class _MarqueeScrollerWidgetState extends State<_MarqueeScrollerWidget>
    with SingleTickerProviderStateMixin {
  final _scroll = ScrollController();
  late final _controller = AnimationController(vsync: this)
    ..addListener(_onTick);
  double _pauseFraction = 0;

  double get _gap => widget.viewportWidth * AppConstants.marqueeBlankRatio;

  double get _cycle => widget.contentWidth + _gap;

  @override
  void initState() {
    super.initState();
    _start();
  }

  @override
  void didUpdateWidget(covariant _MarqueeScrollerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.contentWidth != widget.contentWidth ||
        oldWidget.viewportWidth != widget.viewportWidth) {
      _start();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _scroll.dispose();
    super.dispose();
  }

  // One loop = pause + linear travel of one cycle.
  void _start() {
    final pauseMs = AppConstants.marqueePause2s.inMilliseconds;
    final travelMs = (_cycle / AppConstants.marqueeSpeedPxPerSecond * 1000)
        .round();
    final safeTravelMs = travelMs < 1 ? 1 : travelMs;

    _pauseFraction = pauseMs / (pauseMs + safeTravelMs);
    _controller
      ..value = 0
      ..duration = Duration(milliseconds: pauseMs + safeTravelMs)
      ..repeat();
  }

  void _onTick() {
    if (!_scroll.hasClients || !_scroll.position.hasContentDimensions) return;
    final t = ((_controller.value - _pauseFraction) / (1 - _pauseFraction))
        .clamp(0.0, 1.0);
    _scroll.jumpTo(t * _cycle);
  }

  @override
  Widget build(BuildContext context) => RepaintBoundary(
    child: SingleChildScrollView(
      controller: _scroll,
      scrollDirection: Axis.horizontal,
      physics: const NeverScrollableScrollPhysics(),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Two copies + one cycle = seamless wrap
          _MarqueeLabelWidget(text: widget.text, style: widget.style),
          AppGap.w(_gap),
          ExcludeSemantics(
            child: _MarqueeLabelWidget(text: widget.text, style: widget.style),
          ),
        ],
      ),
    ),
  );
}

class _MarqueeLabelWidget extends StatelessWidget {
  const _MarqueeLabelWidget({required this.text, required this.style});

  final String text;
  final TextStyle style;

  @override
  Widget build(BuildContext context) => Text(
    text,
    maxLines: AppConstants.maxOneLine,
    softWrap: false,
    overflow: TextOverflow.visible,
    style: style,
  );
}

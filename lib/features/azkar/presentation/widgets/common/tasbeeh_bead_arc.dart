import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/utils/context_extension.dart';

class TasbeehBeadArc extends StatefulWidget {
  const TasbeehBeadArc({
    required this.progress,
    required this.activeColor,
    required this.inactiveColor,
    super.key,
  });

  final double progress;
  final Color activeColor;
  final Color inactiveColor;

  @override
  State<TasbeehBeadArc> createState() => _TasbeehBeadArcState();
}

class _TasbeehBeadArcState extends State<TasbeehBeadArc>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late Animation<double> _progress;
  bool _reduceMotion = false;

  double get _target => widget.progress.clamp(0.0, 1.0);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppConstants.tasbeehGaugeFill1400ms,
    );
    _progress = _animate(AppConstants.progressStart, _target);
    unawaited(_controller.forward(from: AppConstants.progressStart));
  }

  // Skips motion when the user asked for less
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final reduceMotion = context.reduceMotion;
    if (reduceMotion == _reduceMotion) return;
    _reduceMotion = reduceMotion;
    if (_reduceMotion) _controller.value = AppConstants.progressComplete;
  }

  // Fills from the current value to the new one
  @override
  void didUpdateWidget(covariant TasbeehBeadArc oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.progress == widget.progress) return;

    _progress = _animate(_progress.value, _target);
    if (_reduceMotion) {
      _controller.value = AppConstants.progressComplete;
      return;
    }
    unawaited(_controller.forward(from: AppConstants.progressStart));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Animation<double> _animate(double begin, double end) => Tween<double>(
    begin: begin,
    end: end,
  ).chain(CurveTween(curve: Curves.easeOutCubic)).animate(_controller);

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _progress,
    builder: (context, child) => CustomPaint(
      painter: _BeadArcPainter(
        progress: _progress.value,
        activeColor: widget.activeColor,
        inactiveColor: widget.inactiveColor,
        isRtl: Directionality.of(context) == TextDirection.rtl,
      ),
    ),
  );
}

class _BeadArcPainter extends CustomPainter {
  const _BeadArcPainter({
    required this.progress,
    required this.activeColor,
    required this.inactiveColor,
    required this.isRtl,
  });

  final double progress;
  final Color activeColor;
  final Color inactiveColor;
  final bool isRtl;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(
      size.width / 2,
      size.height * AppConstants.beadArcCenterYRatio,
    );
    final radiusX = size.width * AppConstants.beadArcRadiusXRatio;
    final radiusY = size.height * AppConstants.beadArcRadiusYRatio;
    final beads = [
      for (var i = 0; i < AppConstants.tasbeehBeadCount; i++)
        _beadOffset(i, center, radiusX, radiusY),
    ];

    // Guide arc
    canvas.drawPath(
      Path()..addPolygon(beads, false),
      Paint()
        ..color = inactiveColor.withValues(alpha: AppConstants.opacityGhost)
        ..style = PaintingStyle.stroke
        ..strokeWidth = AppSize.borderWidth,
    );

    // Beads fill one by one, the leading bead fading in
    final beadRadius = AppSize.r4 * AppConstants.beadArcBeadRadiusRatio;
    final litBeads = progress * beads.length;
    final beadPaint = Paint();

    for (var i = 0; i < beads.length; i++) {
      final fill = (litBeads - i).clamp(0.0, 1.0);
      beadPaint.color = Color.lerp(inactiveColor, activeColor, fill)!;
      canvas.drawCircle(beads[i], beadRadius, beadPaint);
    }
  }

  Offset _beadOffset(int index, Offset center, double radiusX, double radiusY) {
    final t = index / (AppConstants.tasbeehBeadCount - 1);
    final angle = isRtl ? math.pi + t * math.pi : 2 * math.pi - t * math.pi;

    return Offset(
      center.dx + radiusX * math.cos(angle),
      center.dy + radiusY * math.sin(angle),
    );
  }

  @override
  bool shouldRepaint(covariant _BeadArcPainter oldDelegate) =>
      oldDelegate.progress != progress ||
      oldDelegate.isRtl != isRtl ||
      oldDelegate.activeColor != activeColor ||
      oldDelegate.inactiveColor != inactiveColor;
}

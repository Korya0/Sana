import 'dart:math' as math;
import 'package:flutter/material.dart';

class WaterWaveWidget extends StatefulWidget {
  final Color color;
  final Duration duration;
  final double waveAmplitude;
  final double waveFrequency;

  /// 0.0 means the water level is at the very top.
  /// 1.0 means the water level is at the very bottom.
  final double heightPercent;

  const WaterWaveWidget({
    super.key,
    required this.color,
    this.duration = const Duration(seconds: 4),
    this.waveAmplitude = 10.0,
    this.waveFrequency = 1.0,
    this.heightPercent = 0.5,
  });

  @override
  State<WaterWaveWidget> createState() => _WaterWaveWidgetState();
}

class _WaterWaveWidgetState extends State<WaterWaveWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..repeat();
  }

  @override
  void didUpdateWidget(WaterWaveWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.duration != widget.duration) {
      _controller.duration = widget.duration;
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return CustomPaint(
              painter: _WaterWavePainter(
                animationValue: _controller.value,
                color: widget.color,
                waveAmplitude: widget.waveAmplitude,
                waveFrequency: widget.waveFrequency,
                heightPercent: widget.heightPercent,
              ),
              size: Size(constraints.maxWidth, constraints.maxHeight),
            );
          },
        );
      },
    );
  }
}

class _WaterWavePainter extends CustomPainter {
  final double animationValue;
  final Color color;
  final double waveAmplitude;
  final double waveFrequency;
  final double heightPercent;

  _WaterWavePainter({
    required this.animationValue,
    required this.color,
    required this.waveAmplitude,
    required this.waveFrequency,
    required this.heightPercent,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Use a defined logical height based on percentage
    // e.g. 0.0 -> Top of widget, 1.0 -> Bottom of widget
    final baseLevel = size.height * heightPercent;

    // Wave 1 (Background)
    final path1 = Path();
    path1.moveTo(0, size.height);
    path1.lineTo(0, baseLevel);

    for (double i = 0; i <= size.width; i++) {
      path1.lineTo(
        i,
        baseLevel +
            math.sin(
                  (i / size.width * 2 * math.pi * waveFrequency) +
                      (animationValue * 2 * math.pi),
                ) *
                waveAmplitude,
      );
    }
    path1.lineTo(size.width, size.height);
    path1.lineTo(0, size.height);
    path1.close();

    canvas.drawPath(path1, paint..color = color.withOpacity(0.2));

    // Wave 2 (Foreground) - Slightly offset by phase and vertical position or just phase
    final path2 = Path();
    // Putting the second wave slightly lower or higher? Usually same level but different phase looks good.
    // Or slightly lower to create depth.
    final baseLevel2 = baseLevel + (waveAmplitude * 0.2);

    path2.moveTo(0, size.height);
    path2.lineTo(0, baseLevel2);

    for (double i = 0; i <= size.width; i++) {
      path2.lineTo(
        i,
        baseLevel2 +
            math.sin(
                  (i / size.width * 2 * math.pi * waveFrequency) +
                      (animationValue * 2 * math.pi) +
                      2.0,
                ) * // Phase shift
                waveAmplitude,
      );
    }
    path2.lineTo(size.width, size.height);
    path2.lineTo(0, size.height);
    path2.close();

    canvas.drawPath(path2, paint..color = color.withOpacity(0.4));
  }

  @override
  bool shouldRepaint(covariant _WaterWavePainter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
        oldDelegate.color != color ||
        oldDelegate.waveAmplitude != waveAmplitude ||
        oldDelegate.waveFrequency != waveFrequency ||
        oldDelegate.heightPercent != heightPercent;
  }
}

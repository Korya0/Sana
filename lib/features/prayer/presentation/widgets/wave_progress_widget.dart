import 'dart:math' as math;
import 'package:flutter/material.dart';

class WaveProgressWidget extends StatefulWidget {
  final double progress;
  final Color color;

  const WaveProgressWidget({
    super.key,
    required this.progress,
    required this.color,
  });

  @override
  State<WaveProgressWidget> createState() => _WaveProgressWidgetState();
}

class _WaveProgressWidgetState extends State<WaveProgressWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            painter: _WavePainter(
              animationValue: _controller.value,
              progress: widget.progress,
              color: widget.color,
            ),
            child: Container(),
          );
        },
      ),
    );
  }
}

class _WavePainter extends CustomPainter {
  final double animationValue;
  final double progress;
  final Color color;

  _WavePainter({
    required this.animationValue,
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0.0) return;

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();

    // We want to fill from the bottom up
    // progress 0.0 -> height at bottom
    // progress 1.0 -> height at top

    final double baseHeight = size.height * (1 - progress);

    // Wave parameters
    // Reducing amplitude as it fills to avoid clipping at the very top effectively
    // or just allow it.
    const double waveHeight = 8.0;
    final double waveLength = size.width;

    path.moveTo(0, baseHeight);

    for (double i = 0.0; i <= size.width; i++) {
      // Simple sine wave
      // x is i
      // y varies around baseHeight
      // Animation moves the phase
      final dx = i;
      final dy =
          baseHeight +
          math.sin(
                (i / waveLength * 2 * math.pi) + (animationValue * 2 * math.pi),
              ) *
              waveHeight;

      path.lineTo(dx, dy);
    }

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_WavePainter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
        oldDelegate.progress != progress ||
        oldDelegate.color != color;
  }
}

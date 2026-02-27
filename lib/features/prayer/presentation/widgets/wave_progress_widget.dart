import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:sana/core/theme/style/app_colors.dart';

class WaveProgressWidget extends StatefulWidget {
  const WaveProgressWidget({
    super.key,
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
    );
    unawaited(_controller.repeat());
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
              // Decorative constant height (35% of container height)
              progress: 0.55,
              color: AppColors.green.withValues(alpha: 0.25),
            ),
            child: const SizedBox.expand(),
          );
        },
      ),
    );
  }
}

class _WavePainter extends CustomPainter {
  _WavePainter({
    required this.animationValue,
    required this.progress,
    required this.color,
  });
  final double animationValue;
  final double progress;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0.0) return;

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();

    // The user wants it to be decorative/random-ish
    // We'll still use the progress for a general "fill level" but simplified
    final baseHeight = size.height * (1 - progress);

    // Optimized wave drawing: draw every 10 pixels instead of every 1
    const step = 10.0;
    const waveHeight = 6.0;
    final waveLength = size.width;

    path.moveTo(0, baseHeight);

    for (double i = 0; i <= size.width; i += step) {
      final dx = i;
      final dy =
          baseHeight +
          math.sin(
                (i / waveLength * 2 * math.pi) + (animationValue * 2 * math.pi),
              ) *
              waveHeight;
      path.lineTo(dx, dy);
    }

    // Ensure it hits the end
    path.lineTo(
      size.width,
      baseHeight +
          math.sin(
                (size.width / waveLength * 2 * math.pi) +
                    (animationValue * 2 * math.pi),
              ) *
              waveHeight,
    );

    path
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_WavePainter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
        oldDelegate.progress != progress ||
        oldDelegate.color != color;
  }
}

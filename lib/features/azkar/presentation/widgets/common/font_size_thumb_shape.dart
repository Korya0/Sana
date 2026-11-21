import 'package:flutter/material.dart';

class FontSizeThumbShape extends SliderComponentShape {
  const FontSizeThumbShape({
    required this.min,
    required this.max,
    required this.radius,
    required this.backgroundColor,
    required this.textStyle,
  });

  final double min;
  final double max;
  final double radius;
  final Color backgroundColor;
  final TextStyle textStyle;

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) =>
      Size.fromRadius(radius);

  // Paints thumb
  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final canvas = context.canvas;
    // Grow the thumb with the text scale so the scaled label stays inside it.
    final scaledRadius = radius * textScaleFactor;
    canvas.drawCircle(center, scaledRadius, Paint()..color = backgroundColor);

    final currentSize = min + (max - min) * value;
    final textPainter = TextPainter(
      text: TextSpan(
        text: '${currentSize.round()}',
        style: textStyle,
      ),
      textDirection: textDirection,
      textAlign: TextAlign.center,
      textScaler: TextScaler.linear(textScaleFactor),
    )..layout();

    textPainter.paint(
      canvas,
      center - Offset(textPainter.width / 2, textPainter.height / 2),
    );
  }
}

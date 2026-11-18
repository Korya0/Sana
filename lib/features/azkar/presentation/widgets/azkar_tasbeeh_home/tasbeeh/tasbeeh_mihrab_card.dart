import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/utils/context_extension.dart';

/// Islamic Mihrab Arch container for the Tasbeeh home section.
/// Provides an arched top with decorative Islamic arabesque watermark
/// and gold/brand border styling.
class TasbeehMihrabCard extends StatelessWidget {
  const TasbeehMihrabCard({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final borderColor = context.color.borderBrand.withValues(
      alpha: AppConstants.opacitySubtle,
    );
    final surfaceColor = context.color.secondaryScaffoldBackgroundColor;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSize.r26 * 1.5),
          bottom: Radius.circular(AppSize.r24),
        ),
        border: Border.all(
          color: borderColor,
          width: AppSize.borderWidth,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSize.r26 * 1.5),
          bottom: Radius.circular(AppSize.r24),
        ),
        child: Stack(
          children: [
            // Decorative Arabesque Watermark
            Positioned(
              top: -AppSize.h18,
              left: 0,
              right: 0,
              child: Center(
                child: CustomPaint(
                  size: Size(AppSize.w88 * 2, AppSize.h48),
                  painter: _MihrabArchPainter(
                    color: context.color.primary.withValues(
                      alpha: AppConstants.opacitySubtle * 0.7,
                    ),
                  ),
                ),
              ),
            ),
            // Content
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSize.p16,
                vertical: AppSize.p20,
              ),
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}

class _MihrabArchPainter extends CustomPainter {
  const _MihrabArchPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    final path = Path();
    final w = size.width;
    final h = size.height;

    // Elegant pointed Persian/Moorish arch curve
    path.moveTo(0, h);
    path.cubicTo(w * 0.2, h * 0.7, w * 0.35, h * 0.1, w * 0.5, 0);
    path.cubicTo(w * 0.65, h * 0.1, w * 0.8, h * 0.7, w, h);

    canvas.drawPath(path, paint);

    // Inner subtle concentric echo arch
    final innerPath = Path();
    innerPath.moveTo(w * 0.1, h);
    innerPath.cubicTo(w * 0.25, h * 0.75, w * 0.38, h * 0.25, w * 0.5, h * 0.15);
    innerPath.cubicTo(w * 0.62, h * 0.25, w * 0.75, h * 0.75, w * 0.9, h);

    canvas.drawPath(innerPath, paint..strokeWidth = 0.8);
  }

  @override
  bool shouldRepaint(covariant _MihrabArchPainter oldDelegate) =>
      oldDelegate.color != color;
}

import 'package:flutter/material.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/utils/context_extension.dart';

class ZikrCounter extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final size = 60.r(context);

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background Ring
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              value: 1,
              strokeWidth: 4,
              color: context.color.primary.withValues(alpha: 0.05),
            ),
          ),
          // Animated Progress Ring
          TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0, end: progress),
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            builder: (context, value, child) {
              return SizedBox(
                width: size,
                height: size,
                child: CircularProgressIndicator(
                  value: value,
                  strokeWidth: 4,
                  strokeCap: StrokeCap.round,
                  backgroundColor: Colors.transparent,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    context.color.primary.withValues(
                      alpha: isCompleted ? 0.3 : 1.0,
                    ),
                  ),
                ),
              );
            },
          ),
          // Content inside the ring
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) {
              return ScaleTransition(scale: animation, child: child);
            },
            child: isCompleted
                ? Icon(
                    Icons.check_circle_rounded,
                    key: const ValueKey('done'),
                    color: context.color.primary,
                    size: 32.r(context),
                  )
                : Text(
                    '$remainingCount',
                    key: ValueKey(remainingCount),
                    style: remainingCount > 99
                        ? AppTextStyles.font18W700primary(context)
                        : AppTextStyles.font24W700primary(context),
                  ),
          ),
        ],
      ),
    );
  }
}


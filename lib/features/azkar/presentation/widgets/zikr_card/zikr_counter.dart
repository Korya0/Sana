import 'package:flutter/material.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_colors.dart';

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
    const double size = 60;

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

              color: AppColors.gold.withValues(alpha: 0.05),
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
                    AppColors.gold.withValues(alpha: isCompleted ? 0.3 : 1.0),
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
                ? const Icon(
                    Icons.check_circle_rounded,
                    key: ValueKey('done'),
                    color: AppColors.gold,
                    size: 32,
                  )
                : Text(
                    '$remainingCount',
                    key: ValueKey(remainingCount),
                    style: AppTextStyles.font20W700White(context).copyWith(
                      fontSize: remainingCount > 99 ? 18 : 24,
                      color: AppColors.gold,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

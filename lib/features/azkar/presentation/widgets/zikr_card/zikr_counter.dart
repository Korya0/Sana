import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/utils/utils.dart';

class ZikrCounter extends StatefulWidget {
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
  State<ZikrCounter> createState() => _ZikrCounterState();
}

class _ZikrCounterState extends State<ZikrCounter>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late Animation<double> _animation;
  double _previousProgress = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _previousProgress = widget.progress;
    _animation = Tween<double>(
      begin: _previousProgress,
      end: widget.progress,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    unawaited(_controller.forward());
  }

  @override
  void didUpdateWidget(ZikrCounter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.progress != widget.progress) {
      _animation =
          Tween<double>(
            begin: _previousProgress,
            end: widget.progress,
          ).animate(
            CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
          );
      _previousProgress = widget.progress;
      unawaited(_controller.forward(from: 0));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return SizedBox(
                width: size,
                height: size,
                child: CircularProgressIndicator(
                  value: _animation.value,
                  strokeWidth: 4,
                  strokeCap: StrokeCap.round,
                  backgroundColor: Colors.transparent,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    context.color.primary.withValues(
                      alpha: widget.isCompleted ? 0.3 : 1.0,
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
            child: widget.isCompleted
                ? Icon(
                    Icons.check_circle_rounded,
                    key: const ValueKey('done'),
                    color: context.color.primary,
                    size: 32.r(context),
                  )
                : Text(
                    '${widget.remainingCount}',
                    key: ValueKey(widget.remainingCount),
                    style: widget.remainingCount > 99
                        ? AppTextStyles.font20W700(
                            context,
                          ).copyWith(color: context.color.textAccent)
                        : AppTextStyles.font24W700(
                            context,
                          ).copyWith(color: context.color.textAccent),
                  ),
          ),
        ],
      ),
    );
  }
}

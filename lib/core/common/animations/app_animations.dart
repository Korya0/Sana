import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

class AppAnimations {
  static Widget fadeIn(Widget child, {Duration? duration, Duration? delay}) {
    return FadeIn(
      duration: duration ?? const Duration(milliseconds: 600),
      delay: delay ?? Duration.zero,
      child: child,
    );
  }

  static Widget fadeInUp(Widget child, {Duration? duration, Duration? delay}) {
    return FadeInUp(
      duration: duration ?? const Duration(milliseconds: 400),
      delay: delay ?? Duration.zero,
      child: child,
    );
  }
}

class PulseWidget extends StatelessWidget {
  const PulseWidget({
    required this.child,
    required this.showPulse,
    this.duration = const Duration(milliseconds: 1000),
    super.key,
  });

  final Widget child;
  final bool showPulse;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    if (!showPulse) return child;

    return Pulse(
      infinite: true,
      duration: duration,
      child: child,
    );
  }
}

class PressScaleWidget extends StatefulWidget {
  const PressScaleWidget({
    required this.child,
    super.key,
    this.onTap,
    this.scaleFactor = 0.92,
  });
  final Widget child;
  final VoidCallback? onTap;
  final double scaleFactor;

  @override
  State<PressScaleWidget> createState() => _PressScaleWidgetState();
}

class _PressScaleWidgetState extends State<PressScaleWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(
      begin: 1,
      end: widget.scaleFactor,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) =>
            Transform.scale(scale: _scaleAnimation.value, child: child),
        child: widget.child,
      ),
    );
  }
}

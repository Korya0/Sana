// PressScaleWidget to used in AppAnimations
import 'dart:async';
import 'package:flutter/material.dart';

class PressScaleWidget extends StatefulWidget {
  const PressScaleWidget({
    required this.child,
    this.onTap,
    super.key,
  });
  final Widget child;
  final VoidCallback? onTap;

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
      end: 0.94,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(_) {
    if (widget.onTap != null) {
      unawaited(_controller.forward());
    }
  }

  void _handleTapUp(_) {
    unawaited(_controller.reverse());
  }

  void _handleTapCancel() {
    unawaited(_controller.reverse());
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      onTap: widget.onTap,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: widget.child,
      ),
    );
  }
}

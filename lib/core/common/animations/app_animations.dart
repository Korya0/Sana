import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:sana/core/common/animations/press_scale_widget.dart';

class AppAnimations {
  static Widget fadeIn(
    Widget child, {
    Duration? duration,
    Duration? delay,
    Curve? curve,
  }) {
    return FadeIn(
      duration: duration ?? const Duration(milliseconds: 600),
      delay: delay ?? Duration.zero,
      curve: curve ?? Curves.easeOut,
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

  //PressScaleWidget
  static Widget pressScale(Widget child, {required VoidCallback onTap}) {
    return PressScaleWidget(onTap: onTap, child: child);
  }
}

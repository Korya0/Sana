import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

/// Pure Animation Wrappers - No Performance Impact
/// Just wrap any widget with beautiful animations!
///
/// Usage: AppAnimations.fadeIn(child: AnyWidget())
class AppAnimations {
  // ===== FADE ANIMATIONS =====

  static Widget fadeIn(Widget child, {Duration? duration, Duration? delay}) {
    return FadeIn(
      duration: duration ?? const Duration(milliseconds: 600),
      delay: delay ?? Duration.zero,
      child: child,
    );
  }

  static Widget fadeInUp(Widget child, {Duration? duration, Duration? delay}) {
    return FadeInUp(
      duration: duration ?? const Duration(milliseconds: 600),
      delay: delay ?? Duration.zero,
      child: child,
    );
  }

  static Widget fadeInDown(
    Widget child, {
    Duration? duration,
    Duration? delay,
  }) {
    return FadeInDown(
      duration: duration ?? const Duration(milliseconds: 600),
      delay: delay ?? Duration.zero,
      child: child,
    );
  }

  static Widget fadeInLeft(
    Widget child, {
    Duration? duration,
    Duration? delay,
  }) {
    return FadeInLeft(
      duration: duration ?? const Duration(milliseconds: 600),
      delay: delay ?? Duration.zero,
      child: child,
    );
  }

  static Widget fadeInRight(
    Widget child, {
    Duration? duration,
    Duration? delay,
  }) {
    return FadeInRight(
      duration: duration ?? const Duration(milliseconds: 600),
      delay: delay ?? Duration.zero,
      child: child,
    );
  }

  // ===== SLIDE ANIMATIONS =====

  static Widget slideInUp(Widget child, {Duration? duration, Duration? delay}) {
    return SlideInUp(
      duration: duration ?? const Duration(milliseconds: 500),
      delay: delay ?? Duration.zero,
      child: child,
    );
  }

  static Widget slideInDown(
    Widget child, {
    Duration? duration,
    Duration? delay,
  }) {
    return SlideInDown(
      duration: duration ?? const Duration(milliseconds: 500),
      delay: delay ?? Duration.zero,
      child: child,
    );
  }

  static Widget slideInLeft(
    Widget child, {
    Duration? duration,
    Duration? delay,
  }) {
    return SlideInLeft(
      duration: duration ?? const Duration(milliseconds: 500),
      delay: delay ?? Duration.zero,
      child: child,
    );
  }

  static Widget slideInRight(
    Widget child, {
    Duration? duration,
    Duration? delay,
  }) {
    return SlideInRight(
      duration: duration ?? const Duration(milliseconds: 500),
      delay: delay ?? Duration.zero,
      child: child,
    );
  }

  // ===== ZOOM ANIMATIONS =====

  static Widget zoomIn(Widget child, {Duration? duration, Duration? delay}) {
    return ZoomIn(
      duration: duration ?? const Duration(milliseconds: 400),
      delay: delay ?? Duration.zero,
      child: child,
    );
  }

  static Widget zoomOut(Widget child, {Duration? duration, Duration? delay}) {
    return ZoomOut(
      duration: duration ?? const Duration(milliseconds: 400),
      delay: delay ?? Duration.zero,
      child: child,
    );
  }

  // ===== BOUNCE ANIMATIONS =====

  static Widget bounceIn(Widget child, {Duration? duration, Duration? delay}) {
    return BounceIn(
      duration: duration ?? const Duration(milliseconds: 500),
      delay: delay ?? Duration.zero,
      child: child,
    );
  }

  static Widget bounceInUp(
    Widget child, {
    Duration? duration,
    Duration? delay,
  }) {
    return BounceInUp(
      duration: duration ?? const Duration(milliseconds: 500),
      delay: delay ?? Duration.zero,
      child: child,
    );
  }

  static Widget bounceInDown(
    Widget child, {
    Duration? duration,
    Duration? delay,
  }) {
    return BounceInDown(
      duration: duration ?? const Duration(milliseconds: 500),
      delay: delay ?? Duration.zero,
      child: child,
    );
  }

  static Widget bounceInLeft(
    Widget child, {
    Duration? duration,
    Duration? delay,
  }) {
    return BounceInLeft(
      duration: duration ?? const Duration(milliseconds: 500),
      delay: delay ?? Duration.zero,
      child: child,
    );
  }

  static Widget bounceInRight(
    Widget child, {
    Duration? duration,
    Duration? delay,
  }) {
    return BounceInRight(
      duration: duration ?? const Duration(milliseconds: 500),
      delay: delay ?? Duration.zero,
      child: child,
    );
  }

  // ===== ELASTIC ANIMATIONS =====

  static Widget elasticIn(Widget child, {Duration? duration, Duration? delay}) {
    return ElasticIn(
      duration: duration ?? const Duration(milliseconds: 800),
      delay: delay ?? Duration.zero,
      child: child,
    );
  }

  static Widget elasticInUp(
    Widget child, {
    Duration? duration,
    Duration? delay,
  }) {
    return ElasticInUp(
      duration: duration ?? const Duration(milliseconds: 800),
      delay: delay ?? Duration.zero,
      child: child,
    );
  }

  static Widget elasticInDown(
    Widget child, {
    Duration? duration,
    Duration? delay,
  }) {
    return ElasticInDown(
      duration: duration ?? const Duration(milliseconds: 800),
      delay: delay ?? Duration.zero,
      child: child,
    );
  }

  static Widget elasticInLeft(
    Widget child, {
    Duration? duration,
    Duration? delay,
  }) {
    return ElasticInLeft(
      duration: duration ?? const Duration(milliseconds: 800),
      delay: delay ?? Duration.zero,
      child: child,
    );
  }

  static Widget elasticInRight(
    Widget child, {
    Duration? duration,
    Duration? delay,
  }) {
    return ElasticInRight(
      duration: duration ?? const Duration(milliseconds: 800),
      delay: delay ?? Duration.zero,
      child: child,
    );
  }

  // ===== FLIP ANIMATIONS =====

  static Widget flipInX(Widget child, {Duration? duration, Duration? delay}) {
    return FlipInX(
      duration: duration ?? const Duration(milliseconds: 600),
      delay: delay ?? Duration.zero,
      child: child,
    );
  }

  static Widget flipInY(Widget child, {Duration? duration, Duration? delay}) {
    return FlipInY(
      duration: duration ?? const Duration(milliseconds: 600),
      delay: delay ?? Duration.zero,
      child: child,
    );
  }

  // ===== ATTENTION SEEKERS =====

  static Widget pulse(
    Widget child, {
    Duration? duration,
    bool infinite = false,
  }) {
    return Pulse(
      duration: duration ?? const Duration(milliseconds: 1000),
      infinite: infinite,
      child: child,
    );
  }

  static Widget spin(Widget child, {Duration? duration, bool infinite = true}) {
    return Spin(
      duration: duration ?? const Duration(milliseconds: 1000),
      infinite: infinite,
      child: child,
    );
  }

  static Widget swing(
    Widget child, {
    Duration? duration,
    bool infinite = false,
  }) {
    return Swing(
      duration: duration ?? const Duration(milliseconds: 1000),
      infinite: infinite,
      child: child,
    );
  }

  static Widget shakeX(Widget child, {Duration? duration}) {
    return ShakeX(
      duration: duration ?? const Duration(milliseconds: 500),
      child: child,
    );
  }

  static Widget shakeY(Widget child, {Duration? duration}) {
    return ShakeY(
      duration: duration ?? const Duration(milliseconds: 500),
      child: child,
    );
  }

  static Widget jello(Widget child, {Duration? duration}) {
    return JelloIn(
      duration: duration ?? const Duration(milliseconds: 600),
      child: child,
    );
  }

  static Widget flash(Widget child, {Duration? duration}) {
    return Flash(
      duration: duration ?? const Duration(milliseconds: 500),
      child: child,
    );
  }

  static Widget dance(Widget child, {Duration? duration}) {
    return Dance(
      duration: duration ?? const Duration(milliseconds: 800),
      child: child,
    );
  }

  static Widget rubberBand(Widget child, {Duration? duration}) {
    return RubberBand(
      duration: duration ?? const Duration(milliseconds: 600),
      child: child,
    );
  }
}

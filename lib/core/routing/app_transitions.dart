import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppTransitions {
  AppTransitions._();

  // Default transition duration
  static const Duration _duration = Duration(milliseconds: 300);
  static const Duration _reverseDuration = Duration(milliseconds: 250);

  /// Slide from right transition (iOS-style)
  static CustomTransitionPage slideFromRight({
    required BuildContext context,
    required GoRouterState state,
    required Widget child,
    Duration? duration,
    Duration? reverseDuration,
  }) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionDuration: duration ?? _duration,
      reverseTransitionDuration: reverseDuration ?? _reverseDuration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOutCubic;

        var tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: curve));

        return SlideTransition(position: animation.drive(tween), child: child);
      },
    );
  }

  /// Slide from left transition
  static CustomTransitionPage slideFromLeft({
    required BuildContext context,
    required GoRouterState state,
    required Widget child,
    Duration? duration,
    Duration? reverseDuration,
  }) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionDuration: duration ?? _duration,
      reverseTransitionDuration: reverseDuration ?? _reverseDuration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(-1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOutCubic;

        var tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: curve));

        return SlideTransition(position: animation.drive(tween), child: child);
      },
    );
  }

  /// Slide from bottom transition (Material-style)
  static CustomTransitionPage slideFromBottom({
    required BuildContext context,
    required GoRouterState state,
    required Widget child,
    Duration? duration,
    Duration? reverseDuration,
  }) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionDuration: duration ?? _duration,
      reverseTransitionDuration: reverseDuration ?? _reverseDuration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.easeInOutCubic;

        var tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: curve));

        return SlideTransition(position: animation.drive(tween), child: child);
      },
    );
  }

  /// Slide from top transition
  static CustomTransitionPage slideFromTop({
    required BuildContext context,
    required GoRouterState state,
    required Widget child,
    Duration? duration,
    Duration? reverseDuration,
  }) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionDuration: duration ?? _duration,
      reverseTransitionDuration: reverseDuration ?? _reverseDuration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, -1.0);
        const end = Offset.zero;
        const curve = Curves.easeInOutCubic;

        var tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: curve));

        return SlideTransition(position: animation.drive(tween), child: child);
      },
    );
  }

  /// Fade transition
  static CustomTransitionPage fade({
    required BuildContext context,
    required GoRouterState state,
    required Widget child,
    Duration? duration,
    Duration? reverseDuration,
  }) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionDuration: duration ?? _duration,
      reverseTransitionDuration: reverseDuration ?? _reverseDuration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
          child: child,
        );
      },
    );
  }

  /// Fade with scale transition
  static CustomTransitionPage fadeScale({
    required BuildContext context,
    required GoRouterState state,
    required Widget child,
    Duration? duration,
    Duration? reverseDuration,
  }) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionDuration: duration ?? _duration,
      reverseTransitionDuration: reverseDuration ?? _reverseDuration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.8, end: 1.0).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeInOutBack),
            ),
            child: child,
          ),
        );
      },
    );
  }

  /// Scale transition
  static CustomTransitionPage scale({
    required BuildContext context,
    required GoRouterState state,
    required Widget child,
    Duration? duration,
    Duration? reverseDuration,
  }) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionDuration: duration ?? _duration,
      reverseTransitionDuration: reverseDuration ?? _reverseDuration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(parent: animation, curve: Curves.elasticOut),
          ),
          child: child,
        );
      },
    );
  }

  /// Rotation transition
  static CustomTransitionPage rotation({
    required BuildContext context,
    required GoRouterState state,
    required Widget child,
    Duration? duration,
    Duration? reverseDuration,
  }) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionDuration: duration ?? _duration,
      reverseTransitionDuration: reverseDuration ?? _reverseDuration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return RotationTransition(
          turns: Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(parent: animation, curve: Curves.easeInOut),
          ),
          child: child,
        );
      },
    );
  }

  /// Size transition
  static CustomTransitionPage size({
    required BuildContext context,
    required GoRouterState state,
    required Widget child,
    Duration? duration,
    Duration? reverseDuration,
  }) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionDuration: duration ?? _duration,
      reverseTransitionDuration: reverseDuration ?? _reverseDuration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return Align(
          child: SizeTransition(sizeFactor: animation, child: child),
        );
      },
    );
  }

  /// Custom transition combining slide and fade
  static CustomTransitionPage slideAndFade({
    required BuildContext context,
    required GoRouterState state,
    required Widget child,
    Offset begin = const Offset(1.0, 0.0),
    Duration? duration,
    Duration? reverseDuration,
  }) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionDuration: duration ?? _duration,
      reverseTransitionDuration: reverseDuration ?? _reverseDuration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const end = Offset.zero;
        const curve = Curves.easeInOutCubic;

        var slideTween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: curve));

        var fadeTween = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(slideTween),
          child: FadeTransition(
            opacity: animation.drive(fadeTween),
            child: child,
          ),
        );
      },
    );
  }

  /// No transition (instant)
  static CustomTransitionPage noTransition({
    required BuildContext context,
    required GoRouterState state,
    required Widget child,
  }) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionDuration: Duration.zero,
      reverseTransitionDuration: Duration.zero,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return child;
      },
    );
  }
}

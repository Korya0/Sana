import 'package:flutter/widgets.dart';
import 'package:sana/core/router/app_navigation_guard.dart';

/// Releases the navigation lock when the pushed route finishes its
/// transition, instead of when the route is popped.
class AppNavigatorObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _releaseWhenCompleted(route);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    if (newRoute != null) _releaseWhenCompleted(newRoute);
  }

  void _releaseWhenCompleted(Route<dynamic> route) {
    final animation = route is TransitionRoute<dynamic>
        ? route.animation
        : null;

    if (animation == null || animation.status == AnimationStatus.completed) {
      AppNavigationGuard.release();
      return;
    }

    void listener(AnimationStatus status) {
      if (status == AnimationStatus.completed ||
          status == AnimationStatus.dismissed) {
        animation.removeStatusListener(listener);
        AppNavigationGuard.release();
      }
    }

    animation.addStatusListener(listener);
  }
}

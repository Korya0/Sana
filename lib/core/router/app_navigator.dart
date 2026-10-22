import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:sana/core/router/app_navigation_guard.dart';

/// The only entry point for route navigation.
///
/// A second request that arrives while a transition is in flight is dropped.
abstract final class AppNavigator {
  static Future<T?>? pushNamed<T extends Object?>(
    BuildContext context,
    String name, {
    Map<String, String> pathParameters = const {},
    Object? extra,
  }) => AppNavigationGuard.runIfIdle(
    () => context.pushNamed<T>(
      name,
      pathParameters: pathParameters,
      extra: extra,
    ),
  );

  static void go(BuildContext context, String location) {
    AppNavigationGuard.run(() => context.go(location));
  }
}

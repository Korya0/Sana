import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// A centralized navigation service that abstracts away the underlying routing package (go_router).
/// Using this class instead of calling `context.pushNamed` or `Navigator.pop` directly
/// makes it easy to switch routing libraries in the future.
class AppNavigator {
  AppNavigator._();

  /// Pushes a new route onto the page stack.
  static Future<T?> pushNamed<T extends Object?>(
    BuildContext context,
    String routeName, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, dynamic> queryParameters = const <String, dynamic>{},
    Object? extra,
  }) {
    return context.pushNamed<T>(
      routeName,
      pathParameters: pathParameters,
      queryParameters: queryParameters,
      extra: extra,
    );
  }

  /// Navigates to a route, replacing the current route.
  static void goNamed(
    BuildContext context,
    String routeName, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, dynamic> queryParameters = const <String, dynamic>{},
    Object? extra,
  }) {
    context.goNamed(
      routeName,
      pathParameters: pathParameters,
      queryParameters: queryParameters,
      extra: extra,
    );
  }

  /// Replaces the current route with a new one.
  static void pushReplacementNamed(
    BuildContext context,
    String routeName, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, dynamic> queryParameters = const <String, dynamic>{},
    Object? extra,
  }) {
    context.pushReplacementNamed(
      routeName,
      pathParameters: pathParameters,
      queryParameters: queryParameters,
      extra: extra,
    );
  }

  /// Pops the top-most route off the navigator.
  static void pop<T extends Object?>(BuildContext context, [T? result]) {
    if (canPop(context)) {
      context.pop<T>(result);
    }
  }

  /// Tries to pop the top-most route, returning true if successful.
  static Future<bool> maybePop<T extends Object?>(BuildContext context, [T? result]) async {
    final navigator = Navigator.of(context);
    return navigator.maybePop(result);
  }

  /// Returns true if there is more than 1 route on the stack.
  static bool canPop(BuildContext context) {
    return context.canPop();
  }
}

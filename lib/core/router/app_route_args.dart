import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

abstract class AppRouteArgs {
  const AppRouteArgs();
}

class AppRouteArgsException implements Exception {
  const AppRouteArgsException({
    required this.uri,
    required this.expected,
    this.actual,
  });

  final Uri uri;
  final Type expected;
  final Type? actual;

  @override
  String toString() =>
      'AppRouteArgsException: $uri expects $expected as extra but received '
      '${actual ?? 'nothing'}.';
}

extension AppRouteArgsReader on GoRouterState {
  /// Typed extra, nullable.
  T? extraOf<T>() {
    final extra = this.extra;
    if (extra == null) return null;
    if (extra is T) return extra as T;
    throw AppRouteArgsException(
      uri: uri,
      expected: T,
      actual: extra.runtimeType,
    );
  }

  /// Typed extra, required.
  T requireExtra<T>() {
    final extra = extraOf<T>();
    if (extra != null) return extra;
    throw AppRouteArgsException(uri: uri, expected: T);
  }
}

extension AppRouteArgsContext on BuildContext {
  T? extraOf<T>() => GoRouterState.of(this).extraOf<T>();

  T requireExtra<T>() => GoRouterState.of(this).requireExtra<T>();
}

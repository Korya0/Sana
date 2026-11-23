import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:sana/core/router/app_router.dart';
import 'package:sana/core/router/app_routes.dart';

void main() {
  test('the removed reminders screen is not reachable', () {
    final paths = _paths(AppRouter.router.configuration.routes);

    expect(paths.where((path) => path.contains('reminder')), isEmpty);
  });

  test('qibla is a route and splash is gone', () {
    final paths = _paths(AppRouter.router.configuration.routes).toList();

    expect(paths, contains(AppRoutes.qiblaView));
    expect(paths, isNot(contains('/splash')));
  });
}

Iterable<String> _paths(List<RouteBase> routes) sync* {
  for (final route in routes) {
    if (route is GoRoute) {
      yield route.path;
      yield* _paths(route.routes);
    } else if (route is StatefulShellRoute) {
      for (final branch in route.branches) {
        yield* _paths(branch.routes);
      }
    }
  }
}

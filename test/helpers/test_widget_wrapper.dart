import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sana/core/theme/app_theme.dart';
import 'package:sana/core/services/haptic/i_haptic_service.dart';

/// Registers a mock [IHapticService] in GetIt so widgets that access it
/// via `sl<IHapticService>()` don't throw.
///
/// Call in `setUp` and `tearDown` to isolate test registrations.
final GetIt sl = GetIt.instance;

class MockIHapticService extends Mock implements IHapticService {}

/// Use [registerTestServices] at the top of every widget-test file that
/// exercises widgets depending on `sl<IHapticService>()`.
void registerTestServices() {
  sl.registerLazySingleton<IHapticService>(MockIHapticService.new);
}

/// Wraps [child] in a [MaterialApp] with the light theme so that
/// `context.color`, `context.responsive()`, and `MediaQuery` work in tests.
///
/// The child is placed inside a [Scaffold] body → ensures a [Material] ancestor
/// is present (required by [InkWell], [Tooltip] and similar widgets).
///
/// An optional [routerConfig] can be passed for widgets that depend on
/// `GoRouter.of(context)`.
Widget createTestApp(
  Widget child, {
  GoRouter? routerConfig,
  TextDirection textDirection = TextDirection.rtl,
}) {
  if (routerConfig != null) {
    return MaterialApp.router(
      theme: AppTheme.lightTheme,
      routerConfig: routerConfig,
    );
  }

  return MaterialApp(
    theme: AppTheme.lightTheme,
    home: Scaffold(
      body: Directionality(
        textDirection: textDirection,
        child: child,
      ),
    ),
  );
}

/// A minimal GoRouter for widget tests that just has a shell scaffold with
/// [child] as the home page.
GoRouter createTestRouter(Widget child) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => Scaffold(
          body: child,
        ),
      ),
    ],
  );
}

/// Call this at the top of widget tests to ensure a reasonable screen size.
/// Uses 1440×2560 @ 2.0 DPR → 720×1280 logical pixels, plenty for Arabic text.
void setTestScreenSize(WidgetTester tester) {
  tester.view.physicalSize = const Size(1440, 2560);
  tester.view.devicePixelRatio = 2.0;
  addTearDown(() {
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });
}

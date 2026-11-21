import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/router/app_routes.dart';
import 'package:sana/core/widgets/views/home_view.dart';

void main() {
  testWidgets('home view opens the Zakat feature', (tester) async {
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const HomeView(),
        ),
        GoRoute(
          path: AppRoutes.zakatHome,
          builder: (context, state) =>
              const Scaffold(body: Text('Zakat route')),
        ),
      ],
    );

    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.tap(find.text(AppStrings.zakatTitle));
    await tester.pumpAndSettle();

    expect(find.text('Zakat route'), findsOneWidget);
    router.dispose();
  });
}

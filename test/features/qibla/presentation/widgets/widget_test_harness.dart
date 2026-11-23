import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/theme/app_theme.dart';

Future<void> pumpQiblaWidget(
  WidgetTester tester,
  Widget child, {
  Size size = const Size(400, 900),
  bool settle = true,
  TextScaler textScaler = TextScaler.noScaling,
  GoRouter? router,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  Widget appBuilder(BuildContext context, Widget? childWidget) {
    AppSize.init(context);
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: textScaler),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: childWidget ?? const SizedBox.shrink(),
      ),
    );
  }

  await tester.pumpWidget(
    router == null
        ? MaterialApp(
            theme: AppTheme.light,
            builder: appBuilder,
            home: Scaffold(body: child),
          )
        : MaterialApp.router(
            theme: AppTheme.light,
            builder: appBuilder,
            routerConfig: router,
          ),
  );

  if (settle) await tester.pumpAndSettle();
}

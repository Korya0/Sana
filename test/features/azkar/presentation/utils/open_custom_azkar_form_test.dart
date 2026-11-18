import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/router/app_routes.dart';
import 'package:sana/core/theme/app_theme.dart';
import 'package:sana/features/azkar/domain/entities/custom_category_entity.dart';
import 'package:sana/features/azkar/presentation/utils/open_custom_azkar_form.dart';

void main() {
  group('OpenCustomAzkarForm', () {
    testWidgets('reloads when the form returns a saved category', (tester) async {
      var reloads = 0;
      const saved = CustomCategoryEntity(id: 'custom_1', name: 'ورد', azkar: []);

      await _pumpApp(
        tester,
        formResult: saved,
        onOpen: (context) => OpenCustomAzkarForm.andReload(
          context,
          reload: () async {
            reloads++;
          },
        ),
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('close'));
      await tester.pumpAndSettle();

      expect(reloads, 1);
    });

    testWidgets('does not reload when the form returns null', (tester) async {
      var reloads = 0;

      await _pumpApp(
        tester,
        formResult: null,
        onOpen: (context) => OpenCustomAzkarForm.andReload(
          context,
          reload: () async {
            reloads++;
          },
        ),
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      expect(reloads, 0);
    });

    testWidgets('passes the initial category to the form route', (tester) async {
      CustomCategoryEntity? receivedExtra;
      const initial = CustomCategoryEntity(id: 'custom_2', name: 'مساء', azkar: []);

      await _pumpApp(
        tester,
        formResult: null,
        onFormBuild: (extra) => receivedExtra = extra,
        onOpen: (context) => OpenCustomAzkarForm.andReload(
          context,
          category: initial,
          reload: () async {},
        ),
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      expect(receivedExtra, same(initial));
    });

    testWidgets('passes null when no initial category is provided', (
      tester,
    ) async {
      CustomCategoryEntity? receivedExtra = const CustomCategoryEntity(
        id: 'sentinel',
        name: 'x',
        azkar: [],
      );

      await _pumpApp(
        tester,
        formResult: null,
        onFormBuild: (extra) => receivedExtra = extra,
        onOpen: (context) => OpenCustomAzkarForm.andReload(
          context,
          reload: () async {},
        ),
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      expect(receivedExtra, isNull);
    });
  });
}

Future<void> _pumpApp(
  WidgetTester tester, {
  required CustomCategoryEntity? formResult,
  required Future<void> Function(BuildContext context) onOpen,
  void Function(CustomCategoryEntity? extra)? onFormBuild,
}) async {
  final router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => Scaffold(
          body: Center(
            child: TextButton(
              onPressed: () => onOpen(context),
              child: const Text('open'),
            ),
          ),
        ),
      ),
      GoRoute(
        path: AppRoutes.customAzkarFormView,
        name: AppRoutes.customAzkarFormView,
        builder: (context, state) {
          onFormBuild?.call(state.extra as CustomCategoryEntity?);
          return Scaffold(
            body: Center(
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(formResult),
                child: const Text('close'),
              ),
            ),
          );
        },
      ),
    ],
  );
  addTearDown(router.dispose);

  await tester.pumpWidget(
    MaterialApp.router(
      routerConfig: router,
      theme: AppTheme.light,
      builder: (context, child) {
        AppSize.init(context);
        return Directionality(textDirection: TextDirection.rtl, child: child!);
      },
    ),
  );
  await tester.pumpAndSettle();
}

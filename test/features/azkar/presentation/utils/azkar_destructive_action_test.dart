import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/error/failure.dart';
import 'package:sana/core/error/result.dart';
import 'package:sana/core/theme/app_theme.dart';
import 'package:sana/features/azkar/presentation/utils/azkar_destructive_action.dart';
import 'package:toastification/toastification.dart';

void main() {
  group('AzkarDestructiveAction.run', () {
    testWidgets('returns false and does not run action when cancelled', (
      tester,
    ) async {
      var called = false;

      await _pump(tester);
      final future = _run(
        tester,
        action: () async {
          called = true;
          return const Result.success(null);
        },
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text(AppStrings.cancel));
      await tester.pumpAndSettle();

      expect(await future, isFalse);
      expect(called, isFalse);
    });

    testWidgets('returns false when the action fails', (tester) async {
      var called = false;

      await _pump(tester);
      final future = _run(
        tester,
        action: () async {
          called = true;
          return const Result.failure(CacheFailure(message: 'تعذّر الحذف'));
        },
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text(AppStrings.delete));
      await tester.pumpAndSettle();

      expect(await future, isFalse);
      expect(called, isTrue);
      await tester.pump(const Duration(seconds: 3));
    });

    testWidgets('returns true when action succeeds', (tester) async {
      await _pump(tester);
      final future = _run(
        tester,
        action: () async => const Result.success(null),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text(AppStrings.delete));
      await tester.pumpAndSettle();

      expect(await future, isTrue);
    });

    testWidgets('returns true when action succeeds with a success message', (
      tester,
    ) async {
      await _pump(tester);
      final future = _run(
        tester,
        action: () async => const Result.success(null),
        successMessage: 'تم الحذف',
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text(AppStrings.delete));
      await tester.pumpAndSettle();

      expect(await future, isTrue);
      await tester.pump(const Duration(seconds: 3));
    });

    testWidgets('returns false when action fails even with a success message', (
      tester,
    ) async {
      await _pump(tester);
      final future = _run(
        tester,
        action: () async => const Result.failure(CacheFailure(message: 'خطأ')),
        successMessage: 'تم الحذف',
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text(AppStrings.delete));
      await tester.pumpAndSettle();

      expect(await future, isFalse);
      await tester.pump(const Duration(seconds: 3));
    });
  });
}

Future<void> _pump(WidgetTester tester) async {
  await tester.pumpWidget(
    ToastificationWrapper(
      child: MaterialApp(
        theme: AppTheme.light,
        builder: (context, child) {
          AppSize.init(context);
          return Directionality(
            textDirection: TextDirection.rtl,
            child: child!,
          );
        },
        home: const Scaffold(body: SizedBox.shrink()),
      ),
    ),
  );
}

Future<bool> _run(
  WidgetTester tester, {
  required Future<Result<void>> Function() action,
  String? successMessage,
}) {
  final context = tester.element(find.byType(SizedBox));
  return AzkarDestructiveAction.run(
    context,
    title: 'حذف عنصر',
    message: 'هل تريد الحذف؟',
    confirmText: AppStrings.delete,
    action: action,
    successMessage: successMessage,
  );
}

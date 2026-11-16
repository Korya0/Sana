import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/error/failure.dart';
import 'package:sana/core/error/result.dart';
import 'package:sana/core/services/clipboard/clipboard_copy.dart';
import 'package:sana/core/services/clipboard/clipboard_service.dart';
import 'package:sana/core/theme/app_theme.dart';

class _FailingClipboardService extends ClipboardService {
  const _FailingClipboardService();

  @override
  Future<Result<void>> copy(String text) async =>
      const Result.failure(UnknownFailure(message: 'failed'));
}

class _WorkingClipboardService extends ClipboardService {
  const _WorkingClipboardService();

  @override
  Future<Result<void>> copy(String text) async => const Result.success(null);
}

void main() {
  testWidgets('returns true without showing a toast', (tester) async {
    bool? succeeded;

    await _pump(
      tester,
      onPressed: (context) async {
        succeeded = await copyText(
          context,
          'text',
          errorMessage: 'copy failed',
          service: const _WorkingClipboardService(),
        );
      },
    );

    await tester.tap(find.text('copy'));
    await tester.pumpAndSettle();

    expect(succeeded, isTrue);
    expect(find.text('copy failed'), findsNothing);
  });

  testWidgets('returns false and shows the error message', (tester) async {
    bool? succeeded;

    await _pump(
      tester,
      onPressed: (context) async {
        succeeded = await copyText(
          context,
          'text',
          errorMessage: 'copy failed',
          service: const _FailingClipboardService(),
        );
      },
    );

    await tester.tap(find.text('copy'));
    await tester.pumpAndSettle();

    expect(succeeded, isFalse);
    expect(find.text('copy failed'), findsOneWidget);

    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();
  });
}

Future<void> _pump(
  WidgetTester tester, {
  required Future<void> Function(BuildContext context) onPressed,
}) => tester.pumpWidget(
  MaterialApp(
    theme: AppTheme.light,
    builder: (context, child) {
      AppSize.init(context);
      return child!;
    },
    home: Builder(
      builder: (context) => TextButton(
        onPressed: () => onPressed(context),
        child: const Text('copy'),
      ),
    ),
  ),
);

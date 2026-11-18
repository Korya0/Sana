import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/app_theme.dart';
import 'package:sana/features/azkar/presentation/utils/unsaved_changes_guard.dart';

void main() {
  group('UnsavedChangesGuard', () {
    testWidgets('pops immediately when the form is not dirty', (tester) async {
      final key = GlobalKey<_GuardHostState>();
      await _pump(tester, key, isDirty: false);

      await key.currentState!.closeWithGuard();
      await tester.pumpAndSettle();

      expect(find.byType(_GuardHost), findsNothing);
      expect(find.byType(_HomePage), findsOneWidget);
    });

    testWidgets('does not pop when the user cancels unsaved changes', (
      tester,
    ) async {
      final key = GlobalKey<_GuardHostState>();
      await _pump(tester, key, isDirty: true);

      final future = key.currentState!.closeWithGuard();
      await tester.pumpAndSettle();

      expect(find.text(AppStrings.unsavedChangesDialogTitle), findsOneWidget);

      await tester.tap(find.text(AppStrings.unsavedChangesCancel));
      await tester.pumpAndSettle();
      await future;

      expect(find.byType(_GuardHost), findsOneWidget);
      expect(find.byType(_HomePage), findsNothing);
    });

    testWidgets('pops when the user confirms leaving unsaved changes', (
      tester,
    ) async {
      final key = GlobalKey<_GuardHostState>();
      await _pump(tester, key, isDirty: true);

      final future = key.currentState!.closeWithGuard();
      await tester.pumpAndSettle();

      expect(find.text(AppStrings.unsavedChangesDialogTitle), findsOneWidget);

      await tester.tap(find.text(AppStrings.unsavedChangesConfirm));
      await tester.pumpAndSettle();
      await future;

      expect(find.byType(_GuardHost), findsNothing);
      expect(find.byType(_HomePage), findsOneWidget);
    });

    testWidgets('ignores repeated calls while the dialog is open', (
      tester,
    ) async {
      final key = GlobalKey<_GuardHostState>();
      await _pump(tester, key, isDirty: true);

      final first = key.currentState!.closeWithGuard();
      await tester.pumpAndSettle();

      expect(find.text(AppStrings.unsavedChangesDialogTitle), findsOneWidget);

      await key.currentState!.closeWithGuard();
      await tester.pump();

      expect(find.text(AppStrings.unsavedChangesDialogTitle), findsOneWidget);

      await tester.tap(find.text(AppStrings.unsavedChangesCancel));
      await tester.pumpAndSettle();
      await first;

      expect(find.byType(_GuardHost), findsOneWidget);
    });
  });
}

Future<void> _pump(
  WidgetTester tester,
  GlobalKey<_GuardHostState> key, {
  required bool isDirty,
}) async {
  await tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.light,
      builder: (context, child) {
        AppSize.init(context);
        return Directionality(textDirection: TextDirection.rtl, child: child!);
      },
      home: _HomePage(guardKey: key, isDirty: isDirty),
    ),
  );
  await tester.pumpAndSettle();
  await tester.tap(find.text('open'));
  await tester.pumpAndSettle();
}

class _HomePage extends StatelessWidget {
  const _HomePage({required this.guardKey, required this.isDirty});

  final GlobalKey<_GuardHostState> guardKey;
  final bool isDirty;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) => TextButton(
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => _GuardHost(key: guardKey, isDirty: isDirty),
            ),
          ),
          child: const Text('open'),
        ),
      ),
    );
  }
}

class _GuardHost extends StatefulWidget {
  const _GuardHost({super.key, required this.isDirty});

  final bool isDirty;

  @override
  State<_GuardHost> createState() => _GuardHostState();
}

class _GuardHostState extends State<_GuardHost> with UnsavedChangesGuard<_GuardHost> {
  @override
  bool get isDirty => widget.isDirty;

  @override
  Widget build(BuildContext context) => const Scaffold(body: SizedBox.shrink());
}

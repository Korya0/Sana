import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/app_theme.dart';
import 'package:sana/features/azkar/presentation/widgets/azkar_section/azkar_home_options_bottom_sheet.dart';

void main() {
  group('AzkarHomeOptionsBottomSheet', () {
    testWidgets('groups the options under section titles', (tester) async {
      await _open(tester);

      expect(find.text(AppStrings.readingSettingsTitle), findsOneWidget);
      expect(find.text(AppStrings.customAzkar), findsOneWidget);
      expect(find.text(AppStrings.fontSize), findsOneWidget);
      expect(find.text(AppStrings.createCustomAzkar), findsOneWidget);
      expect(find.text(AppStrings.manageCustomAzkar), findsOneWidget);
    });

    testWidgets('returns the tapped option', (tester) async {
      AzkarHomeOption? captured;
      await _open(tester, onResult: (value) => captured = value);

      await tester.tap(find.text(AppStrings.fontSize));
      await tester.pumpAndSettle();

      expect(captured, AzkarHomeOption.fontSize);
    });
  });
}

Future<void> _open(
  WidgetTester tester, {
  void Function(AzkarHomeOption?)? onResult,
}) async {
  tester.view.physicalSize = const Size(400, 900);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.light,
      builder: (context, child) {
        AppSize.init(context);
        return Directionality(textDirection: TextDirection.rtl, child: child!);
      },
      home: Scaffold(
        body: Builder(
          builder: (context) => Center(
            child: TextButton(
              onPressed: () async {
                final result = await showModalBottomSheet<AzkarHomeOption>(
                  context: context,
                  builder: (_) => const AzkarHomeOptionsBottomSheet(),
                );
                onResult?.call(result);
              },
              child: const Text('open'),
            ),
          ),
        ),
      ),
    ),
  );

  await tester.tap(find.text('open'));
  await tester.pumpAndSettle();
}

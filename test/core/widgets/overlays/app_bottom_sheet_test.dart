import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/theme/app_theme.dart';
import 'package:sana/core/theme/colors/colors_dark.dart';
import 'package:sana/core/theme/colors/colors_light.dart';
import 'package:sana/core/widgets/overlays/app_bottom_sheet.dart';

void main() {
  testWidgets('keeps its surface in sync with a live theme change', (
    tester,
  ) async {
    final mode = ValueNotifier(ThemeMode.light);

    await tester.pumpWidget(
      ValueListenableBuilder<ThemeMode>(
        valueListenable: mode,
        builder: (context, value, child) => MaterialApp(
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: value,
          builder: (context, child) {
            AppSize.init(context);
            return child!;
          },
          home: Scaffold(
            body: Builder(
              builder: (context) => TextButton(
                onPressed: () => AppBottomSheet.show<void>(
                  context: context,
                  child: const SizedBox(height: 120),
                ),
                child: const Text('open'),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    expect(
      _sheetBackgrounds(tester),
      contains(ColorsLight.secondaryScaffoldBackgroundColor),
    );

    mode.value = ThemeMode.dark;
    await tester.pumpAndSettle();

    expect(
      _sheetBackgrounds(tester),
      contains(ColorsDark.secondaryScaffoldBackgroundColor),
    );
  });
}

Iterable<Color?> _sheetBackgrounds(WidgetTester tester) => tester
    .widgetList<Material>(
      find.descendant(
        of: find.byType(BottomSheet),
        matching: find.byType(Material),
      ),
    )
    .map((material) => material.color);

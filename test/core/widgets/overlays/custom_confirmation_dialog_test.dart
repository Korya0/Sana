import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/theme/app_theme.dart';
import 'package:sana/core/theme/colors/colors_dark.dart';
import 'package:sana/core/theme/colors/colors_light.dart';
import 'package:sana/core/widgets/overlays/custom_confirmation_dialog.dart';

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
                onPressed: () => CustomConfirmationDialog.show(
                  context: context,
                  title: 'title',
                  message: 'message',
                  confirmText: 'confirm',
                  cancelText: 'cancel',
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
      tester.widget<Dialog>(find.byType(Dialog)).backgroundColor,
      ColorsLight.secondaryScaffoldBackgroundColor,
    );

    mode.value = ThemeMode.dark;
    await tester.pumpAndSettle();

    expect(
      tester.widget<Dialog>(find.byType(Dialog)).backgroundColor,
      ColorsDark.secondaryScaffoldBackgroundColor,
    );
  });
}

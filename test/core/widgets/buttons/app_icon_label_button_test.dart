import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/app_theme.dart';
import 'package:sana/core/theme/icons/app_icons.dart';
import 'package:sana/core/utils/context_extension.dart';
import 'package:sana/core/widgets/buttons/app_icon_label_button.dart';

void main() {
  testWidgets('renders the icon and label with the enabled style', (
    tester,
  ) async {
    var taps = 0;
    await _pump(
      tester,
      child: AppIconLabelButton(
        icon: AppIcons.refresh,
        label: AppStrings.resetCounter,
        onPressed: () => taps++,
      ),
    );

    expect(find.byIcon(AppIcons.refresh), findsOneWidget);
    expect(find.text(AppStrings.resetCounter), findsOneWidget);
    expect(tester.getSize(find.byType(AppIconLabelButton)).height, AppSize.h64);
    expect(
      tester.getSize(find.byType(AppIconLabelButton)).width,
      greaterThanOrEqualTo(AppSize.w88),
    );

    final context = tester.element(find.byType(AppIconLabelButton));
    final icon = tester.widget<Icon>(find.byIcon(AppIcons.refresh));
    final label = tester.widget<Text>(find.text(AppStrings.resetCounter));
    final container = tester.widget<Container>(
      find.descendant(
        of: find.byType(AppIconLabelButton),
        matching: find.byType(Container),
      ),
    );
    final decoration = container.decoration! as BoxDecoration;

    expect(icon.color, context.color.iconOnPrimary);
    expect(label.style?.color, context.color.textOnPrimary);
    expect(decoration.color, context.color.actionPrimary);

    await tester.tap(find.text(AppStrings.resetCounter));
    await tester.pumpAndSettle();

    expect(taps, 1);
  });

  testWidgets('uses the disabled style and ignores taps when disabled', (
    tester,
  ) async {
    await _pump(
      tester,
      child: const AppIconLabelButton(
        icon: AppIcons.refresh,
        label: AppStrings.resetCounter,
        onPressed: null,
      ),
    );

    final context = tester.element(find.byType(AppIconLabelButton));
    final icon = tester.widget<Icon>(find.byIcon(AppIcons.refresh));
    final label = tester.widget<Text>(find.text(AppStrings.resetCounter));
    final container = tester.widget<Container>(
      find.descendant(
        of: find.byType(AppIconLabelButton),
        matching: find.byType(Container),
      ),
    );
    final decoration = container.decoration! as BoxDecoration;

    expect(icon.color, context.color.iconDisabled);
    expect(label.style?.color, context.color.textDisabled);
    expect(decoration.color, context.color.surfaceDisabled);

    await tester.tap(find.byType(AppIconLabelButton));
    await tester.pump();
  });
}

Future<void> _pump(WidgetTester tester, {required Widget child}) async {
  await tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.light,
      builder: (context, child) {
        AppSize.init(context);
        return Directionality(textDirection: TextDirection.rtl, child: child!);
      },
      home: Scaffold(body: Center(child: child)),
    ),
  );
}

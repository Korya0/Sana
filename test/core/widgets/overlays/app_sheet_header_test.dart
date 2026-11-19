import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/app_theme.dart';
import 'package:sana/core/theme/icons/app_icons.dart';
import 'package:sana/core/widgets/buttons/app_icon_button.dart';
import 'package:sana/core/widgets/buttons/app_text_button.dart';
import 'package:sana/core/widgets/overlays/app_sheet_header.dart';

void main() {
  Future<void> pumpHeader(
    WidgetTester tester,
    AppSheetHeader header,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        builder: (context, child) {
          AppSize.init(context);
          return child!;
        },
        home: Scaffold(body: header),
      ),
    );
  }

  AppTextButton saveButton(WidgetTester tester) => tester.widget<AppTextButton>(
    find.ancestor(
      of: find.text(AppStrings.save),
      matching: find.byType(AppTextButton),
    ),
  );

  testWidgets('shows a start-aligned title and a close action', (tester) async {
    await pumpHeader(
      tester,
      AppSheetHeader(title: 'حفظ الذكر', onDismiss: () {}),
    );

    final title = tester.widget<Text>(find.text('حفظ الذكر'));
    expect(title.textAlign, TextAlign.start);
    expect(find.byIcon(AppIcons.close), findsOneWidget);
    expect(find.byIcon(AppIcons.back), findsNothing);
    expect(find.byType(AppTextButton), findsNothing);
  });

  testWidgets('uses a back action for a nested sheet', (tester) async {
    await pumpHeader(
      tester,
      AppSheetHeader(title: 'حجم الخط', onDismiss: () {}, isNested: true),
    );

    expect(find.byIcon(AppIcons.back), findsOneWidget);
    expect(find.byIcon(AppIcons.close), findsNothing);
    expect(find.byTooltip(AppStrings.back), findsOneWidget);
  });

  testWidgets('enables save only when allowed and not saving', (tester) async {
    await pumpHeader(
      tester,
      AppSheetHeader(
        title: 'إضافة ذكر',
        onDismiss: () {},
        onSave: () {},
        isSaveEnabled: false,
      ),
    );
    expect(saveButton(tester).onPressed, isNull);

    await pumpHeader(
      tester,
      AppSheetHeader(
        title: 'إضافة ذكر',
        onDismiss: () {},
        onSave: () {},
        isSaveEnabled: true,
        isSaving: true,
      ),
    );
    expect(saveButton(tester).onPressed, isNull);

    await pumpHeader(
      tester,
      AppSheetHeader(
        title: 'إضافة ذكر',
        onDismiss: () {},
        onSave: () {},
        isSaveEnabled: true,
      ),
    );
    expect(saveButton(tester).onPressed, isNotNull);
    expect(find.byType(AppIconButton), findsOneWidget);
  });
}

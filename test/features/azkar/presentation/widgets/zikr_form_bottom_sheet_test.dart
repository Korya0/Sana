import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/app_theme.dart';
import 'package:sana/features/azkar/domain/entities/zikr_entity.dart';
import 'package:sana/features/azkar/presentation/widgets/custom_azkar_form/zikr_form_bottom_sheet.dart';

void main() {
  Widget app(Widget home) => MaterialApp(
    theme: AppTheme.light,
    builder: (context, child) {
      AppSize.init(context);
      return Directionality(
        textDirection: TextDirection.rtl,
        child: child!,
      );
    },
    home: Scaffold(body: home),
  );

  Finder sheetFields(WidgetTester tester) => find.descendant(
    of: find.byType(ZikrFormBottomSheet),
    matching: find.byType(TextField),
  );

  Future<void> pumpSheet(WidgetTester tester, Widget sheet) async {
    tester.view.physicalSize = const Size(400, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(app(sheet));
  }

  testWidgets('closing the add sheet with unsaved text asks for confirmation', (
    tester,
  ) async {
    await pumpSheet(
      tester,
      ZikrFormBottomSheet(
        generateNextId: () => 1700000000000000,
        onSave: (_) {},
      ),
    );

    final fields = sheetFields(tester);
    expect(fields, findsNWidgets(3));

    await tester.enterText(fields.at(0), 'سبحان الله وبحمده');
    await tester.ensureVisible(find.text(AppStrings.cancel));
    await tester.pumpAndSettle();
    await tester.tap(find.text(AppStrings.cancel));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.unsavedChangesDialogTitle), findsOneWidget);
  });

  testWidgets('saves zikr with optional virtue', (tester) async {
    ZikrEntity? saved;

    await pumpSheet(
      tester,
      ZikrFormBottomSheet(
        generateNextId: () => 1700000000000001,
        onSave: (zikr) => saved = zikr,
      ),
    );

    final fields = sheetFields(tester);
    await tester.enterText(fields.at(0), 'سبحان الله');
    await tester.enterText(fields.at(1), 'فضل عظيم');
    await tester.enterText(fields.at(2), '33');
    await tester.ensureVisible(find.text(AppStrings.save));
    await tester.pumpAndSettle();
    await tester.tap(find.text(AppStrings.save));
    await tester.pumpAndSettle();

    expect(saved, isNotNull);
    expect(saved!.text, 'سبحان الله');
    expect(saved!.description, 'فضل عظيم');
    expect(saved!.count, 33);
  });

  testWidgets('saves zikr without virtue as null description', (tester) async {
    ZikrEntity? saved;

    await pumpSheet(
      tester,
      ZikrFormBottomSheet(
        generateNextId: () => 1700000000000002,
        onSave: (zikr) => saved = zikr,
      ),
    );

    final fields = sheetFields(tester);
    await tester.enterText(fields.at(0), 'الحمد لله');
    await tester.enterText(fields.at(2), '10');
    await tester.ensureVisible(find.text(AppStrings.save));
    await tester.pumpAndSettle();
    await tester.tap(find.text(AppStrings.save));
    await tester.pumpAndSettle();

    expect(saved, isNotNull);
    expect(saved!.description, isNull);
  });

  testWidgets('edits existing virtue and preserves it on save', (tester) async {
    ZikrEntity? saved;
    const initial = ZikrEntity(
      id: 7,
      text: 'الله أكبر',
      count: 5,
      description: 'فضل قديم',
      isUserAdded: true,
    );

    await pumpSheet(
      tester,
      ZikrFormBottomSheet(
        generateNextId: () => 999,
        initialZikr: initial,
        onSave: (zikr) => saved = zikr,
      ),
    );

    final fields = sheetFields(tester);
    expect(
      (tester.widget<TextField>(fields.at(1)).controller?.text ?? ''),
      'فضل قديم',
    );

    await tester.enterText(fields.at(1), 'فضل جديد');
    await tester.ensureVisible(find.text(AppStrings.save));
    await tester.pumpAndSettle();
    await tester.tap(find.text(AppStrings.save));
    await tester.pumpAndSettle();

    expect(saved, isNotNull);
    expect(saved!.description, 'فضل جديد');
    expect(saved!.id, initial.id);
  });

  testWidgets('limits virtue to 250 characters', (tester) async {
    await pumpSheet(
      tester,
      ZikrFormBottomSheet(
        generateNextId: () => 1700000000000003,
        onSave: (_) {},
      ),
    );

    final fields = sheetFields(tester);
    final longText = 'ا' * 300;
    await tester.enterText(fields.at(1), longText);
    await tester.pump();

    final value = tester.widget<TextField>(fields.at(1)).controller?.text ?? '';
    expect(value.length, AppConstants.zikrVirtueMaxLength);
  });

  testWidgets('virtue change marks sheet as dirty', (tester) async {
    await pumpSheet(
      tester,
      ZikrFormBottomSheet(
        generateNextId: () => 1700000000000004,
        onSave: (_) {},
      ),
    );

    final fields = sheetFields(tester);
    await tester.enterText(fields.at(1), 'فضل');
    await tester.ensureVisible(find.text(AppStrings.cancel));
    await tester.pumpAndSettle();
    await tester.tap(find.text(AppStrings.cancel));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.unsavedChangesDialogTitle), findsOneWidget);
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/theme/app_theme.dart';
import 'package:sana/core/widgets/inputs/app_text_area_field.dart';

void main() {
  testWidgets('does not grow when the content gets longer', (tester) async {
    tester.view.physicalSize = const Size(400, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final controller = TextEditingController();
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        builder: (context, child) {
          AppSize.init(context);
          return Directionality(
            textDirection: TextDirection.rtl,
            child: child!,
          );
        },
        home: Scaffold(
          body: SingleChildScrollView(
            child: AppTextAreaField(controller: controller),
          ),
        ),
      ),
    );

    final field = find.byType(TextField);
    final editable = find.descendant(
      of: field,
      matching: find.byType(EditableText),
    );
    final before = tester.getSize(field).height;

    await tester.enterText(field, 'سطر\n' * 40);
    await tester.pump();

    expect(tester.widget<TextField>(field).maxLines, isNull);
    expect(tester.getSize(field).height, before);
    expect(
      tester.getSize(editable).height,
      closeTo(before - AppSize.p12 * 2, 0.5),
    );
  });

  testWidgets('hint keeps its own padding away from the border', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(400, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final controller = TextEditingController();
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        builder: (context, child) {
          AppSize.init(context);
          return Directionality(
            textDirection: TextDirection.rtl,
            child: child!,
          );
        },
        home: Scaffold(
          body: SingleChildScrollView(
            child: AppTextAreaField(
              controller: controller,
              hint: 'اكتب النص هنا',
            ),
          ),
        ),
      ),
    );

    final fieldRect = tester.getRect(find.byType(TextField));
    final hintRect = tester.getRect(find.text('اكتب النص هنا'));

    expect(
      hintRect.top - fieldRect.top,
      greaterThanOrEqualTo(AppSize.p12 - 0.5),
    );
    expect(
      fieldRect.right - hintRect.right,
      greaterThanOrEqualTo(AppSize.p12 - 0.5),
    );

    await tester.enterText(find.byType(TextField), 'نص');
    await tester.pump();

    expect(find.text('اكتب النص هنا'), findsNothing);
  });

  testWidgets('caret starts exactly where the hint text starts', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(400, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final controller = TextEditingController();
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        builder: (context, child) {
          AppSize.init(context);
          return Directionality(
            textDirection: TextDirection.rtl,
            child: child!,
          );
        },
        home: Scaffold(
          body: SingleChildScrollView(
            child: AppTextAreaField(
              controller: controller,
              hint: 'اكتب النص هنا',
            ),
          ),
        ),
      ),
    );

    final editableRect = tester.getRect(find.byType(EditableText));
    final hintRect = tester.getRect(find.text('اكتب النص هنا'));

    expect(editableRect.top - hintRect.top, closeTo(0, 0.5));
    expect(hintRect.right - editableRect.right, closeTo(0, 0.5));
  });

  testWidgets('hint is painted behind the text field so the caret shows above it', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(400, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final controller = TextEditingController();
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        builder: (context, child) {
          AppSize.init(context);
          return Directionality(
            textDirection: TextDirection.rtl,
            child: child!,
          );
        },
        home: Scaffold(
          body: SingleChildScrollView(
            child: AppTextAreaField(
              controller: controller,
              hint: 'اكتب النص هنا',
            ),
          ),
        ),
      ),
    );

    final stack = tester.widget<Stack>(
      find
          .ancestor(
            of: find.byType(TextField),
            matching: find.byType(Stack),
          )
          .first,
    );

    expect(stack.children.first, isA<Positioned>());
    expect(stack.children.last, isA<TextField>());
  });

  testWidgets('caret stays inside the field border', (tester) async {
    tester.view.physicalSize = const Size(400, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final controller = TextEditingController();
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        builder: (context, child) {
          AppSize.init(context);
          return Directionality(
            textDirection: TextDirection.rtl,
            child: child!,
          );
        },
        home: Scaffold(
          body: SingleChildScrollView(
            child: AppTextAreaField(controller: controller),
          ),
        ),
      ),
    );

    await tester.enterText(find.byType(TextField), 'بسم الله');
    await tester.pump();

    final editableRect = tester.getRect(find.byType(EditableText));
    final borderRect = tester.getRect(
      find
          .ancestor(
            of: find.byType(TextField),
            matching: find.byType(Container),
          )
          .first,
    );

    expect(editableRect.left - borderRect.left, greaterThanOrEqualTo(2));
    expect(borderRect.right - editableRect.right, greaterThanOrEqualTo(2));
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/app_theme.dart';
import 'package:sana/core/theme/icons/app_icons.dart';
import 'package:sana/core/utils/context_extension.dart';
import 'package:sana/core/widgets/inputs/app_text_field.dart';

void main() {
  testWidgets(
    'locked field is read-only, non-focusable, and shows the lock icon',
    (tester) async {
      final controller = TextEditingController(text: 'أذكار الصباح');
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
            body: AppTextField(
              controller: controller,
              isLocked: true,
              trailing: const Icon(AppIcons.lock),
            ),
          ),
        ),
      );

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.readOnly, isTrue);
      expect(textField.canRequestFocus, isFalse);
      expect(find.byIcon(AppIcons.lock), findsOneWidget);
    },
  );

  testWidgets('marks required and optional labels', (tester) async {
    final requiredController = TextEditingController();
    final optionalController = TextEditingController();
    addTearDown(requiredController.dispose);
    addTearDown(optionalController.dispose);

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
          body: Column(
            children: [
              AppTextField(
                controller: requiredController,
                label: AppStrings.zikrText,
                isRequired: true,
              ),
              AppTextField(
                controller: optionalController,
                label: AppStrings.zikrVirtue,
                isOptional: true,
              ),
            ],
          ),
        ),
      ),
    );

    expect(find.text(AppStrings.requiredFieldMark), findsOneWidget);
    expect(
      find.text(AppStrings.optionalFieldMark),
      findsOneWidget,
    );
  });

  testWidgets('styles the required mark in the error color and size', (
    tester,
  ) async {
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
          body: AppTextField(
            controller: controller,
            label: AppStrings.zikrText,
            isRequired: true,
          ),
        ),
      ),
    );

    final markFinder = find.text(AppStrings.requiredFieldMark);
    final mark = tester.widget<Text>(markFinder);
    final context = tester.element(markFinder);

    expect(mark.style?.color, context.color.errorText);
    expect(mark.style?.fontSize, AppSize.f14);
    expect(mark.style?.fontWeight, FontWeight.w700);
    expect(mark.semanticsLabel, AppStrings.requiredField);
  });

  testWidgets('text field is RTL with logical start alignment', (tester) async {
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
          body: AppTextField(controller: controller),
        ),
      ),
    );

    final field = tester.widget<TextField>(find.byType(TextField));
    expect(field.textDirection, TextDirection.rtl);
    expect(field.textAlign, TextAlign.start);
  });

  testWidgets('caret lands at the end when tapping the end of an Arabic word', (
    tester,
  ) async {
    const text = 'سبحان الله';
    final controller = TextEditingController(text: text);
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
          body: AppTextField(controller: controller),
        ),
      ),
    );

    final rect = tester.getRect(find.byType(TextField));
    // In RTL, the text starts on the right and ends towards the left.
    // Tapping near the left edge of the text field (e.g. rect.left + 16) taps the end of the text.
    await tester.tapAt(Offset(rect.left + 16, rect.center.dy));
    await tester.pump();

    expect(controller.selection.baseOffset, text.length);
  });

  testWidgets('typing at an interior caret inserts at the caret', (
    tester,
  ) async {
    final controller = TextEditingController(text: 'سبحان الله');
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
          body: AppTextField(controller: controller),
        ),
      ),
    );

    await tester.tap(find.byType(TextField));
    await tester.pump();

    controller.selection = const TextSelection.collapsed(offset: 4);
    await tester.pump();

    tester.testTextInput.updateEditingValue(
      const TextEditingValue(
        text: 'سبحاَن الله',
        selection: TextSelection.collapsed(offset: 5),
      ),
    );
    await tester.pump();

    expect(controller.text, 'سبحاَن الله');
    expect(controller.selection.baseOffset, 5);
  });

  testWidgets('character counter uses user-perceived characters', (
    tester,
  ) async {
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
          body: AppTextField(
            controller: controller,
            maxLength: 5,
            showCharacterCount: true,
          ),
        ),
      ),
    );

    // Enter 6 user-perceived characters composed of letter + diacritic: 'سَ' * 6
    await tester.enterText(find.byType(TextField), 'سَ' * 6);
    await tester.pump();

    // The counter text should show '5 / 5' because it's limited to 5 characters
    expect(find.text(AppStrings.charCounter(5, 5)), findsOneWidget);
    expect(controller.text.characters.length, 5);
  });
}

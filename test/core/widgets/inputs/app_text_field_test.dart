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
}

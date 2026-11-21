import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/app_theme.dart';
import 'package:sana/core/utils/context_extension.dart';
import 'package:sana/core/widgets/buttons/app_text_button.dart';
import 'package:sana/features/azkar/domain/entities/tasbeeh_item_entity.dart';
import 'package:sana/features/azkar/presentation/widgets/common/tasbeeh_item_form_bottom_sheet.dart';

void main() {
  testWidgets('limits the tasbeeh text field to 500 characters', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(400, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

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
        home: const Scaffold(body: TasbeehItemFormBottomSheet()),
      ),
    );

    final textField = find
        .descendant(
          of: find.byType(TasbeehItemFormBottomSheet),
          matching: find.byType(TextField),
        )
        .first;
    final field = tester.widget<TextField>(textField);
    expect(field.maxLength, AppConstants.tasbeehTextMaxLength);

    await tester.enterText(
      textField,
      'ا' * (AppConstants.tasbeehTextMaxLength + 1),
    );
    await tester.pump();

    expect(
      tester.widget<TextField>(textField).controller!.text.length,
      AppConstants.tasbeehTextMaxLength,
    );
    expect(
      find.text(
        AppStrings.charCounter(
          AppConstants.tasbeehTextMaxLength,
          AppConstants.tasbeehTextMaxLength,
        ),
      ),
      findsOneWidget,
    );
  });

  testWidgets('counts user-perceived characters in the tasbeeh text', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(400, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

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
        home: const Scaffold(body: TasbeehItemFormBottomSheet()),
      ),
    );

    final textField = find
        .descendant(
          of: find.byType(TasbeehItemFormBottomSheet),
          matching: find.byType(TextField),
        )
        .first;
    // A fatha is a combining mark: "سَ" is two code units but one
    // user-perceived character. The field and its counter count graphemes.
    const marked = 'سَ';
    await tester.enterText(textField, marked * 250);
    await tester.pump();

    var value = tester.widget<TextField>(textField).controller?.text ?? '';
    expect(value.length, AppConstants.tasbeehTextMaxLength);
    expect(value.characters.length, 250);
    expect(
      find.text(
        AppStrings.charCounter(250, AppConstants.tasbeehTextMaxLength),
      ),
      findsOneWidget,
    );

    // The limit itself is applied to user-perceived characters, so 600
    // marked characters are trimmed to 500 of them (not 250).
    await tester.enterText(textField, marked * 600);
    await tester.pump();

    value = tester.widget<TextField>(textField).controller?.text ?? '';
    expect(value.characters.length, AppConstants.tasbeehTextMaxLength);
    expect(
      find.text(
        AppStrings.charCounter(
          AppConstants.tasbeehTextMaxLength,
          AppConstants.tasbeehTextMaxLength,
        ),
      ),
      findsOneWidget,
    );
  });

  testWidgets('keeps the tasbeeh text field at a fixed height', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(400, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

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
        home: const Scaffold(body: TasbeehItemFormBottomSheet()),
      ),
    );

    final textField = find
        .descendant(
          of: find.byType(TasbeehItemFormBottomSheet),
          matching: find.byType(TextField),
        )
        .first;
    final before = tester.getSize(textField).height;

    await tester.enterText(textField, 'سبحان الله وبحمده ' * 40);
    await tester.pump();

    expect(tester.getSize(textField).height, before);
  });

  testWidgets('accepts a four-digit target count', (tester) async {
    tester.view.physicalSize = const Size(400, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

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
        home: const Scaffold(body: TasbeehItemFormBottomSheet()),
      ),
    );

    final countField = find
        .descendant(
          of: find.byType(TasbeehItemFormBottomSheet),
          matching: find.byType(TextField),
        )
        .last;
    await tester.enterText(countField, '12345');
    await tester.pump();

    expect(
      tester.widget<TextField>(countField).controller?.text,
      '1234',
    );
  });

  testWidgets('places the caret at the tapped end of an Arabic name', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(400, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    const text = 'سبحان الله';
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
          body: TasbeehItemFormBottomSheet(
            initialItem: TasbeehItemEntity(
              id: 'a',
              text: text,
              currentCount: 0,
              lastUsedAt: DateTime(2026),
            ),
          ),
        ),
      ),
    );

    final nameField = find
        .descendant(
          of: find.byType(TasbeehItemFormBottomSheet),
          matching: find.byType(TextField),
        )
        .first;
    final field = tester.widget<TextField>(nameField);
    final controller = field.controller!;
    expect(field.textDirection, TextDirection.rtl);
    expect(field.textAlign, TextAlign.start);
    final rect = tester.getRect(nameField);

    await tester.tapAt(Offset(rect.left + 16, rect.center.dy));
    await tester.pump();

    expect(controller.selection.baseOffset, text.length);
  });

  testWidgets(
    'uses a fixed-height text field with required and optional marks',
    (
      tester,
    ) async {
      tester.view.physicalSize = const Size(400, 1200);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

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
          home: const Scaffold(body: TasbeehItemFormBottomSheet()),
        ),
      );

      final fields = find.descendant(
        of: find.byType(TasbeehItemFormBottomSheet),
        matching: find.byType(TextField),
      );
      final textField = tester.widget<TextField>(fields.first);
      expect(textField.expands, isTrue);
      expect(textField.minLines, isNull);
      expect(textField.maxLines, isNull);
      expect(find.text(AppStrings.requiredFieldMark), findsOneWidget);
      expect(find.text(AppStrings.optionalFieldMark), findsOneWidget);
    },
  );

  testWidgets('shows the required mark in the error color', (tester) async {
    tester.view.physicalSize = const Size(400, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

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
        home: const Scaffold(body: TasbeehItemFormBottomSheet()),
      ),
    );

    final markFinder = find.text(AppStrings.requiredFieldMark);
    final mark = tester.widget<Text>(markFinder);
    final context = tester.element(markFinder);

    expect(mark.style?.color, context.color.errorText);
  });

  testWidgets('saves the tasbeeh with an optional empty target', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(400, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    ({String text, int? targetCount})? result;
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
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () async {
                result =
                    await showModalBottomSheet<
                      ({String text, int? targetCount})
                    >(
                      context: context,
                      isScrollControlled: true,
                      builder: (_) => const TasbeehItemFormBottomSheet(),
                    );
              },
              child: const Text('open'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    final fields = find.descendant(
      of: find.byType(TasbeehItemFormBottomSheet),
      matching: find.byType(TextField),
    );
    await tester.enterText(fields.first, 'سبحان الله');
    await tester.ensureVisible(find.text(AppStrings.save));
    await tester.pumpAndSettle();
    await tester.tap(find.text(AppStrings.save));
    await tester.pumpAndSettle();

    expect(result, isNotNull);
    expect(result!.text, 'سبحان الله');
    expect(result!.targetCount, isNull);
  });

  testWidgets('shows an error for a zero target', (tester) async {
    tester.view.physicalSize = const Size(400, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    ({String text, int? targetCount})? result;
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
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () async {
                result =
                    await showModalBottomSheet<
                      ({String text, int? targetCount})
                    >(
                      context: context,
                      isScrollControlled: true,
                      builder: (_) => const TasbeehItemFormBottomSheet(),
                    );
              },
              child: const Text('open'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    final fields = find.descendant(
      of: find.byType(TasbeehItemFormBottomSheet),
      matching: find.byType(TextField),
    );
    await tester.enterText(fields.first, 'سبحان الله');
    await tester.enterText(fields.last, '0');
    await tester.ensureVisible(find.text(AppStrings.save));
    await tester.pumpAndSettle();
    await tester.tap(find.text(AppStrings.save));
    await tester.pumpAndSettle();

    expect(result, isNull);
    expect(find.text(AppStrings.targetCountGreaterThanZero), findsOneWidget);
  });

  testWidgets('places the caret at the tapped end of an Arabic name', (
    tester,
  ) async {
    const text = 'سبحان الله وبحمده';
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
          body: TasbeehItemFormBottomSheet(
            initialItem: TasbeehItemEntity(
              id: '1',
              text: text,
              targetCount: 33,
              currentCount: 0,
              lastUsedAt: DateTime(2026, 1, 1),
            ),
          ),
        ),
      ),
    );

    final fieldFinder = find.descendant(
      of: find.byType(TasbeehItemFormBottomSheet),
      matching: find.byType(TextField),
    ).first;
    final rect = tester.getRect(fieldFinder);
    await tester.tapAt(Offset(rect.left + 16, rect.center.dy));
    await tester.pump();

    final field = tester.widget<TextField>(fieldFinder);
    expect(field.controller!.selection.baseOffset, text.length);
  });

  testWidgets('rejects short and duplicate tasbeeh text', (tester) async {
    tester.view.physicalSize = const Size(400, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

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
        home: const Scaffold(
          body: TasbeehItemFormBottomSheet(
            existingTexts: {'سبحان الله'},
          ),
        ),
      ),
    );

    final fields = find.descendant(
      of: find.byType(TasbeehItemFormBottomSheet),
      matching: find.byType(TextField),
    );
    final save = find.ancestor(
      of: find.text(AppStrings.save),
      matching: find.byType(AppTextButton),
    );

    await tester.enterText(fields.first, 'ا');
    await tester.pump();
    expect(tester.widget<AppTextButton>(save).onPressed, isNull);

    await tester.enterText(fields.first, 'سبحان الله');
    await tester.pump();
    expect(tester.widget<AppTextButton>(save).onPressed, isNull);

    await tester.enterText(fields.first, 'الحمد لله');
    await tester.pump();
    expect(tester.widget<AppTextButton>(save).onPressed, isNotNull);
  });
}

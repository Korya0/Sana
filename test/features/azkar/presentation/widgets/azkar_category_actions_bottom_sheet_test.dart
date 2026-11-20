import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/app_theme.dart';
import 'package:sana/core/widgets/overlays/app_bottom_sheet.dart';
import 'package:sana/features/azkar/presentation/cubits/azkar_tasbeeh_settings/azkar_tasbeeh_settings_cubit.dart';
import 'package:sana/features/azkar/presentation/widgets/common/azkar_category_actions_bottom_sheet.dart';
import 'package:sana/features/azkar/presentation/widgets/common/option_tile.dart';

import 'azkar_widget_test_harness.dart';

void main() {
  testWidgets(
    'category actions sheet wraps its content instead of filling the screen',
    (tester) async {
      await tester.pumpWidget(_app());

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      final screenHeight =
          tester.view.physicalSize.height / tester.view.devicePixelRatio;
      final sheetHeight = tester
          .getSize(find.byType(AzkarCategoryActionsBottomSheet))
          .height;

      expect(sheetHeight, lessThan(screenHeight));
    },
  );

  testWidgets('returns the edit action for a custom category', (tester) async {
    AzkarCategoryAction? result;
    await tester.pumpWidget(_app(onResult: (value) => result = value));

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.restoreOriginal), findsNothing);
    expect(find.text(AppStrings.deleteZikr), findsOneWidget);

    await tester.tap(find.text(AppStrings.editZikr));
    await tester.pumpAndSettle();

    expect(result, AzkarCategoryAction.edit);
  });

  testWidgets('returns the delete action for a custom category', (
    tester,
  ) async {
    AzkarCategoryAction? result;
    await tester.pumpWidget(_app(onResult: (value) => result = value));

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    await tester.tap(find.text(AppStrings.deleteZikr));
    await tester.pumpAndSettle();

    expect(result, AzkarCategoryAction.delete);
  });

  testWidgets('returns the restore action for a built-in category when it can '
      'be restored', (tester) async {
    AzkarCategoryAction? result;
    await tester.pumpWidget(
      _app(isCustom: false, canRestore: true, onResult: (value) => result = value),
    );

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.deleteZikr), findsNothing);
    expect(find.text(AppStrings.restoreOriginal), findsOneWidget);

    await tester.tap(find.text(AppStrings.restoreOriginal));
    await tester.pumpAndSettle();

    expect(result, AzkarCategoryAction.restore);
  });

  testWidgets('a built-in category that cannot be restored has a disabled '
      'restore option', (tester) async {
    AzkarCategoryAction? result;
    await tester.pumpWidget(
      _app(isCustom: false, onResult: (value) => result = value),
    );

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    final restore = tester.widget<OptionTile>(
      find.ancestor(
        of: find.text(AppStrings.restoreOriginal),
        matching: find.byType(OptionTile),
      ),
    );
    expect(restore.onPressed, isNull);

    await tester.tap(find.text(AppStrings.restoreOriginal));
    await tester.pumpAndSettle();
    expect(result, isNull);
  });

  testWidgets('nested reading settings are provided with the injected cubit '
      'and return the font size action', (tester) async {
    tester.view.physicalSize = const Size(400, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final cubit = await createLoadedSettingsCubit();
    AzkarCategoryAction? result;
    await tester.pumpWidget(
      _app(
        showAzkarTasbeehSettings: true,
        settingsCubit: cubit,
        onResult: (value) => result = value,
      ),
    );

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.fontSize), findsOneWidget);
    expect(find.text(AppStrings.hapticFeedback), findsOneWidget);
    expect(find.text(AppStrings.volumeButtonCount), findsOneWidget);

    await tester.tap(find.text(AppStrings.fontSize));
    await tester.pumpAndSettle();

    expect(result, AzkarCategoryAction.fontSize);
  });

  testWidgets('the close button dismisses the sheet without a result', (
    tester,
  ) async {
    AzkarCategoryAction? result;
    await tester.pumpWidget(_app(onResult: (value) => result = value));

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip(AppStrings.close));
    await tester.pumpAndSettle();

    expect(result, isNull);
    expect(find.byType(AzkarCategoryActionsBottomSheet), findsNothing);
  });
}

Widget _app({
  bool isCustom = true,
  bool canRestore = false,
  bool showAzkarTasbeehSettings = false,
  AzkarTasbeehSettingsCubit? settingsCubit,
  void Function(AzkarCategoryAction?)? onResult,
}) => MaterialApp(
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
            final result = await AppBottomSheet.show<AzkarCategoryAction>(
              context: context,
              child: AzkarCategoryActionsBottomSheet(
                isCustom: isCustom,
                canRestore: canRestore,
                showAzkarTasbeehSettings: showAzkarTasbeehSettings,
                azkarTasbeehSettingsCubit: settingsCubit,
              ),
            );
            onResult?.call(result);
          },
          child: const Text('open'),
        ),
      ),
    ),
  ),
);

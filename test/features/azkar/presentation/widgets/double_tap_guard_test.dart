import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/error/result.dart';
import 'package:sana/core/theme/app_theme.dart';
import 'package:sana/core/theme/icons/app_icons.dart';
import 'package:sana/core/widgets/buttons/app_primary_button.dart';
import 'package:sana/core/widgets/overlays/app_bottom_sheet.dart';
import 'package:sana/features/azkar/domain/entities/reading_settings_entity.dart';
import 'package:sana/features/azkar/domain/entities/zikr_entity.dart';
import 'package:sana/features/azkar/domain/repositories/reading_settings_repository.dart';
import 'package:sana/features/azkar/domain/use_cases/get_reading_settings_use_case.dart';
import 'package:sana/features/azkar/domain/use_cases/update_reading_settings_use_case.dart';
import 'package:sana/features/azkar/presentation/cubits/reading_settings/reading_settings_cubit.dart';
import 'package:sana/features/azkar/presentation/widgets/azkar_section/azkar_home_options_bottom_sheet.dart';
import 'package:sana/features/azkar/presentation/widgets/azkar_categories/azkar_category_actions_bottom_sheet.dart';
import 'package:sana/features/azkar/presentation/widgets/custom_azkar/add_zikr_bottom_sheet.dart';
import 'package:sana/features/azkar/presentation/widgets/reading_settings/reading_settings_bottom_sheet.dart';
import 'package:sana/features/azkar/presentation/widgets/zikr_list/zikr_card/edit_target_count_bottom_sheet.dart';

void main() {
  group('rapid taps', () {
    testWidgets('the add-zikr sheet saves once and keeps the form open', (
      tester,
    ) async {
      final saved = <ZikrEntity>[];

      await _openSheetFromSecondPage(
        tester,
        (context) => AppBottomSheet.show<void>(
          context: context,
          enableDrag: false,
          child: AddZikrBottomSheet(
            nextId: () => 1700000000000000,
            onSave: saved.add,
          ),
        ),
      );

      final fields = find.descendant(
        of: find.byType(AddZikrBottomSheet),
        matching: find.byType(TextField),
      );
      await tester.enterText(fields.at(0), 'سبحان الله');
      await tester.enterText(fields.at(1), '33');

      final save = find.descendant(
        of: find.byType(AddZikrBottomSheet),
        matching: find.widgetWithText(AppPrimaryButton, AppStrings.save),
      );
      await tester.tap(save);
      await tester.tap(save);
      await tester.pump(const Duration(milliseconds: 200));
      await tester.pumpAndSettle();

      expect(saved, hasLength(1));
      expect(find.text(_secondPageLabel), findsOneWidget);
    });

    testWidgets('a home option sheet keeps the page below it', (tester) async {
      AzkarHomeOption? captured;

      await _openSheetFromSecondPage(tester, (context) async {
        captured = await AppBottomSheet.show<AzkarHomeOption>(
          context: context,
          child: const AzkarHomeOptionsBottomSheet(),
        );
      });

      final tile = find.text(AppStrings.fontSize);
      await tester.tap(tile);
      await tester.tap(tile);
      await tester.pump(const Duration(milliseconds: 200));
      await tester.pumpAndSettle();

      expect(captured, AzkarHomeOption.fontSize);
      expect(find.text(_secondPageLabel), findsOneWidget);
    });

    testWidgets('a category action sheet keeps the page below it', (
      tester,
    ) async {
      AzkarCategoryAction? captured;

      await _openSheetFromSecondPage(tester, (context) async {
        captured = await AppBottomSheet.show<AzkarCategoryAction>(
          context: context,
          child: const AzkarCategoryActionsBottomSheet(
            isCustom: true,
            canRestore: true,
          ),
        );
      });

      final tile = find.text(AppStrings.editAzkar);
      await tester.tap(tile);
      await tester.tap(tile);
      await tester.pump(const Duration(milliseconds: 200));
      await tester.pumpAndSettle();

      expect(captured, AzkarCategoryAction.edit);
      expect(find.text(_secondPageLabel), findsOneWidget);
    });

    testWidgets('the target count sheet keeps the page below it', (
      tester,
    ) async {
      await _openSheetFromSecondPage(
        tester,
        (context) => AppBottomSheet.show<int>(
          context: context,
          enableDrag: false,
          child: const EditTargetCountBottomSheet(initialCount: 33),
        ),
      );

      final save = find.widgetWithText(AppPrimaryButton, AppStrings.save);
      await tester.tap(save);
      await tester.tap(save);
      await tester.pump(const Duration(milliseconds: 200));
      await tester.pumpAndSettle();

      expect(find.text(_secondPageLabel), findsOneWidget);
    });

    testWidgets('the font size back button keeps the page below it', (
      tester,
    ) async {
      final repository = _FakeReadingSettingsRepository();
      final cubit = ReadingSettingsCubit(
        GetReadingSettingsUseCase(repository),
        UpdateReadingSettingsUseCase(repository),
      );
      await cubit.loadSettings();
      addTearDown(cubit.close);

      await _openSheetFromSecondPage(
        tester,
        (context) => AppBottomSheet.show<bool>(
          context: context,
          child: ReadingSettingsBottomSheet(
            cubit: cubit,
            showBackButton: true,
          ),
        ),
      );

      final back = find.byIcon(AppIcons.back);
      await tester.tap(back);
      await tester.tap(back);
      await tester.pump(const Duration(milliseconds: 200));
      await tester.pumpAndSettle();

      expect(find.text(_secondPageLabel), findsOneWidget);
    });
  });
}

const _secondPageLabel = 'second page';

Future<void> _openSheetFromSecondPage(
  WidgetTester tester,
  Future<void> Function(BuildContext context) openSheet,
) async {
  tester.view.physicalSize = const Size(400, 900);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.light,
      builder: (context, child) {
        AppSize.init(context);
        return Directionality(textDirection: TextDirection.rtl, child: child!);
      },
      home: Scaffold(
        body: Builder(
          builder: (context) => Center(
            child: TextButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => Scaffold(
                    body: Center(
                      child: Builder(
                        builder: (context) => TextButton(
                          onPressed: () => openSheet(context),
                          child: const Text(_secondPageLabel),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              child: const Text('push'),
            ),
          ),
        ),
      ),
    ),
  );

  await tester.tap(find.text('push'));
  await tester.pumpAndSettle();
  await tester.tap(find.text(_secondPageLabel));
  await tester.pumpAndSettle();
}

class _FakeReadingSettingsRepository implements ReadingSettingsRepository {
  @override
  Future<Result<ReadingSettingsEntity>> getReadingSettings() async =>
      Result.success(ReadingSettingsEntity(fontSize: 20));

  @override
  Future<Result<void>> updateReadingSettings(
    ReadingSettingsEntity settings,
  ) async => const Result.success(null);
}

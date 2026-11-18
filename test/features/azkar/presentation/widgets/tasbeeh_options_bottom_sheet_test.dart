import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/error/result.dart';
import 'package:sana/core/theme/app_theme.dart';
import 'package:sana/core/theme/icons/app_icons.dart';
import 'package:sana/core/widgets/dividers/app_divider.dart';
import 'package:sana/core/widgets/overlays/app_bottom_sheet.dart';
import 'package:sana/features/azkar/domain/entities/azkar_tasbeeh_settings_entity.dart';
import 'package:sana/features/azkar/domain/entities/tasbeeh_item_entity.dart';
import 'package:sana/features/azkar/domain/repositories/azkar_tasbeeh_settings_repository.dart';
import 'package:sana/features/azkar/domain/use_cases/get_azkar_tasbeeh_settings_use_case.dart';
import 'package:sana/features/azkar/domain/use_cases/update_azkar_tasbeeh_settings_use_case.dart';
import 'package:sana/features/azkar/presentation/cubits/azkar_tasbeeh_settings/azkar_tasbeeh_settings_cubit.dart';
import 'package:sana/features/azkar/presentation/widgets/common/tasbeeh_options_bottom_sheet.dart';

void main() {
  testWidgets('centers item actions with its label and adds a divider', (
    tester,
  ) async {
    final item = TasbeehItemEntity(
      id: 'item-1',
      text: 'سبحان الله',
      currentCount: 0,
      lastUsedAt: DateTime(2026),
    );
    await _open(tester, items: [item], showReadingSettings: false);

    final label = find.text(item.text);
    final labelCenter = tester.getCenter(label).dy;

    expect(find.byType(AppDivider), findsOneWidget);
    expect(
      tester.getCenter(find.byIcon(AppIcons.edit)).dy,
      moreOrLessEquals(labelCenter, epsilon: 0.5),
    );
    expect(
      tester.getCenter(find.byIcon(AppIcons.delete)).dy,
      moreOrLessEquals(labelCenter, epsilon: 0.5),
    );
  });

  testWidgets('home list omits the reading settings section', (tester) async {
    await _open(tester, showReadingSettings: false);

    expect(find.text(AppStrings.allTasbeeh), findsOneWidget);
    expect(find.text(AppStrings.fontSize), findsNothing);
    expect(find.text(AppStrings.hapticFeedback), findsNothing);
  });

  testWidgets('keeps reading settings in the default screen options sheet', (
    tester,
  ) async {
    await _open(tester);

    expect(find.text(AppStrings.fontSize), findsOneWidget);
    expect(find.text(AppStrings.hapticFeedback), findsOneWidget);
  });

  testWidgets('empty list shows the empty hint and returns the create action', (
    tester,
  ) async {
    TasbeehOptionResult? result;
    await _open(tester, onResult: (value) => result = value);

    expect(find.text(AppStrings.tasbeehEmpty), findsOneWidget);
    await tester.tap(find.text(AppStrings.addTasbeeh));
    await tester.pumpAndSettle();

    expect(result?.action, TasbeehOption.create);
    expect(result?.selectedItemId, isNull);
  });

  testWidgets('edit and delete return the selected item id', (tester) async {
    final item = TasbeehItemEntity(
      id: 'item-1',
      text: 'سبحان الله',
      currentCount: 0,
      lastUsedAt: DateTime(2026),
    );

    TasbeehOptionResult? editResult;
    await _open(
      tester,
      items: [item],
      onResult: (value) {
        editResult = value;
      },
    );
    await tester.tap(find.byIcon(AppIcons.edit));
    await tester.pumpAndSettle();

    expect(editResult?.action, TasbeehOption.edit);
    expect(editResult?.selectedItemId, item.id);

    TasbeehOptionResult? deleteResult;
    await _open(
      tester,
      items: [item],
      onResult: (value) {
        deleteResult = value;
      },
    );
    await tester.tap(find.byIcon(AppIcons.delete));
    await tester.pumpAndSettle();

    expect(deleteResult?.action, TasbeehOption.delete);
    expect(deleteResult?.selectedItemId, item.id);
  });
}

Future<void> _open(
  WidgetTester tester, {
  bool showReadingSettings = true,
  List<TasbeehItemEntity> items = const [],
  void Function(TasbeehOptionResult?)? onResult,
}) async {
  tester.view.physicalSize = const Size(400, 900);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  final repository = _FakeSettingsRepository();
  final cubit = AzkarTasbeehSettingsCubit(
    GetAzkarTasbeehSettingsUseCase(repository),
    UpdateAzkarTasbeehSettingsUseCase(repository),
  );
  await cubit.loadSettings();
  addTearDown(cubit.close);

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
              onPressed: () async {
                final result = await AppBottomSheet.show<TasbeehOptionResult>(
                  context: context,
                  child: TasbeehOptionsBottomSheet(
                    items: items,
                    selectedItemId: null,
                    azkarTasbeehSettingsCubit: cubit,
                    showReadingSettings: showReadingSettings,
                  ),
                );
                onResult?.call(result);
              },
              child: const Text('open'),
            ),
          ),
        ),
      ),
    ),
  );

  await tester.tap(find.text('open'));
  await tester.pumpAndSettle();
}

class _FakeSettingsRepository implements AzkarTasbeehSettingsRepository {
  @override
  Future<Result<AzkarTasbeehSettingsEntity>> getAzkarTasbeehSettings() async =>
      Result.success(AzkarTasbeehSettingsEntity(fontSize: 20));

  @override
  Future<Result<void>> updateAzkarTasbeehSettings(
    AzkarTasbeehSettingsEntity settings,
  ) async => const Result.success(null);
}

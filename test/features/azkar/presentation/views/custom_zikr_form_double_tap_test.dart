import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/di/app_injector.dart';
import 'package:sana/core/error/result.dart';
import 'package:sana/core/theme/app_theme.dart';
import 'package:sana/core/theme/icons/app_icons.dart';
import 'package:sana/core/widgets/buttons/app_primary_button.dart';
import 'package:sana/core/widgets/buttons/app_text_button.dart';
import 'package:sana/features/azkar/domain/entities/azkar_category_entity.dart';
import 'package:sana/features/azkar/domain/entities/custom_category_entity.dart';
import 'package:sana/features/azkar/domain/entities/reading_settings_entity.dart';
import 'package:sana/features/azkar/domain/entities/zikr_entity.dart';
import 'package:sana/features/azkar/domain/repositories/azkar_repository.dart';
import 'package:sana/features/azkar/domain/repositories/custom_azkar_repository.dart';
import 'package:sana/features/azkar/domain/repositories/reading_settings_repository.dart';
import 'package:sana/features/azkar/domain/use_cases/delete_custom_category_use_case.dart';
import 'package:sana/features/azkar/domain/use_cases/get_azkar_categories_use_case.dart';
import 'package:sana/features/azkar/domain/use_cases/get_custom_categories_use_case.dart';
import 'package:sana/features/azkar/domain/use_cases/get_reading_settings_use_case.dart';
import 'package:sana/features/azkar/domain/use_cases/save_custom_category_use_case.dart';
import 'package:sana/features/azkar/domain/use_cases/update_reading_settings_use_case.dart';
import 'package:sana/features/azkar/presentation/cubits/custom_azkar/custom_azkar_cubit.dart';
import 'package:sana/features/azkar/presentation/cubits/reading_settings/reading_settings_cubit.dart';
import 'package:sana/features/azkar/presentation/views/custom_zikr_form_view.dart';
import 'package:sana/features/azkar/presentation/widgets/custom_azkar/add_zikr_bottom_sheet.dart';

void main() {
  late _RecordingCustomRepository repository;

  setUp(() {
    repository = _RecordingCustomRepository();
    sl.registerFactory<CustomAzkarCubit>(
      () => CustomAzkarCubit(
        getCustomCategoriesUseCase: GetCustomCategoriesUseCase(repository),
        saveCustomCategoryUseCase: SaveCustomCategoryUseCase(repository),
        deleteCustomCategoryUseCase: DeleteCustomCategoryUseCase(repository),
        getAzkarCategoriesUseCase: GetAzkarCategoriesUseCase(
          const _EmptyAzkarRepository(),
        ),
      ),
    );
    sl.registerFactory<ReadingSettingsCubit>(() {
      final settings = _FakeReadingSettingsRepository();
      return ReadingSettingsCubit(
        GetReadingSettingsUseCase(settings),
        UpdateReadingSettingsUseCase(settings),
      );
    });
  });

  tearDown(() async => sl.reset());

  testWidgets('double tapping save stores the category once', (tester) async {
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
            builder: (context) => Center(
              child: TextButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const CustomZikrFormView(),
                  ),
                ),
                child: const Text('open form'),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('open form'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).first, 'قسمي');

    // Add one zikr so the form can be saved.
    await tester.tap(find.byIcon(AppIcons.add));
    await tester.pump(const Duration(milliseconds: 150));
    await tester.pumpAndSettle();

    final sheetFields = find.descendant(
      of: find.byType(AddZikrBottomSheet),
      matching: find.byType(TextField),
    );
    await tester.enterText(sheetFields.at(0), 'سبحان الله');
    await tester.enterText(sheetFields.at(2), '33');
    final sheetSave = find.descendant(
      of: find.byType(AddZikrBottomSheet),
      matching: find.widgetWithText(AppPrimaryButton, AppStrings.save),
    );
    await tester.ensureVisible(sheetSave);
    await tester.pumpAndSettle();
    await tester.tap(sheetSave);
    await tester.pump(const Duration(milliseconds: 150));
    await tester.pumpAndSettle();

    final save = find.widgetWithText(AppTextButton, AppStrings.save);
    await tester.tap(save);
    await tester.tap(save);
    await tester.pump(const Duration(milliseconds: 200));
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 3));

    expect(repository.saves, hasLength(1));
    expect(repository.saves.single.name, 'قسمي');
  });
}

class _RecordingCustomRepository implements CustomAzkarRepository {
  final List<CustomCategoryEntity> saves = [];

  @override
  Future<Result<void>> saveCustomCategory(CustomCategoryEntity category) async {
    saves.add(category);
    return const Result.success(null);
  }

  @override
  Future<Result<void>> deleteCustomCategory(String id) async =>
      const Result.success(null);

  @override
  Future<Result<CustomCategoryEntity?>> getCustomCategoryById(
    String id,
  ) async => const Result.success(null);

  @override
  Future<Result<List<CustomCategoryEntity>>> getCustomCategories() async =>
      const Result.success([]);
}

class _EmptyAzkarRepository implements AzkarRepository {
  const _EmptyAzkarRepository();

  @override
  Future<Result<List<AzkarCategoryEntity>>> getCategories() async =>
      const Result.success([]);

  @override
  Future<Result<List<ZikrEntity>>> getAzkarByCategory(
    String categoryKey,
  ) async => const Result.success([]);
}

class _FakeReadingSettingsRepository implements ReadingSettingsRepository {
  @override
  Future<Result<ReadingSettingsEntity>> getReadingSettings() async =>
      Result.success(ReadingSettingsEntity(fontSize: 26));

  @override
  Future<Result<void>> updateReadingSettings(
    ReadingSettingsEntity settings,
  ) async => const Result.success(null);
}

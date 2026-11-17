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
import 'package:sana/features/azkar/domain/entities/azkar_tasbeeh_settings_entity.dart';
import 'package:sana/features/azkar/domain/entities/zikr_entity.dart';
import 'package:sana/features/azkar/domain/repositories/azkar_repository.dart';
import 'package:sana/features/azkar/domain/repositories/custom_category_repository.dart';
import 'package:sana/features/azkar/domain/repositories/azkar_tasbeeh_settings_repository.dart';
import 'package:sana/features/azkar/domain/use_cases/delete_custom_category_use_case.dart';
import 'package:sana/features/azkar/domain/use_cases/get_azkar_categories_use_case.dart';
import 'package:sana/features/azkar/domain/use_cases/get_custom_categories_use_case.dart';
import 'package:sana/features/azkar/domain/use_cases/get_azkar_tasbeeh_settings_use_case.dart';
import 'package:sana/features/azkar/domain/use_cases/save_custom_category_use_case.dart';
import 'package:sana/features/azkar/domain/use_cases/update_azkar_tasbeeh_settings_use_case.dart';
import 'package:sana/features/azkar/presentation/cubits/custom_azkar/custom_azkar_cubit.dart';
import 'package:sana/features/azkar/presentation/cubits/azkar_tasbeeh_settings/azkar_tasbeeh_settings_cubit.dart';
import 'package:sana/features/azkar/presentation/views/custom_azkar_form_view.dart';
import 'package:sana/features/azkar/presentation/widgets/custom_azkar_form/zikr_form_bottom_sheet.dart';

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
    sl.registerFactory<AzkarTasbeehSettingsCubit>(() {
      final settings = _FakeAzkarTasbeehSettingsRepository();
      return AzkarTasbeehSettingsCubit(
        GetAzkarTasbeehSettingsUseCase(settings),
        UpdateAzkarTasbeehSettingsUseCase(settings),
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
                    builder: (_) => const CustomAzkarFormView(),
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
      of: find.byType(ZikrFormBottomSheet),
      matching: find.byType(TextField),
    );
    await tester.enterText(sheetFields.at(0), 'سبحان الله');
    await tester.enterText(sheetFields.at(2), '33');
    final sheetSave = find.descendant(
      of: find.byType(ZikrFormBottomSheet),
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

class _RecordingCustomRepository implements CustomCategoryRepository {
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
  Future<Result<List<ZikrEntity>>> getZikrsByCategory(
    String categoryKey,
  ) async => const Result.success([]);
}

class _FakeAzkarTasbeehSettingsRepository
    implements AzkarTasbeehSettingsRepository {
  @override
  Future<Result<AzkarTasbeehSettingsEntity>> getAzkarTasbeehSettings() async =>
      Result.success(AzkarTasbeehSettingsEntity(fontSize: 26));

  @override
  Future<Result<void>> updateAzkarTasbeehSettings(
    AzkarTasbeehSettingsEntity settings,
  ) async => const Result.success(null);
}

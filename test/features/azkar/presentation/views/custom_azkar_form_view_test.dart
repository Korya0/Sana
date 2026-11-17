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
import 'package:sana/features/azkar/presentation/widgets/custom_azkar/zikr_form_bottom_sheet.dart';
import 'package:sana/features/azkar/presentation/widgets/common/reading_text_content.dart';

void main() {
  setUp(() {
    sl.registerFactory<CustomAzkarCubit>(_buildCubit);
    sl.registerFactory<AzkarTasbeehSettingsCubit>(
      _buildAzkarTasbeehSettingsCubit,
    );
  });

  tearDown(() async {
    await sl.reset();
  });

  testWidgets(
    'save stays disabled until a name and at least one zikr exist',
    (tester) async {
      await tester.pumpWidget(_app(const CustomAzkarFormView()));

      // Initially the name is empty and there are no azkar.
      expect(_saveButton(tester).onPressed, isNull);

      // A name alone is not enough.
      await tester.enterText(find.byType(TextField).first, 'قسمي');
      await tester.pump();
      expect(_saveButton(tester).onPressed, isNull);

      // Add a zikr through the floating button.
      await tester.tap(find.byIcon(AppIcons.add));
      await tester.pumpAndSettle();

      final sheetFields = find.descendant(
        of: find.byType(ZikrFormBottomSheet),
        matching: find.byType(TextField),
      );
      expect(sheetFields, findsNWidgets(3));

      await tester.enterText(sheetFields.at(0), 'سبحان الله');
      await tester.enterText(sheetFields.at(2), '33');
      await tester.ensureVisible(
        find.widgetWithText(AppPrimaryButton, AppStrings.save),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(AppPrimaryButton, AppStrings.save));
      await tester.pumpAndSettle();

      // Name + one zikr enables save.
      expect(_saveButton(tester).onPressed, isNotNull);
    },
  );

  testWidgets(
    'save stays disabled in edit mode until a value changes',
    (tester) async {
      const category = CustomCategoryEntity(
        id: 'custom_1',
        name: 'قسمي',
        azkar: [
          ZikrEntity(id: 1, text: 'سبحان الله', count: 33, isUserAdded: true),
        ],
      );

      await tester.pumpWidget(
        _app(const CustomAzkarFormView(initialCategory: category)),
      );

      // Nothing changed yet.
      expect(_saveButton(tester).onPressed, isNull);

      // Changing the name enables save.
      await tester.enterText(find.byType(TextField).first, 'قسمي جديد');
      await tester.pump();
      expect(_saveButton(tester).onPressed, isNotNull);

      // Reverting the change disables save again.
      await tester.enterText(find.byType(TextField).first, 'قسمي');
      await tester.pump();
      expect(_saveButton(tester).onPressed, isNull);
    },
  );

  testWidgets('the zikr preview uses the saved font size', (tester) async {
    const category = CustomCategoryEntity(
      id: 'custom_1',
      name: 'قسمي',
      azkar: [
        ZikrEntity(id: 1, text: 'سبحان الله', count: 33, isUserAdded: true),
      ],
    );

    await tester.pumpWidget(
      _app(const CustomAzkarFormView(initialCategory: category)),
    );
    await tester.pumpAndSettle();

    final content = tester.widget<ReadingTextContent>(
      find.byType(ReadingTextContent),
    );
    expect(content.fontSize, 26);
  });
}

Widget _app(Widget home) => MaterialApp(
  theme: AppTheme.light,
  builder: (context, child) {
    AppSize.init(context);
    return Directionality(textDirection: TextDirection.rtl, child: child!);
  },
  home: home,
);

AppTextButton _saveButton(WidgetTester tester) =>
    tester.widget<AppTextButton>(find.byType(AppTextButton));

CustomAzkarCubit _buildCubit() {
  final customRepository = _FakeCustomCategoryRepository();
  final azkarRepository = _FakeAzkarRepository();

  return CustomAzkarCubit(
    getCustomCategoriesUseCase: GetCustomCategoriesUseCase(customRepository),
    saveCustomCategoryUseCase: SaveCustomCategoryUseCase(customRepository),
    deleteCustomCategoryUseCase: DeleteCustomCategoryUseCase(customRepository),
    getAzkarCategoriesUseCase: GetAzkarCategoriesUseCase(azkarRepository),
  );
}

AzkarTasbeehSettingsCubit _buildAzkarTasbeehSettingsCubit() {
  final repository = _FakeAzkarTasbeehSettingsRepository();
  return AzkarTasbeehSettingsCubit(
    GetAzkarTasbeehSettingsUseCase(repository),
    UpdateAzkarTasbeehSettingsUseCase(repository),
  );
}

class _FakeAzkarRepository implements AzkarRepository {
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

class _FakeCustomCategoryRepository implements CustomCategoryRepository {
  List<CustomCategoryEntity> categories = [];

  @override
  Future<Result<void>> deleteCustomCategory(String id) async {
    categories = categories.where((c) => c.id != id).toList();
    return const Result.success(null);
  }

  @override
  Future<Result<CustomCategoryEntity?>> getCustomCategoryById(String id) async {
    for (final category in categories) {
      if (category.id == id) return Result.success(category);
    }
    return const Result.success(null);
  }

  @override
  Future<Result<List<CustomCategoryEntity>>> getCustomCategories() async =>
      Result.success(categories);

  @override
  Future<Result<void>> saveCustomCategory(
    CustomCategoryEntity category,
  ) async {
    categories = [
      ...categories.where((c) => c.id != category.id),
      category,
    ];
    return const Result.success(null);
  }
}

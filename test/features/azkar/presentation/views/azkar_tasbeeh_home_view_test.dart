import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/di/app_injector.dart';
import 'package:sana/core/error/result.dart';
import 'package:sana/core/theme/app_theme.dart';
import 'package:sana/core/theme/icons/app_icons.dart';
import 'package:sana/features/azkar/domain/entities/azkar_category_entity.dart';
import 'package:sana/features/azkar/domain/entities/custom_category_entity.dart';
import 'package:sana/features/azkar/domain/entities/reading_settings_entity.dart';
import 'package:sana/features/azkar/domain/entities/tasbeeh_item_entity.dart';
import 'package:sana/features/azkar/domain/entities/zikr_entity.dart';
import 'package:sana/features/azkar/domain/repositories/azkar_repository.dart';
import 'package:sana/features/azkar/domain/repositories/custom_azkar_repository.dart';
import 'package:sana/features/azkar/domain/repositories/reading_settings_repository.dart';
import 'package:sana/features/azkar/domain/repositories/tasbeeh_repository.dart';
import 'package:sana/features/azkar/domain/use_cases/delete_custom_category_use_case.dart';
import 'package:sana/features/azkar/domain/use_cases/delete_tasbeeh_item_use_case.dart';
import 'package:sana/features/azkar/domain/use_cases/get_azkar_categories_use_case.dart';
import 'package:sana/features/azkar/domain/use_cases/get_custom_categories_use_case.dart';
import 'package:sana/features/azkar/domain/use_cases/get_reading_settings_use_case.dart';
import 'package:sana/features/azkar/domain/use_cases/get_tasbeeh_items_use_case.dart';
import 'package:sana/features/azkar/domain/use_cases/save_custom_category_use_case.dart';
import 'package:sana/features/azkar/domain/use_cases/save_tasbeeh_item_use_case.dart';
import 'package:sana/features/azkar/domain/use_cases/update_reading_settings_use_case.dart';
import 'package:sana/features/azkar/presentation/cubits/categories/azkar_categories_cubit.dart';
import 'package:sana/features/azkar/presentation/cubits/custom_azkar/custom_azkar_cubit.dart';
import 'package:sana/features/azkar/presentation/cubits/reading_settings/reading_settings_cubit.dart';
import 'package:sana/features/azkar/presentation/cubits/tasbeeh/tasbeeh_cubit.dart';
import 'package:sana/features/azkar/presentation/views/azkar_tasbeeh_home_view.dart';
import 'package:sana/features/azkar/presentation/widgets/azkar_section/azkar_home_options_bottom_sheet.dart';
import 'package:sana/features/azkar/presentation/widgets/azkar_categories/azkar_category_card.dart';
import 'package:sana/features/azkar/presentation/widgets/tasbeeh/tasbeeh_preset_grid.dart';

void main() {
  setUp(() {
    sl.registerFactory<AzkarCategoriesCubit>(_categoriesCubit);
    sl.registerFactory<CustomAzkarCubit>(_customAzkarCubit);
    sl.registerFactory<ReadingSettingsCubit>(_settingsCubit);
    sl.registerFactory<TasbeehCubit>(_tasbeehCubit);
  });

  tearDown(() async => sl.reset());

  testWidgets('renders the header and the category cards', (tester) async {
    await _pump(tester);

    expect(find.text(AppStrings.azkarTasbeehHeader), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('الصباح'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.byType(AzkarCategoryCard), findsNWidgets(2));
    expect(find.text('الصباح'), findsOneWidget);
    expect(find.text('المساء'), findsOneWidget);
  });

  testWidgets('opens the options sheet from the app bar', (tester) async {
    await _pump(tester);

    await tester.tap(find.byIcon(AppIcons.tuning));
    await tester.pumpAndSettle();

    expect(find.byType(AzkarHomeOptionsBottomSheet), findsOneWidget);
  });

  testWidgets('keeps the spacing below the tasbeeh card title', (tester) async {
    await _pump(tester);

    final titleBottom = tester.getBottomLeft(
      find.text(AppStrings.tasbeehTitle),
    );
    final gridTop = tester.getTopLeft(find.byType(TasbeehPresetGrid));

    expect(gridTop.dy - titleBottom.dy, closeTo(AppSize.p4, 1));
  });
}

Future<void> _pump(WidgetTester tester) async {
  await tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.light,
      builder: (context, child) {
        AppSize.init(context);
        return Directionality(textDirection: TextDirection.rtl, child: child!);
      },
      home: const AzkarTasbeehHomeView(),
    ),
  );
  await tester.pumpAndSettle();
}

AzkarCategoriesCubit _categoriesCubit() => AzkarCategoriesCubit(
  GetAzkarCategoriesUseCase(
    _FakeAzkarRepository(
      _FakeAzkarRepository.defaultCategories,
    ),
  ),
  GetCustomCategoriesUseCase(_FakeCustomAzkarRepository()),
);

CustomAzkarCubit _customAzkarCubit() {
  final repository = _FakeCustomAzkarRepository();

  return CustomAzkarCubit(
    getCustomCategoriesUseCase: GetCustomCategoriesUseCase(repository),
    saveCustomCategoryUseCase: SaveCustomCategoryUseCase(repository),
    deleteCustomCategoryUseCase: DeleteCustomCategoryUseCase(repository),
    getAzkarCategoriesUseCase: GetAzkarCategoriesUseCase(
      const _EmptyAzkarRepository(),
    ),
  );
}

ReadingSettingsCubit _settingsCubit() {
  final repository = _FakeReadingSettingsRepository();

  return ReadingSettingsCubit(
    GetReadingSettingsUseCase(repository),
    UpdateReadingSettingsUseCase(repository),
  );
}

TasbeehCubit _tasbeehCubit() {
  final repository = _FakeTasbeehRepository();
  return TasbeehCubit(
    GetTasbeehItemsUseCase(repository),
    SaveTasbeehItemUseCase(repository),
    DeleteTasbeehItemUseCase(repository),
  );
}

const _categories = [
  AzkarCategoryEntity(
    key: 'morning',
    title: 'أذكار الصباح',
    cardTitle: 'الصباح',
  ),
  AzkarCategoryEntity(
    key: 'evening',
    title: 'أذكار المساء',
    cardTitle: 'المساء',
  ),
];

class _FakeAzkarRepository implements AzkarRepository {
  _FakeAzkarRepository(this.categories);

  static const List<AzkarCategoryEntity> defaultCategories = _categories;

  final List<AzkarCategoryEntity> categories;

  @override
  Future<Result<List<AzkarCategoryEntity>>> getCategories() async =>
      Result.success(categories);

  @override
  Future<Result<List<ZikrEntity>>> getAzkarByCategory(
    String categoryKey,
  ) async =>
      const Result.success([ZikrEntity(id: 1, text: 'سبحان الله', count: 33)]);
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

class _FakeCustomAzkarRepository implements CustomAzkarRepository {
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

  @override
  Future<Result<void>> saveCustomCategory(
    CustomCategoryEntity category,
  ) async => const Result.success(null);
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

class _FakeTasbeehRepository implements TasbeehRepository {
  @override
  Future<Result<void>> deleteItem(String id) async =>
      const Result.success(null);

  @override
  Future<Result<List<TasbeehItemEntity>>> getItems() async =>
      const Result.success([]);

  @override
  Future<Result<void>> saveItem(TasbeehItemEntity item) async =>
      const Result.success(null);
}

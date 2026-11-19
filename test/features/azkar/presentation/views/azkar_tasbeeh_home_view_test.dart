import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/di/app_injector.dart';
import 'package:sana/core/error/result.dart';
import 'package:sana/core/theme/app_theme.dart';
import 'package:sana/core/theme/icons/app_icons.dart';
import 'package:sana/core/widgets/headers/app_section_header.dart';
import 'package:sana/features/azkar/domain/entities/azkar_category_entity.dart';
import 'package:sana/features/azkar/domain/entities/azkar_tasbeeh_settings_entity.dart';
import 'package:sana/features/azkar/domain/entities/custom_category_entity.dart';
import 'package:sana/features/azkar/domain/entities/tasbeeh_item_entity.dart';
import 'package:sana/features/azkar/domain/entities/zikr_entity.dart';
import 'package:sana/features/azkar/domain/repositories/azkar_repository.dart';
import 'package:sana/features/azkar/domain/repositories/azkar_tasbeeh_settings_repository.dart';
import 'package:sana/features/azkar/domain/repositories/custom_category_repository.dart';
import 'package:sana/features/azkar/domain/repositories/tasbeeh_repository.dart';
import 'package:sana/features/azkar/domain/use_cases/delete_custom_category_use_case.dart';
import 'package:sana/features/azkar/domain/use_cases/delete_tasbeeh_item_use_case.dart';
import 'package:sana/features/azkar/domain/use_cases/get_azkar_categories_use_case.dart';
import 'package:sana/features/azkar/domain/use_cases/get_azkar_tasbeeh_settings_use_case.dart';
import 'package:sana/features/azkar/domain/use_cases/get_custom_categories_use_case.dart';
import 'package:sana/features/azkar/domain/use_cases/get_tasbeeh_items_use_case.dart';
import 'package:sana/features/azkar/domain/use_cases/get_zikrs_by_category_use_case.dart';
import 'package:sana/features/azkar/domain/use_cases/save_custom_category_use_case.dart';
import 'package:sana/features/azkar/domain/use_cases/save_tasbeeh_item_use_case.dart';
import 'package:sana/features/azkar/domain/use_cases/update_azkar_tasbeeh_settings_use_case.dart';
import 'package:sana/features/azkar/presentation/cubits/azkar_tasbeeh_settings/azkar_tasbeeh_settings_cubit.dart';
import 'package:sana/features/azkar/presentation/cubits/categories/azkar_categories_cubit.dart';
import 'package:sana/features/azkar/presentation/cubits/custom_azkar/custom_azkar_cubit.dart';
import 'package:sana/features/azkar/presentation/cubits/tasbeeh/tasbeeh_cubit.dart';
import 'package:sana/features/azkar/presentation/views/azkar_tasbeeh_home_view.dart';
import 'package:sana/features/azkar/presentation/widgets/azkar_tasbeeh_home/azkar/azkar_category_card.dart';
import 'package:sana/features/azkar/presentation/widgets/azkar_tasbeeh_home/azkar/azkar_home_options_bottom_sheet.dart';
import 'package:sana/features/azkar/presentation/widgets/azkar_tasbeeh_home/tasbeeh/tasbeeh_home_card.dart';

void main() {
  setUp(() {
    sl.registerFactory<AzkarCategoriesCubit>(_categoriesCubit);
    sl.registerFactory<CustomAzkarCubit>(_customAzkarCubit);
    sl.registerFactory<AzkarTasbeehSettingsCubit>(_settingsCubit);
    sl.registerFactory<TasbeehCubit>(_tasbeehCubit);
  });

  tearDown(() async => sl.reset());

  testWidgets('renders the header and the category cards', (tester) async {
    await _pump(tester);

    expect(find.text(AppStrings.azkarHeader), findsOneWidget);
    // Tab roots never show a back arrow.
    expect(find.byIcon(AppIcons.back), findsNothing);
    expect(find.byType(AzkarCategoryCard), findsNWidgets(2));
    // A moving label draws two copies of its text.
    expect(find.text('الصباح'), findsWidgets);
    expect(find.text('المساء'), findsWidgets);
  });

  testWidgets('opens the options sheet from the section header', (
    tester,
  ) async {
    await _pump(tester);

    await tester.tap(find.byIcon(AppIcons.tuning));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.byType(AzkarHomeOptionsBottomSheet), findsOneWidget);
    expect(find.text(AppStrings.manageCustomAzkar), findsOneWidget);
  });

  testWidgets('renders the tasbeeh content without title', (tester) async {
    await _pump(tester);

    expect(find.byType(TasbeehHomeCard), findsOneWidget);
    expect(find.text(AppStrings.tasbeehTitle), findsNothing);
    expect(find.text(AppStrings.chooseOrAddCustomTasbeeh), findsOneWidget);
  });

  testWidgets('places the tasbeeh section above the azkar categories', (
    tester,
  ) async {
    await _pump(tester);

    final header = find.byType(AppSectionHeader);
    final tasbeeh = find.byType(TasbeehHomeCard);

    expect(
      tester.getBottomLeft(tasbeeh).dy,
      lessThan(tester.getTopLeft(header).dy),
    );
    expect(
      tester.getTopLeft(header).dy - tester.getBottomLeft(tasbeeh).dy,
      closeTo(AppSize.p12, 1),
    );
  });
}

Future<void> _pump(WidgetTester tester) async {
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
      home: const AzkarTasbeehHomeView(),
    ),
  );
  // A moving label never settles, so pump a bounded amount instead.
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 100));
}

AzkarCategoriesCubit _categoriesCubit() => AzkarCategoriesCubit(
  GetAzkarCategoriesUseCase(
    _FakeAzkarRepository(
      _FakeAzkarRepository.defaultCategories,
    ),
  ),
  GetCustomCategoriesUseCase(_FakeCustomCategoryRepository()),
  GetZikrsByCategoryUseCase(_FakeAzkarRepository(const [])),
);

CustomAzkarCubit _customAzkarCubit() {
  final repository = _FakeCustomCategoryRepository();

  return CustomAzkarCubit(
    getCustomCategoriesUseCase: GetCustomCategoriesUseCase(repository),
    saveCustomCategoryUseCase: SaveCustomCategoryUseCase(repository),
    deleteCustomCategoryUseCase: DeleteCustomCategoryUseCase(repository),
    getAzkarCategoriesUseCase: GetAzkarCategoriesUseCase(
      const _EmptyAzkarRepository(),
    ),
  );
}

AzkarTasbeehSettingsCubit _settingsCubit() {
  final repository = _FakeAzkarTasbeehSettingsRepository();

  return AzkarTasbeehSettingsCubit(
    GetAzkarTasbeehSettingsUseCase(repository),
    UpdateAzkarTasbeehSettingsUseCase(repository),
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
  Future<Result<List<ZikrEntity>>> getZikrsByCategory(
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
  Future<Result<List<ZikrEntity>>> getZikrsByCategory(
    String categoryKey,
  ) async => const Result.success([]);
}

class _FakeCustomCategoryRepository implements CustomCategoryRepository {
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

class _FakeAzkarTasbeehSettingsRepository
    implements AzkarTasbeehSettingsRepository {
  @override
  Future<Result<AzkarTasbeehSettingsEntity>> getAzkarTasbeehSettings() async =>
      Result.success(AzkarTasbeehSettingsEntity(fontSize: 20));

  @override
  Future<Result<void>> updateAzkarTasbeehSettings(
    AzkarTasbeehSettingsEntity settings,
  ) async => const Result.success(null);
}

class _FakeTasbeehRepository implements TasbeehRepository {
  @override
  Future<Result<void>> deleteTasbeehItem(String id) async =>
      const Result.success(null);

  @override
  Future<Result<List<TasbeehItemEntity>>> getTasbeehItems() async =>
      const Result.success([]);

  @override
  Future<Result<void>> saveTasbeehItem(TasbeehItemEntity item) async =>
      const Result.success(null);
}

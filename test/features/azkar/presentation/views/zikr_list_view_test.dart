import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/di/app_injector.dart';
import 'package:sana/core/error/result.dart';
import 'package:sana/core/theme/app_theme.dart';
import 'package:sana/features/azkar/domain/entities/azkar_category_entity.dart';
import 'package:sana/features/azkar/domain/entities/custom_category_entity.dart';
import 'package:sana/features/azkar/domain/entities/azkar_tasbeeh_settings_entity.dart';
import 'package:sana/features/azkar/domain/entities/zikr_entity.dart';
import 'package:sana/features/azkar/domain/repositories/azkar_repository.dart';
import 'package:sana/features/azkar/domain/repositories/custom_category_repository.dart';
import 'package:sana/features/azkar/domain/repositories/azkar_tasbeeh_settings_repository.dart';
import 'package:sana/features/azkar/domain/use_cases/delete_custom_category_use_case.dart';
import 'package:sana/features/azkar/domain/use_cases/get_zikrs_by_category_use_case.dart';
import 'package:sana/features/azkar/domain/use_cases/get_azkar_categories_use_case.dart';
import 'package:sana/features/azkar/domain/use_cases/get_azkar_tasbeeh_settings_use_case.dart';
import 'package:sana/features/azkar/domain/use_cases/update_azkar_tasbeeh_settings_use_case.dart';
import 'package:sana/features/azkar/presentation/cubits/azkar/azkar_cubit.dart';
import 'package:sana/features/azkar/presentation/cubits/azkar_tasbeeh_settings/azkar_tasbeeh_settings_cubit.dart';
import 'package:sana/features/azkar/presentation/views/zikr_list_view.dart';
import 'package:sana/features/azkar/presentation/widgets/zikr_list/zikr_card/zikr_item_card.dart';

void main() {
  setUp(() {
    sl.registerFactory<AzkarCubit>(_azkarCubit);
    sl.registerFactory<AzkarTasbeehSettingsCubit>(_settingsCubit);
  });

  tearDown(() async => sl.reset());

  testWidgets('renders the category title and its azkar', (tester) async {
    await _pump(tester);
    await tester.pumpAndSettle();

    expect(find.text('أذكار الصباح'), findsOneWidget);
    expect(find.byType(ZikrItemCard), findsNWidgets(2));
    expect(find.text('سبحان الله'), findsOneWidget);
    expect(find.text('الحمد لله'), findsOneWidget);
  });
}

Future<void> _pump(WidgetTester tester) => tester.pumpWidget(
  MaterialApp(
    theme: AppTheme.light,
    builder: (context, child) {
      AppSize.init(context);
      return Directionality(textDirection: TextDirection.rtl, child: child!);
    },
    home: const ZikrListView(
      categoryKey: 'morning',
      categoryTitle: 'أذكار الصباح',
    ),
  ),
);

AzkarCubit _azkarCubit() {
  const repository = _FakeAzkarRepository();
  final customRepository = _FakeCustomCategoryRepository();

  return AzkarCubit(
    GetZikrsByCategoryUseCase(repository),
    GetAzkarCategoriesUseCase(repository),
    DeleteCustomCategoryUseCase(customRepository),
    customRepository,
  );
}

AzkarTasbeehSettingsCubit _settingsCubit() {
  final repository = _FakeAzkarTasbeehSettingsRepository();

  return AzkarTasbeehSettingsCubit(
    GetAzkarTasbeehSettingsUseCase(repository),
    UpdateAzkarTasbeehSettingsUseCase(repository),
  );
}

class _FakeAzkarRepository implements AzkarRepository {
  const _FakeAzkarRepository();

  @override
  Future<Result<List<AzkarCategoryEntity>>> getCategories() async =>
      const Result.success([
        AzkarCategoryEntity(
          key: 'morning',
          title: 'أذكار الصباح',
          cardTitle: 'الصباح',
        ),
      ]);

  @override
  Future<Result<List<ZikrEntity>>> getZikrsByCategory(
    String categoryKey,
  ) async => const Result.success([
    ZikrEntity(id: 1, text: 'سبحان الله', count: 33),
    ZikrEntity(id: 2, text: 'الحمد لله', count: 33),
  ]);
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

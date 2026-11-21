import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/error/result.dart';
import 'package:sana/core/router/app_routes.dart';
import 'package:sana/core/theme/app_theme.dart';
import 'package:sana/features/azkar/domain/entities/azkar_category_entity.dart';
import 'package:sana/features/azkar/domain/entities/custom_category_entity.dart';
import 'package:sana/features/azkar/domain/entities/zikr_entity.dart';
import 'package:sana/features/azkar/domain/repositories/azkar_repository.dart';
import 'package:sana/features/azkar/domain/repositories/custom_category_repository.dart';
import 'package:sana/features/azkar/domain/use_cases/get_azkar_categories_use_case.dart';
import 'package:sana/features/azkar/domain/use_cases/get_custom_categories_use_case.dart';
import 'package:sana/features/azkar/domain/use_cases/get_zikrs_by_category_use_case.dart';
import 'package:sana/features/azkar/presentation/cubits/azkar_tasbeeh_settings/azkar_tasbeeh_settings_cubit.dart';
import 'package:sana/features/azkar/presentation/cubits/categories/azkar_categories_cubit.dart';
import 'package:sana/features/azkar/presentation/utils/azkar_home_options_flow.dart';

import '../widgets/azkar_widget_test_harness.dart';

void main() {
  group('AzkarHomeOptionsFlow', () {
    testWidgets('does nothing when the options sheet is dismissed', (
      tester,
    ) async {
      final settingsCubit = await createLoadedSettingsCubit();
      final categoriesCubit = _spyCategoriesCubit();

      await _pumpApp(
        tester,
        settingsCubit: settingsCubit,
        categoriesCubit: categoriesCubit,
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      await tester.tapAt(const Offset(10, 10));
      await tester.pumpAndSettle();

      expect(categoriesCubit.loadCount, 0);
      addTearDown(categoriesCubit.close);
    });

    testWidgets('opens manage custom azkar and reloads categories after return', (
      tester,
    ) async {
      final settingsCubit = await createLoadedSettingsCubit();
      final categoriesCubit = _spyCategoriesCubit();

      await _pumpApp(
        tester,
        settingsCubit: settingsCubit,
        categoriesCubit: categoriesCubit,
        withCustomAzkarRoute: true,
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      await tester.tap(find.text(AppStrings.manageCustomAzkar));
      await tester.pumpAndSettle();

      expect(find.text('custom-azkar-page'), findsOneWidget);

      await tester.tap(find.text('back'));
      await tester.pumpAndSettle();

      expect(categoriesCubit.loadCount, 1);
      addTearDown(categoriesCubit.close);
    });

    testWidgets('opens font size settings and reopens options on go back', (
      tester,
    ) async {
      final settingsCubit = await createLoadedSettingsCubit();
      final categoriesCubit = _spyCategoriesCubit();

      await _pumpApp(
        tester,
        settingsCubit: settingsCubit,
        categoriesCubit: categoriesCubit,
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      expect(find.text(AppStrings.azkarOptions), findsOneWidget);

      await tester.tap(find.text(AppStrings.fontSize));
      await tester.pumpAndSettle();

      // Settings sheet is shown with a back button instead of a close button.
      expect(find.byTooltip(AppStrings.back), findsOneWidget);
      expect(find.text(AppStrings.azkarOptions), findsNothing);

      await tester.tap(find.byTooltip(AppStrings.back));
      await tester.pumpAndSettle();

      // Going back reopens the original options sheet, without reloading
      // categories (which only happens after managing custom azkar).
      expect(find.text(AppStrings.azkarOptions), findsOneWidget);
      expect(find.text(AppStrings.fontSize), findsOneWidget);
      expect(categoriesCubit.loadCount, 0);
      addTearDown(categoriesCubit.close);
    });
  });
}

Future<void> _pumpApp(
  WidgetTester tester, {
  required AzkarTasbeehSettingsCubit settingsCubit,
  required AzkarCategoriesCubit categoriesCubit,
  bool withCustomAzkarRoute = false,
}) async {
  final router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => Scaffold(
          body: MultiBlocProvider(
            providers: [
              BlocProvider<AzkarTasbeehSettingsCubit>.value(
                value: settingsCubit,
              ),
              BlocProvider<AzkarCategoriesCubit>.value(value: categoriesCubit),
            ],
            child: Builder(
              builder: (context) => Center(
                child: TextButton(
                  onPressed: () => AzkarHomeOptionsFlow.open(context),
                  child: const Text('open'),
                ),
              ),
            ),
          ),
        ),
      ),
      if (withCustomAzkarRoute)
        GoRoute(
          path: AppRoutes.customAzkarView,
          name: AppRoutes.customAzkarView,
          builder: (context, state) => Scaffold(
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('custom-azkar-page'),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('back'),
                  ),
                ],
              ),
            ),
          ),
        ),
    ],
  );
  addTearDown(router.dispose);

  await tester.pumpWidget(
    MaterialApp.router(
      routerConfig: router,
      theme: AppTheme.light,
      builder: (context, child) {
        AppSize.init(context);
        return Directionality(textDirection: TextDirection.rtl, child: child!);
      },
    ),
  );
  await tester.pumpAndSettle();
}

__SpyAzkarCategoriesCubit _spyCategoriesCubit() {
  final azkarRepo = _FakeAzkarRepository();
  return __SpyAzkarCategoriesCubit(
    GetAzkarCategoriesUseCase(azkarRepo),
    GetCustomCategoriesUseCase(_FakeCustomCategoryRepository()),
    GetZikrsByCategoryUseCase(azkarRepo),
  );
}

class __SpyAzkarCategoriesCubit extends AzkarCategoriesCubit {
  __SpyAzkarCategoriesCubit(
    super.getCategories,
    super.getCustom,
    super.getAzkar,
  );

  int loadCount = 0;

  @override
  Future<void> loadCategories() async {
    loadCount++;
    await super.loadCategories();
  }
}

class _FakeAzkarRepository implements AzkarRepository {
  @override
  Future<Result<List<AzkarCategoryEntity>>> getCategories() async =>
      const Result.success([]);

  @override
  Future<Result<List<ZikrEntity>>> getZikrsByCategory(String categoryKey) async =>
      const Result.success([]);
}

class _FakeCustomCategoryRepository implements CustomCategoryRepository {
  @override
  Future<Result<void>> deleteCustomCategory(String id) async =>
      const Result.success(null);

  @override
  Future<Result<CustomCategoryEntity?>> getCustomCategoryById(String id) async =>
      const Result.success(null);

  @override
  Future<Result<List<CustomCategoryEntity>>> getCustomCategories() async =>
      const Result.success([]);

  @override
  Future<Result<void>> saveCustomCategory(CustomCategoryEntity category) async =>
      const Result.success(null);
}


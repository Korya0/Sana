import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/error/failure.dart';
import 'package:sana/core/error/result.dart';
import 'package:sana/core/router/app_routes.dart';
import 'package:sana/core/theme/app_theme.dart';
import 'package:sana/core/widgets/buttons/app_primary_button.dart';
import 'package:sana/core/widgets/buttons/app_secondary_button.dart';
import 'package:sana/features/azkar/domain/entities/azkar_category_entity.dart';
import 'package:sana/features/azkar/domain/entities/custom_category_entity.dart';
import 'package:sana/features/azkar/domain/entities/zikr_entity.dart';
import 'package:sana/features/azkar/domain/repositories/azkar_repository.dart';
import 'package:sana/features/azkar/domain/repositories/custom_category_repository.dart';
import 'package:sana/features/azkar/domain/use_cases/delete_custom_category_use_case.dart';
import 'package:sana/features/azkar/domain/use_cases/get_azkar_categories_use_case.dart';
import 'package:sana/features/azkar/domain/use_cases/get_custom_categories_use_case.dart';
import 'package:sana/features/azkar/domain/use_cases/get_zikrs_by_category_use_case.dart';
import 'package:sana/features/azkar/domain/use_cases/save_custom_category_use_case.dart';
import 'package:sana/features/azkar/presentation/cubits/azkar_tasbeeh_settings/azkar_tasbeeh_settings_cubit.dart';
import 'package:sana/features/azkar/presentation/cubits/categories/azkar_categories_cubit.dart';
import 'package:sana/features/azkar/presentation/cubits/custom_azkar/custom_azkar_cubit.dart';
import 'package:sana/features/azkar/presentation/widgets/azkar_tasbeeh_home/azkar/azkar_categories_grid.dart';
import 'package:sana/features/azkar/presentation/widgets/azkar_tasbeeh_home/azkar/azkar_category_card.dart';
import 'package:toastification/toastification.dart';

import 'azkar_widget_test_harness.dart';

void main() {
  group('AzkarCategoriesGrid interactions', () {
    testWidgets('tapping a category pushes the zikr list and reloads categories', (
      tester,
    ) async {
      final h = await _pumpGrid(tester);

      await tester.tap(find.byType(AzkarCategoryCard).at(0));
      await tester.pumpAndSettle();

      expect(find.text('zikr-list:morning'), findsOneWidget);
      expect(h.pushedKey, 'morning');
      expect(h.pushedExtra, 'أذكار الصباح');
      // The reload happens once the pushed route returns.
      expect(h.categoriesCubit.loadCount, 0);

      await tester.tap(find.text('back-from-zikr'));
      await tester.pumpAndSettle();

      expect(h.categoriesCubit.loadCount, 1);
    });

    testWidgets('dismissing the actions sheet does nothing', (tester) async {
      final h = await _pumpGrid(tester);

      await tester.longPress(find.byType(AzkarCategoryCard).at(1));
      await tester.pumpAndSettle();
      expect(find.text(AppStrings.azkarOptions), findsOneWidget);

      await tester.tapAt(const Offset(5, 5));
      await tester.pumpAndSettle();

      expect(h.customRepo.deletedIds, isEmpty);
      expect(h.categoriesCubit.loadCount, 0);
    });

    testWidgets('edit loads the category azkar, opens the form and reloads on save', (
      tester,
    ) async {
      final h = await _pumpGrid(
        tester,
        editAzkarResult: const Result.success([
          ZikrEntity(id: 7, text: 'سبحان الله', count: 33),
        ]),
        formResult: const CustomCategoryEntity(
          id: 'morning',
          name: 'أذكار الصباح',
          azkar: [],
        ),
      );

      await tester.longPress(find.byType(AzkarCategoryCard).at(0));
      await tester.pumpAndSettle();
      await tester.tap(find.text(AppStrings.editZikr));
      await tester.pumpAndSettle();

      expect(find.text('form-page'), findsOneWidget);
      expect(h.azkarRepo.zikrsCalls, 1);
      expect(h.formInitial?.id, 'morning');
      expect(h.formInitial?.name, 'أذكار الصباح');
      expect(h.formInitial?.azkar.single.text, 'سبحان الله');

      await tester.tap(find.text('return-from-form'));
      await tester.pumpAndSettle();

      expect(h.categoriesCubit.loadCount, 1);
    });

    testWidgets('edit does not reload when the form is cancelled', (tester) async {
      final h = await _pumpGrid(tester, formResult: null);

      await tester.longPress(find.byType(AzkarCategoryCard).at(0));
      await tester.pumpAndSettle();
      await tester.tap(find.text(AppStrings.editZikr));
      await tester.pumpAndSettle();
      await tester.tap(find.text('return-from-form'));
      await tester.pumpAndSettle();

      expect(h.categoriesCubit.loadCount, 0);
    });

    testWidgets('edit shows a toast and skips the form when loading fails', (
      tester,
    ) async {
      final h = await _pumpGrid(
        tester,
        editAzkarResult: const Result.failure(
          CacheFailure(message: 'تعذّر تحميل الأذكار'),
        ),
      );

      await tester.longPress(find.byType(AzkarCategoryCard).at(0));
      await tester.pumpAndSettle();
      await tester.tap(find.text(AppStrings.editZikr));
      await tester.pumpAndSettle();

      expect(h.azkarRepo.zikrsCalls, 1);
      expect(find.text('form-page'), findsNothing);
      expect(find.text('تعذّر تحميل الأذكار'), findsOneWidget);
      await tester.pump(const Duration(seconds: 3));
    });

    testWidgets('restore removes the override and reloads on success', (
      tester,
    ) async {
      final h = await _pumpGrid(tester);

      await tester.longPress(find.byType(AzkarCategoryCard).at(2));
      await tester.pumpAndSettle();
      expect(find.text(AppStrings.restoreOriginal), findsOneWidget);
      expect(find.text(AppStrings.deleteZikr), findsNothing);

      await tester.tap(find.text(AppStrings.restoreOriginal));
      await tester.pumpAndSettle();
      expect(find.text(AppStrings.restoreCategoryDialogTitle), findsOneWidget);

      await tester.tap(
        find.widgetWithText(AppPrimaryButton, AppStrings.restoreOriginal),
      );
      await tester.pumpAndSettle();

      expect(h.customRepo.deletedIds, ['evening']);
      expect(h.categoriesCubit.loadCount, 1);
    });

    testWidgets('delete removes a custom category and reloads on success', (
      tester,
    ) async {
      final h = await _pumpGrid(tester);

      await tester.longPress(find.byType(AzkarCategoryCard).at(1));
      await tester.pumpAndSettle();
      expect(find.text(AppStrings.deleteZikr), findsOneWidget);
      expect(find.text(AppStrings.restoreOriginal), findsNothing);

      await tester.tap(find.text(AppStrings.deleteZikr));
      await tester.pumpAndSettle();
      expect(find.text(AppStrings.deleteCustomAzkarDialogTitle), findsOneWidget);

      await tester.tap(
        find.widgetWithText(AppPrimaryButton, AppStrings.delete),
      );
      await tester.pumpAndSettle();

      expect(h.customRepo.deletedIds, ['custom_1']);
      expect(h.categoriesCubit.loadCount, 1);
      expect(find.text(AppStrings.customAzkarDeletedSuccess), findsOneWidget);
      await tester.pump(const Duration(seconds: 3));
    });

    testWidgets('cancelling the delete dialog leaves the category untouched', (
      tester,
    ) async {
      final h = await _pumpGrid(tester);

      await tester.longPress(find.byType(AzkarCategoryCard).at(1));
      await tester.pumpAndSettle();
      await tester.tap(find.text(AppStrings.deleteZikr));
      await tester.pumpAndSettle();

      await tester.tap(
        find.widgetWithText(AppSecondaryButton, AppStrings.cancel),
      );
      await tester.pumpAndSettle();

      expect(h.customRepo.deletedIds, isEmpty);
      expect(h.categoriesCubit.loadCount, 0);
    });

    testWidgets('a failed delete shows an error toast and does not reload', (
      tester,
    ) async {
      final h = await _pumpGrid(
        tester,
        deleteResult: const Result.failure(
          CacheFailure(message: 'تعذّر الحذف'),
        ),
      );

      await tester.longPress(find.byType(AzkarCategoryCard).at(1));
      await tester.pumpAndSettle();
      await tester.tap(find.text(AppStrings.deleteZikr));
      await tester.pumpAndSettle();
      await tester.tap(
        find.widgetWithText(AppPrimaryButton, AppStrings.delete),
      );
      await tester.pumpAndSettle();

      expect(h.customRepo.deletedIds, ['custom_1']);
      expect(h.categoriesCubit.loadCount, 0);
      expect(find.text('تعذّر الحذف'), findsOneWidget);
      await tester.pump(const Duration(seconds: 3));
    });
  });
}

const _categories = [
  AzkarCategoryEntity(
    key: 'morning',
    title: 'أذكار الصباح',
    cardTitle: 'الصباح',
  ),
  AzkarCategoryEntity(
    key: 'custom_1',
    title: 'مخصصة',
    cardTitle: 'مخصصة',
    isCustom: true,
  ),
  AzkarCategoryEntity(
    key: 'evening',
    title: 'أذكار المساء',
    cardTitle: 'المساء',
    isModified: true,
  ),
];

class _Harness {
  _Harness({
    required this.categoriesCubit,
    required this.customRepo,
    required this.azkarRepo,
  });

  final _SpyCategoriesCubit categoriesCubit;
  final _FakeCustomCategoryRepository customRepo;
  final _FakeAzkarRepository azkarRepo;

  CustomCategoryEntity? formInitial;
  String? pushedKey;
  Object? pushedExtra;
}

Future<_Harness> _pumpGrid(
  WidgetTester tester, {
  List<AzkarCategoryEntity> categories = _categories,
  Result<List<ZikrEntity>>? editAzkarResult,
  Result<void>? deleteResult,
  CustomCategoryEntity? formResult,
}) async {
  tester.view.physicalSize = const Size(400, 900);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  final azkarRepo = _FakeAzkarRepository(zikrsResult: editAzkarResult);
  final customRepo = _FakeCustomCategoryRepository(deleteResult: deleteResult);
  final categoriesCubit = _SpyCategoriesCubit(
    GetAzkarCategoriesUseCase(azkarRepo),
    GetCustomCategoriesUseCase(customRepo),
    GetZikrsByCategoryUseCase(azkarRepo),
  );
  final customCubit = CustomAzkarCubit(
    getCustomCategoriesUseCase: GetCustomCategoriesUseCase(customRepo),
    saveCustomCategoryUseCase: SaveCustomCategoryUseCase(customRepo),
    deleteCustomCategoryUseCase: DeleteCustomCategoryUseCase(customRepo),
    getAzkarCategoriesUseCase: GetAzkarCategoriesUseCase(azkarRepo),
  );
  final settingsCubit = await createLoadedSettingsCubit();
  addTearDown(categoriesCubit.close);
  addTearDown(customCubit.close);

  final h = _Harness(
    categoriesCubit: categoriesCubit,
    customRepo: customRepo,
    azkarRepo: azkarRepo,
  );

  final router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => Scaffold(
          body: MultiBlocProvider(
            providers: [
              BlocProvider<AzkarCategoriesCubit>.value(value: categoriesCubit),
              BlocProvider<CustomAzkarCubit>.value(value: customCubit),
              BlocProvider<AzkarTasbeehSettingsCubit>.value(
                value: settingsCubit,
              ),
            ],
            child: CustomScrollView(
              slivers: [AzkarCategoriesGrid(categories: categories)],
            ),
          ),
        ),
      ),
      GoRoute(
        path: AppRoutes.zikrListView,
        name: AppRoutes.zikrListView,
        builder: (context, state) {
          h.pushedKey = state.pathParameters[AppRoutes.categoryParam];
          h.pushedExtra = state.extra;
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('zikr-list:${h.pushedKey}'),
                  TextButton(
                    onPressed: () => context.pop(),
                    child: const Text('back-from-zikr'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.customAzkarFormView,
        name: AppRoutes.customAzkarFormView,
        builder: (context, state) {
          h.formInitial = state.extra as CustomCategoryEntity?;
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('form-page'),
                  TextButton(
                    onPressed: () => context.pop(formResult),
                    child: const Text('return-from-form'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    ],
  );
  addTearDown(router.dispose);

  await tester.pumpWidget(
    ToastificationWrapper(
      child: MaterialApp.router(
        routerConfig: router,
        theme: AppTheme.light,
        builder: (context, child) {
          AppSize.init(context);
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(disableAnimations: true),
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: child!,
            ),
          );
        },
      ),
    ),
  );
  await tester.pumpAndSettle();

  return h;
}

class _SpyCategoriesCubit extends AzkarCategoriesCubit {
  _SpyCategoriesCubit(super.categories, super.custom, super.azkar);

  int loadCount = 0;

  @override
  Future<void> loadCategories() async {
    loadCount++;
    await super.loadCategories();
  }
}

class _FakeAzkarRepository implements AzkarRepository {
  _FakeAzkarRepository({this.zikrsResult});

  final Result<List<ZikrEntity>>? zikrsResult;
  int zikrsCalls = 0;

  @override
  Future<Result<List<AzkarCategoryEntity>>> getCategories() async =>
      const Result.success([]);

  @override
  Future<Result<List<ZikrEntity>>> getZikrsByCategory(
    String categoryKey,
  ) async {
    zikrsCalls++;
    return zikrsResult ?? const Result.success([]);
  }
}

class _FakeCustomCategoryRepository implements CustomCategoryRepository {
  _FakeCustomCategoryRepository({this.deleteResult});

  final Result<void>? deleteResult;
  final deletedIds = <String>[];

  @override
  Future<Result<void>> deleteCustomCategory(String id) async {
    deletedIds.add(id);
    return deleteResult ?? const Result.success(null);
  }

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

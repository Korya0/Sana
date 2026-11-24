import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/di/app_injector.dart';
import 'package:sana/core/router/app_routes.dart';
import 'package:sana/core/error/failure.dart';
import 'package:sana/core/error/result.dart';
import 'package:sana/core/theme/app_theme.dart';
import 'package:sana/core/theme/icons/app_icons.dart';
import 'package:sana/core/widgets/buttons/app_primary_button.dart';
import 'package:sana/features/azkar/domain/entities/azkar_category_entity.dart';
import 'package:sana/features/azkar/domain/entities/custom_category_entity.dart';
import 'package:sana/features/azkar/domain/entities/zikr_entity.dart';
import 'package:sana/features/azkar/domain/repositories/azkar_repository.dart';
import 'package:sana/features/azkar/domain/repositories/custom_category_repository.dart';
import 'package:sana/features/azkar/domain/use_cases/delete_custom_category_use_case.dart';
import 'package:sana/features/azkar/domain/use_cases/get_azkar_categories_use_case.dart';
import 'package:sana/features/azkar/domain/use_cases/get_custom_categories_use_case.dart';
import 'package:sana/features/azkar/domain/use_cases/save_custom_category_use_case.dart';
import 'package:sana/features/azkar/presentation/cubits/custom_azkar/custom_azkar_cubit.dart';
import 'package:sana/features/azkar/presentation/views/custom_azkar_list_view.dart';
import 'package:sana/features/azkar/presentation/widgets/custom_azkar_list/custom_azkar_list_skeleton.dart';

import '../../../../helpers/scroll_assertions.dart';

void main() {
  late _FakeCustomCategoryRepository repository;

  setUp(() {
    repository = _FakeCustomCategoryRepository();

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
  });

  tearDown(() async => sl.reset());

  testWidgets('shows the empty state when nothing is customised', (
    tester,
  ) async {
    await _pump(tester);
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.noCustomAzkarYet), findsOneWidget);
    expect(
      find.widgetWithText(AppPrimaryButton, AppStrings.addCustomAzkar),
      findsOneWidget,
    );
    expectNoExtraScroll(
      tester,
      reason: 'custom azkar empty state must not scroll',
    );
    // The empty state owns the create action; the app bar stays clean.
    expect(find.byTooltip(AppStrings.addCustomAzkar), findsNothing);
  });

  testWidgets(
    'shows the empty state immediately without flashing the loading skeleton',
    (tester) async {
      await _pump(tester);
      await tester.pump();

      expect(find.byType(CustomAzkarListSkeleton), findsNothing);
      expect(find.text(AppStrings.noCustomAzkarYet), findsOneWidget);
    },
  );

  testWidgets('shows each custom or modified category', (tester) async {
    repository.categories = const [
      CustomCategoryEntity(
        id: 'custom_1',
        name: 'أذكاري',
        azkar: [
          ZikrEntity(id: 1, text: 'سبحان الله', count: 3),
          ZikrEntity(id: 2, text: 'الحمد لله', count: 3),
        ],
      ),
      CustomCategoryEntity(
        id: 'morning',
        name: 'الصباح',
        azkar: [ZikrEntity(id: 3, text: 'ذكر', count: 3)],
      ),
    ];

    await _pump(tester);
    await tester.pumpAndSettle();

    expect(find.text('أذكاري'), findsOneWidget);
    expect(find.text(AppStrings.azkarCountLabel(2)), findsOneWidget);
    expect(find.text('الصباح'), findsOneWidget);
    // Both a custom category and a built-in override can be edited.
    expect(find.byIcon(AppIcons.edit), findsNWidgets(2));
    expect(find.byIcon(AppIcons.delete), findsOneWidget);
    expect(find.byIcon(AppIcons.refresh), findsOneWidget);
  });

  testWidgets('keeps a create action in the app bar when categories exist', (
    tester,
  ) async {
    repository.categories = const [
      CustomCategoryEntity(
        id: 'custom_1',
        name: 'أذكاري',
        azkar: [ZikrEntity(id: 1, text: 'سبحان الله', count: 3)],
      ),
    ];

    await _pump(tester);
    await tester.pumpAndSettle();

    expect(find.byTooltip(AppStrings.addCustomAzkar), findsOneWidget);
    expect(find.byIcon(AppIcons.add), findsOneWidget);
    // No duplicate create button in the body.
    expect(
      find.widgetWithText(AppPrimaryButton, AppStrings.addCustomAzkar),
      findsNothing,
    );
  });

  testWidgets('a failed restore shows an error toast', (tester) async {
    repository.categories = const [
      CustomCategoryEntity(
        id: 'morning',
        name: 'الصباح',
        azkar: [ZikrEntity(id: 3, text: 'ذكر', count: 3)],
      ),
    ];
    repository.deleteFailure = true;

    await _pump(tester);
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(AppIcons.refresh));
    await tester.pump(const Duration(milliseconds: 150));
    await tester.pumpAndSettle();

    await tester.tap(
      find.widgetWithText(AppPrimaryButton, AppStrings.restoreOriginal),
    );
    await tester.pumpAndSettle();

    // The failure is a toast; the loaded list stays visible.
    expect(find.text('تعذّر حذف القسم'), findsOneWidget);
    expect(find.text('الصباح'), findsOneWidget);

    // Let the toast timer finish so the test leaves no pending timers.
    await tester.pump(const Duration(seconds: 3));
  });

  testWidgets('deleting a category asks for confirmation and removes it', (
    tester,
  ) async {
    repository.categories = const [
      CustomCategoryEntity(
        id: 'custom_1',
        name: 'أذكاري',
        azkar: [ZikrEntity(id: 1, text: 'سبحان الله', count: 3)],
      ),
    ];
    await _pump(tester);
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(AppIcons.delete));
    await tester.pump(const Duration(milliseconds: 150));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.deleteCustomAzkarDialogTitle), findsOneWidget);

    await tester.tap(find.widgetWithText(AppPrimaryButton, AppStrings.delete));
    await tester.pumpAndSettle();

    expect(repository.deleteCalls, 1);
    expect(find.text(AppStrings.noCustomAzkarYet), findsOneWidget);

    // Let the success toast timer finish so the test leaves no pending timers.
    await tester.pump(const Duration(seconds: 3));
  });

  testWidgets('the app bar create action saves a form and reloads', (
    tester,
  ) async {
    repository.categories = const [
      CustomCategoryEntity(
        id: 'custom_1',
        name: 'أذكاري',
        azkar: [ZikrEntity(id: 1, text: 'سبحان الله', count: 3)],
      ),
    ];
    await _pumpWithRouter(tester);
    final loadsBeforeCreate = repository.loadCalls;

    await tester.tap(find.byTooltip(AppStrings.addCustomAzkar));
    await tester.pumpAndSettle();
    expect(find.text('Save form'), findsOneWidget);

    await tester.tap(find.text('Save form'));
    await tester.pumpAndSettle();

    expect(find.byType(CustomAzkarListView), findsOneWidget);
    expect(repository.loadCalls, loadsBeforeCreate + 1);
  });

  testWidgets('the empty state create action saves a form and reloads', (
    tester,
  ) async {
    await _pumpWithRouter(tester);
    final loadsBeforeCreate = repository.loadCalls;

    await tester.tap(
      find.widgetWithText(AppPrimaryButton, AppStrings.addCustomAzkar),
    );
    await tester.pumpAndSettle();
    expect(find.text('Save form'), findsOneWidget);

    await tester.tap(find.text('Save form'));
    await tester.pumpAndSettle();

    expect(find.byType(CustomAzkarListView), findsOneWidget);
    expect(repository.loadCalls, loadsBeforeCreate + 1);
  });

  testWidgets('the error state retries and loads the categories', (
    tester,
  ) async {
    repository.loadFailure = true;
    await _pump(tester);
    await tester.pumpAndSettle();

    expect(find.text('load failed'), findsOneWidget);
    expectNoExtraScroll(
      tester,
      reason: 'custom azkar error state must not scroll',
    );

    repository.loadFailure = false;
    await tester.tap(find.text(AppStrings.tryAgain));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.noCustomAzkarYet), findsOneWidget);
  });

  testWidgets(
    'the skeleton appears while loading takes longer than the delay',
    (
      tester,
    ) async {
      final completer = Completer<Result<List<CustomCategoryEntity>>>();
      repository.pendingLoad = completer;

      await _pump(tester);
      await tester.pump(const Duration(milliseconds: 200));

      expect(find.byType(CustomAzkarListSkeleton), findsOneWidget);

      completer.complete(const Result.success([]));
      await tester.pumpAndSettle();

      expect(find.text(AppStrings.noCustomAzkarYet), findsOneWidget);
    },
  );
}

Future<void> _pump(WidgetTester tester) => tester.pumpWidget(
  MaterialApp(
    theme: AppTheme.light,
    builder: (context, child) {
      AppSize.init(context);
      return Directionality(textDirection: TextDirection.rtl, child: child!);
    },
    home: const CustomAzkarListView(),
  ),
);

Future<void> _pumpWithRouter(WidgetTester tester) async {
  tester.view.physicalSize = const Size(400, 900);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  final router = GoRouter(
    initialLocation: AppRoutes.customAzkarView,
    routes: [
      GoRoute(
        path: AppRoutes.customAzkarView,
        builder: (context, state) => const CustomAzkarListView(),
      ),
      GoRoute(
        path: AppRoutes.customAzkarFormView,
        name: AppRoutes.customAzkarFormView,
        builder: (context, state) => Scaffold(
          body: TextButton(
            onPressed: () => context.pop(
              const CustomCategoryEntity(
                id: 'saved',
                name: 'أذكاري',
                azkar: [],
              ),
            ),
            child: const Text('Save form'),
          ),
        ),
      ),
    ],
  );
  addTearDown(router.dispose);

  await tester.pumpWidget(
    MaterialApp.router(
      theme: AppTheme.light,
      routerConfig: router,
      builder: (context, child) {
        AppSize.init(context);
        return Directionality(textDirection: TextDirection.rtl, child: child!);
      },
    ),
  );
  await tester.pumpAndSettle();
}

class _FakeCustomCategoryRepository implements CustomCategoryRepository {
  List<CustomCategoryEntity> categories = const [];
  int deleteCalls = 0;
  int loadCalls = 0;
  bool deleteFailure = false;
  bool loadFailure = false;
  Completer<Result<List<CustomCategoryEntity>>>? pendingLoad;

  @override
  Future<Result<void>> deleteCustomCategory(String id) async {
    deleteCalls++;
    if (deleteFailure) {
      return const Result.failure(
        CacheFailure(message: 'تعذّر حذف القسم'),
      );
    }
    categories = categories.where((category) => category.id != id).toList();
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
  Future<Result<List<CustomCategoryEntity>>> getCustomCategories() async {
    loadCalls++;
    if (pendingLoad != null) return pendingLoad!.future;
    if (loadFailure) {
      return const Result.failure(CacheFailure(message: 'load failed'));
    }
    return Result.success(categories);
  }

  @override
  Future<Result<void>> saveCustomCategory(
    CustomCategoryEntity category,
  ) async {
    categories = [
      ...categories.where((item) => item.id != category.id),
      category,
    ];
    return const Result.success(null);
  }
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

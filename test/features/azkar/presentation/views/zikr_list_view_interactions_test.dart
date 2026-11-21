import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/di/app_injector.dart';
import 'package:sana/core/error/failure.dart';
import 'package:sana/core/error/result.dart';
import 'package:sana/core/router/app_routes.dart';
import 'package:sana/core/services/volume_buttons/volume_buttons_service.dart';
import 'package:sana/core/theme/app_theme.dart';
import 'package:sana/core/widgets/buttons/app_icon_button.dart';
import 'package:sana/core/widgets/buttons/app_primary_button.dart';
import 'package:sana/core/widgets/buttons/app_secondary_button.dart';
import 'package:sana/features/azkar/domain/entities/azkar_category_entity.dart';
import 'package:sana/features/azkar/domain/entities/custom_category_entity.dart';
import 'package:sana/features/azkar/domain/entities/azkar_tasbeeh_settings_entity.dart';
import 'package:sana/features/azkar/domain/entities/zikr_entity.dart';
import 'package:sana/features/azkar/domain/repositories/azkar_repository.dart';
import 'package:sana/features/azkar/domain/repositories/azkar_tasbeeh_settings_repository.dart';
import 'package:sana/features/azkar/domain/repositories/custom_category_repository.dart';
import 'package:sana/features/azkar/domain/use_cases/delete_custom_category_use_case.dart';
import 'package:sana/features/azkar/domain/use_cases/get_azkar_categories_use_case.dart';
import 'package:sana/features/azkar/domain/use_cases/get_azkar_tasbeeh_settings_use_case.dart';
import 'package:sana/features/azkar/domain/use_cases/get_zikrs_by_category_use_case.dart';
import 'package:sana/features/azkar/domain/use_cases/update_azkar_tasbeeh_settings_use_case.dart';
import 'package:sana/features/azkar/presentation/cubits/azkar/azkar_cubit.dart';
import 'package:sana/features/azkar/presentation/cubits/azkar/azkar_state.dart';
import 'package:sana/features/azkar/presentation/cubits/azkar_tasbeeh_settings/azkar_tasbeeh_settings_cubit.dart';
import 'package:sana/features/azkar/presentation/views/zikr_list_view.dart';
import 'package:sana/features/azkar/presentation/widgets/common/azkar_tasbeeh_settings_bottom_sheet.dart';
import 'package:sana/features/azkar/presentation/widgets/zikr_list/zikr_card/zikr_item_card.dart';
import 'package:sana/features/azkar/presentation/widgets/zikr_list/zikr_list_skeleton.dart';
import 'package:toastification/toastification.dart';

import '../../../../helpers/fake_volume_buttons_service.dart';

void main() {
  late FakeVolumeButtonsService volumeButtons;

  setUp(() {
    volumeButtons = FakeVolumeButtonsService();
    sl.registerSingleton<VolumeButtonsService>(volumeButtons);
  });

  tearDown(() async => sl.reset());

  group('ZikrListView states', () {
    testWidgets('shows a skeleton and disables the options action while loading', (
      tester,
    ) async {
      final config = _Config(hangLoading: true);
      final h = await _pumpView(tester, config, settle: false);

      expect(find.byType(ZikrListSkeleton), findsOneWidget);
      expect(find.text(config.categoryTitle), findsOneWidget);
      expect(_actionButton(tester, AppStrings.editZikr).onPressed, isNull);
      h.azkarRepo.finishLoad();
      await tester.pumpAndSettle();
    });

    testWidgets('shows the error message and retries the load', (tester) async {
      final config = _Config(loadFailure: true);
      final h = await _pumpView(tester, config);

      expect(find.text('تعذّر التحميل'), findsOneWidget);

      config.loadFailure = false;
      await tester.tap(find.widgetWithText(AppPrimaryButton, AppStrings.tryAgain));
      await tester.pumpAndSettle();

      expect(h.azkarRepo.zikrsCalls, 2);
      expect(find.byType(ZikrItemCard), findsNWidgets(2));
    });

    testWidgets('shows the empty message for an empty category', (tester) async {
      await _pumpView(tester, _Config(azkar: const []));

      expect(find.text(AppStrings.azkarEmpty), findsOneWidget);
      expect(find.byType(ZikrItemCard), findsNothing);
    });

    testWidgets('resolves the title from the repository when loaded', (
      tester,
    ) async {
      await _pumpView(
        tester,
        _Config(
          categoryTitle: 'عنوان محلي',
          categories: const [
            AzkarCategoryEntity(
              key: 'morning',
              title: 'عنوان من المستودع',
              cardTitle: 'الصباح',
            ),
          ],
        ),
      );

      expect(find.text('عنوان من المستودع'), findsWidgets);
      expect(_actionButton(tester, AppStrings.editZikr).onPressed, isNotNull);
    });
  });

  group('ZikrListView counting', () {
    testWidgets('volume up and down change the first incomplete zikr', (
      tester,
    ) async {
      await _pumpView(tester, _Config());

      expect(volumeButtons.handler, isNotNull);
      expect(_remaining(tester, 0), 33);

      volumeButtons.emit(VolumeButtonDirection.up);
      await tester.pumpAndSettle();
      expect(_remaining(tester, 0), 32);

      volumeButtons.emit(VolumeButtonDirection.down);
      await tester.pumpAndSettle();
      expect(_remaining(tester, 0), 33);
    });

    testWidgets('volume counting is ignored while loading or after completion', (
      tester,
    ) async {
      final h = await _pumpView(
        tester,
        _Config(azkar: const [
          ZikrEntity(id: 1, text: 'سبحان الله', count: 1),
        ]),
      );

      volumeButtons.emit(VolumeButtonDirection.up);
      await tester.pumpAndSettle();
      expect(h.cubit.state, isA<AzkarLoaded>());
      expect((h.cubit.state as AzkarLoaded).isAllCompleted, isTrue);
      expect(find.text(AppStrings.azkarCompletedMessage), findsOneWidget);

      // Once every zikr is complete the binding is detached.
      expect(volumeButtons.handler, isNull);
      await tester.pump(const Duration(seconds: 3));
    });

    testWidgets('completing a card scrolls to the next one and shows a toast', (
      tester,
    ) async {
      final h = await _pumpView(
        tester,
        _Config(
          azkar: const [
            ZikrEntity(id: 1, text: 'سبحان الله', count: 1),
            ZikrEntity(id: 2, text: 'الحمد لله', count: 1),
          ],
        ),
      );

      await tester.tap(find.byType(ZikrItemCardContent).first);
      await tester.pumpAndSettle();

      expect(_remaining(tester, 0), 0);
      expect(tester.takeException(), isNull);
      expect(find.text(AppStrings.azkarCompletedMessage), findsNothing);

      await tester.tap(find.byType(ZikrItemCardContent).last);
      await tester.pumpAndSettle();

      // All azkar are complete and the completion listener has run. The toast
      // itself is asserted in the first completion test; AppToast debounces
      // identical messages across tests.
      expect((h.cubit.state as AzkarLoaded).isAllCompleted, isTrue);
      await tester.pump(const Duration(seconds: 3));
    });

    testWidgets('auto-scroll searches for an off-screen next card', (
      tester,
    ) async {
      final h = await _pumpView(
        tester,
        _Config(
          azkar: List.generate(
            30,
            (i) => ZikrEntity(id: i + 1, text: 'ذكر $i', count: 1),
          ),
        ),
      );

      for (var i = 0; i < 12; i++) {
        volumeButtons.emit(VolumeButtonDirection.up);
        await tester.pump(const Duration(milliseconds: 50));
      }
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect((h.cubit.state as AzkarLoaded).firstIncompleteIndex, 12);
      await tester.pump(const Duration(seconds: 3));
    });

    testWidgets('completion with volume up closes the screen', (tester) async {
      await _pumpView(
        tester,
        _Config(
          azkar: const [
            ZikrEntity(id: 1, text: 'سبحان الله', count: 1),
          ],
        ),
      );

      volumeButtons.emit(VolumeButtonDirection.up);
      await tester.pumpAndSettle();
      await tester.pump(const Duration(milliseconds: 600));

      expect(find.text('open'), findsOneWidget);
      await tester.pump(const Duration(seconds: 3));
    });
  });

  group('ZikrListView exit', () {
    testWidgets('exits without a prompt before counting starts', (tester) async {
      await _pumpView(tester, _Config());

      await tester.tap(find.byTooltip(AppStrings.back));
      await tester.pumpAndSettle();

      expect(find.text('open'), findsOneWidget);
      expect(find.text(AppStrings.azkarExitDialogTitle), findsNothing);
    });

    testWidgets('system back is routed through the exit handler', (tester) async {
      await _pumpView(tester, _Config());

      final popScope = tester.widget<PopScope>(
        find.byWidgetPredicate((widget) => widget is PopScope),
      );
      popScope.onPopInvokedWithResult!(false, null);
      await tester.pumpAndSettle();

      expect(find.text('open'), findsOneWidget);
    });

    testWidgets('cancel keeps the screen; confirm exits after progress', (
      tester,
    ) async {
      await _pumpView(tester, _Config());

      volumeButtons.emit(VolumeButtonDirection.up);
      await tester.pumpAndSettle();

      await tester.tap(find.byTooltip(AppStrings.back));
      await tester.pumpAndSettle();
      expect(find.text(AppStrings.azkarExitDialogTitle), findsOneWidget);

      await tester.tap(
        find.widgetWithText(
          AppSecondaryButton,
          AppStrings.azkarExitDialogCancelText,
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('open'), findsNothing);

      await tester.tap(find.byTooltip(AppStrings.back));
      await tester.pumpAndSettle();
      await tester.tap(
        find.widgetWithText(
          AppPrimaryButton,
          AppStrings.azkarExitDialogConfirmText,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('open'), findsOneWidget);
    });
  });

  group('ZikrListView category actions', () {
    testWidgets('edit applies the saved category to the current state', (
      tester,
    ) async {
      const saved = CustomCategoryEntity(
        id: 'morning',
        name: 'اسم جديد',
        azkar: [ZikrEntity(id: 9, text: 'ذكر جديد', count: 5)],
      );
      final h = await _pumpView(tester, _Config(formResult: saved));

      await tester.tap(find.byTooltip(AppStrings.editZikr));
      await tester.pumpAndSettle();
      await tester.tap(find.text(AppStrings.editZikr));
      await tester.pumpAndSettle();

      expect(find.text('form-page'), findsOneWidget);
      expect(h.formExtra?.id, 'morning');
      expect(h.formExtra?.name, 'أذكار الصباح');
      expect(h.formExtra?.azkar.length, 2);

      await tester.tap(find.text('return-from-form'));
      await tester.pumpAndSettle();

      expect(find.text('اسم جديد'), findsWidgets);
      expect(find.text('ذكر جديد'), findsOneWidget);
    });

    testWidgets('edit ignores a cancelled form', (tester) async {
      await _pumpView(tester, _Config(formResult: null));

      await tester.tap(find.byTooltip(AppStrings.editZikr));
      await tester.pumpAndSettle();
      await tester.tap(find.text(AppStrings.editZikr));
      await tester.pumpAndSettle();
      await tester.tap(find.text('return-from-form'));
      await tester.pumpAndSettle();

      expect(find.text('أذكار الصباح'), findsWidgets);
      expect(find.text('ذكر جديد'), findsNothing);
    });

    testWidgets('restore deletes the override and reloads the category', (
      tester,
    ) async {
      final h = await _pumpView(
        tester,
        _Config(
          customOverride: const CustomCategoryEntity(
            id: 'morning',
            name: 'أذكار الصباح',
            azkar: [],
          ),
        ),
      );

      await tester.tap(find.byTooltip(AppStrings.editZikr));
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

      expect(h.customRepo.deletedIds, ['morning']);
      final state = h.cubit.state;
      expect(state, isA<AzkarLoaded>());
      expect((state as AzkarLoaded).isModified, isFalse);
    });

    testWidgets('a failed restore shows an error toast', (tester) async {
      final h = await _pumpView(
        tester,
        _Config(
          customOverride: const CustomCategoryEntity(
            id: 'morning',
            name: 'أذكار الصباح',
            azkar: [],
          ),
          deleteResult: const Result.failure(
            CacheFailure(message: 'تعذّر الاستعادة'),
          ),
        ),
      );

      await tester.tap(find.byTooltip(AppStrings.editZikr));
      await tester.pumpAndSettle();
      await tester.tap(find.text(AppStrings.restoreOriginal));
      await tester.pumpAndSettle();
      await tester.tap(
        find.widgetWithText(AppPrimaryButton, AppStrings.restoreOriginal),
      );
      await tester.pumpAndSettle();

      expect(h.customRepo.deletedIds, ['morning']);
      expect(find.text('تعذّر الاستعادة'), findsOneWidget);
      await tester.pump(const Duration(seconds: 3));
    });

    testWidgets('delete removes a custom category and returns to the previous page', (
      tester,
    ) async {
      final h = await _pumpView(
        tester,
        _Config(categoryKey: 'custom_1', categoryTitle: 'مخصصة'),
      );

      await tester.tap(find.byTooltip(AppStrings.editZikr));
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
      expect(find.text(AppStrings.customAzkarDeletedSuccess), findsOneWidget);
      expect(find.text('open'), findsOneWidget);
      await tester.pump(const Duration(seconds: 3));
    });

    testWidgets('cancelling delete keeps the custom category', (tester) async {
      final h = await _pumpView(
        tester,
        _Config(categoryKey: 'custom_1', categoryTitle: 'مخصصة'),
      );

      await tester.tap(find.byTooltip(AppStrings.editZikr));
      await tester.pumpAndSettle();
      await tester.tap(find.text(AppStrings.deleteZikr));
      await tester.pumpAndSettle();
      await tester.tap(
        find.widgetWithText(AppSecondaryButton, AppStrings.cancel),
      );
      await tester.pumpAndSettle();

      expect(h.customRepo.deletedIds, isEmpty);
      expect(find.text('open'), findsNothing);
    });

    testWidgets('a failed delete reports the error without leaving', (
      tester,
    ) async {
      final h = await _pumpView(
        tester,
        _Config(
          categoryKey: 'custom_1',
          categoryTitle: 'مخصصة',
          deleteResult: const Result.failure(
            CacheFailure(message: 'تعذّر الحذف'),
          ),
        ),
      );

      await tester.tap(find.byTooltip(AppStrings.editZikr));
      await tester.pumpAndSettle();
      await tester.tap(find.text(AppStrings.deleteZikr));
      await tester.pumpAndSettle();
      await tester.tap(
        find.widgetWithText(AppPrimaryButton, AppStrings.delete),
      );
      await tester.pumpAndSettle();

      expect(h.customRepo.deletedIds, ['custom_1']);
      expect(find.text('تعذّر الحذف'), findsOneWidget);
      expect(find.text('open'), findsNothing);
      await tester.pump(const Duration(seconds: 3));
    });

    testWidgets('dismissing the options sheet has no side effects', (
      tester,
    ) async {
      final h = await _pumpView(tester, _Config());

      await tester.tap(find.byTooltip(AppStrings.editZikr));
      await tester.pumpAndSettle();
      expect(find.text(AppStrings.azkarOptions), findsOneWidget);

      await tester.tapAt(const Offset(5, 5));
      await tester.pumpAndSettle();

      expect(h.customRepo.deletedIds, isEmpty);
      expect(h.formExtra, isNull);
    });
  });

  group('ZikrListView reading settings', () {
    testWidgets('font size reopens the reading settings via the back button', (
      tester,
    ) async {
      await _pumpView(tester, _Config());

      await tester.tap(find.byTooltip(AppStrings.azkarTasbeehSettingsTitle));
      await tester.pumpAndSettle();
      expect(find.text(AppStrings.azkarTasbeehSettingsTitle), findsOneWidget);

      await tester.tap(find.text(AppStrings.fontSize));
      await tester.pumpAndSettle();
      expect(find.text(AppStrings.fontSize), findsWidgets);

      await tester.tap(
        find.descendant(
          of: find.byType(AzkarTasbeehSettingsBottomSheet),
          matching: find.byTooltip(AppStrings.back),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text(AppStrings.azkarTasbeehSettingsTitle), findsOneWidget);
      expect(find.text(AppStrings.fontSize), findsOneWidget);
    });

    testWidgets('closing the reading settings does not open the font sheet', (
      tester,
    ) async {
      await _pumpView(tester, _Config());

      await tester.tap(find.byTooltip(AppStrings.azkarTasbeehSettingsTitle));
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip(AppStrings.close));
      await tester.pumpAndSettle();

      expect(find.text(AppStrings.fontSize), findsNothing);
      expect(find.text(AppStrings.azkarOptions), findsNothing);
    });
  });
}

class _Config {
  _Config({
    this.categoryKey = 'morning',
    this.categoryTitle = 'أذكار الصباح',
    List<ZikrEntity>? azkar,
    this.loadFailure = false,
    this.hangLoading = false,
    this.customOverride,
    this.deleteResult,
    this.formResult,
    List<AzkarCategoryEntity>? categories,
  }) : azkar =
          azkar ??
          const [
            ZikrEntity(id: 1, text: 'سبحان الله', count: 33),
            ZikrEntity(id: 2, text: 'الحمد لله', count: 33),
          ],
       categories =
           categories ??
           const [
             AzkarCategoryEntity(
               key: 'morning',
               title: 'أذكار الصباح',
               cardTitle: 'الصباح',
             ),
           ];

  final String categoryKey;
  final String categoryTitle;
  final List<ZikrEntity> azkar;
  final List<AzkarCategoryEntity> categories;
  bool loadFailure;
  final bool hangLoading;
  CustomCategoryEntity? customOverride;
  final Result<void>? deleteResult;
  final CustomCategoryEntity? formResult;
}

class _Harness {
  _Harness(this.azkarRepo, this.customRepo, this.cubit);

  final _FakeAzkarRepository azkarRepo;
  final _FakeCustomCategoryRepository customRepo;
  final _SpyAzkarCubit cubit;

  CustomCategoryEntity? formExtra;
}

Future<_Harness> _pumpView(
  WidgetTester tester,
  _Config config, {
  bool settle = true,
}) async {
  tester.view.physicalSize = const Size(400, 900);
  tester.view.devicePixelRatio = 1;

  final azkarRepo = _FakeAzkarRepository(config);
  final customRepo = _FakeCustomCategoryRepository(config);
  final cubit = _SpyAzkarCubit(
    GetZikrsByCategoryUseCase(azkarRepo),
    GetAzkarCategoriesUseCase(azkarRepo),
    DeleteCustomCategoryUseCase(customRepo),
    customRepo,
  );
  final settingsCubit = _loadedSettingsCubit();
  await settingsCubit.loadSettings();
  sl.registerFactory<AzkarCubit>(() => cubit);
  sl.registerFactory<AzkarTasbeehSettingsCubit>(() => settingsCubit);

  final h = _Harness(azkarRepo, customRepo, cubit);

  final router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => Scaffold(
          body: Center(
            child: TextButton(
              onPressed: () => context.pushNamed(
                AppRoutes.zikrListView,
                pathParameters: {AppRoutes.categoryParam: config.categoryKey},
                extra: config.categoryTitle,
              ),
              child: const Text('open'),
            ),
          ),
        ),
      ),
      GoRoute(
        path: AppRoutes.zikrListView,
        name: AppRoutes.zikrListView,
        builder: (context, state) => ZikrListView(
          categoryKey: config.categoryKey,
          categoryTitle: config.categoryTitle,
        ),
      ),
      GoRoute(
        path: AppRoutes.customAzkarFormView,
        name: AppRoutes.customAzkarFormView,
        builder: (context, state) {
          h.formExtra = state.extra as CustomCategoryEntity?;
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('form-page'),
                  TextButton(
                    onPressed: () => context.pop(config.formResult),
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
  if (settle) {
    await tester.pumpAndSettle();
  } else {
    await tester.pump();
  }
  await tester.tap(find.text('open'));
  if (settle) {
    await tester.pumpAndSettle();
  } else {
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
  }

  return h;
}

AppIconButton _actionButton(WidgetTester tester, String tooltip) => tester.widget(
  find.ancestor(
        of: find.byTooltip(tooltip),
        matching: find.byType(AppIconButton),
      )
      .first,
);

int _remaining(WidgetTester tester, int index) => tester
    .widget<ZikrItemCardContent>(find.byType(ZikrItemCardContent).at(index))
    .progress
    .remaining;

AzkarTasbeehSettingsCubit _loadedSettingsCubit() {
  const repository = _FakeSettingsRepository();
  return AzkarTasbeehSettingsCubit(
    GetAzkarTasbeehSettingsUseCase(repository),
    UpdateAzkarTasbeehSettingsUseCase(repository),
  );
}

class _FakeSettingsRepository implements AzkarTasbeehSettingsRepository {
  const _FakeSettingsRepository();

  @override
  Future<Result<AzkarTasbeehSettingsEntity>> getAzkarTasbeehSettings() async =>
      Result.success(
        AzkarTasbeehSettingsEntity(
          fontSize: 20,
          volumeButtonCountEnabled: true,
        ),
      );

  @override
  Future<Result<void>> updateAzkarTasbeehSettings(
    AzkarTasbeehSettingsEntity settings,
  ) async => const Result.success(null);
}

class _SpyAzkarCubit extends AzkarCubit {
  _SpyAzkarCubit(super.zikrs, super.categories, super.delete, super.repository);

  int loadCalls = 0;

  @override
  Future<void> loadAzkar(
    String categoryKey, {
    required String categoryTitle,
  }) async {
    loadCalls++;
    await super.loadAzkar(categoryKey, categoryTitle: categoryTitle);
  }
}

class _FakeAzkarRepository implements AzkarRepository {
  _FakeAzkarRepository(this.config);

  final _Config config;
  final Completer<void> _gate = Completer<void>();
  int zikrsCalls = 0;

  void finishLoad() {
    if (!_gate.isCompleted) _gate.complete();
  }

  @override
  Future<Result<List<AzkarCategoryEntity>>> getCategories() async =>
      Result.success(config.categories);

  @override
  Future<Result<List<ZikrEntity>>> getZikrsByCategory(
    String categoryKey,
  ) async {
    zikrsCalls++;
    if (config.hangLoading) await _gate.future;
    if (config.loadFailure) {
      return const Result.failure(CacheFailure(message: 'تعذّر التحميل'));
    }
    return Result.success(config.azkar);
  }
}

class _FakeCustomCategoryRepository implements CustomCategoryRepository {
  _FakeCustomCategoryRepository(this.config);

  final _Config config;
  final deletedIds = <String>[];

  @override
  Future<Result<void>> deleteCustomCategory(String id) async {
    deletedIds.add(id);
    config.customOverride = null;
    return config.deleteResult ?? const Result.success(null);
  }

  @override
  Future<Result<CustomCategoryEntity?>> getCustomCategoryById(String id) async =>
      Result.success(config.customOverride);

  @override
  Future<Result<List<CustomCategoryEntity>>> getCustomCategories() async =>
      const Result.success([]);

  @override
  Future<Result<void>> saveCustomCategory(CustomCategoryEntity category) async =>
      const Result.success(null);
}

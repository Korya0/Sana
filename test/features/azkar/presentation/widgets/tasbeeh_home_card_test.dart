import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/di/app_injector.dart';
import 'package:sana/core/error/failure.dart';
import 'package:sana/core/error/result.dart';
import 'package:sana/core/router/app_routes.dart';
import 'package:sana/core/widgets/inputs/app_text_area_field.dart';
import 'package:sana/core/theme/app_theme.dart';
import 'package:sana/features/azkar/domain/entities/tasbeeh_item_entity.dart';
import 'package:sana/features/azkar/domain/repositories/tasbeeh_repository.dart';
import 'package:sana/features/azkar/domain/use_cases/delete_tasbeeh_item_use_case.dart';
import 'package:sana/features/azkar/domain/use_cases/get_tasbeeh_items_use_case.dart';
import 'package:sana/features/azkar/domain/use_cases/save_tasbeeh_item_use_case.dart';
import 'package:sana/features/azkar/presentation/cubits/azkar_tasbeeh_settings/azkar_tasbeeh_settings_cubit.dart';
import 'package:sana/features/azkar/presentation/cubits/tasbeeh/tasbeeh_cubit.dart';
import 'package:sana/features/azkar/presentation/widgets/azkar_tasbeeh_home/tasbeeh/tasbeeh_home_card.dart';
import 'package:sana/features/azkar/presentation/widgets/azkar_tasbeeh_home/tasbeeh/tasbeeh_recent_item.dart';
import 'package:sana/features/azkar/presentation/widgets/common/tasbeeh_bead_counter.dart';
import 'package:sana/features/azkar/presentation/widgets/common/tasbeeh_options_bottom_sheet.dart';
import 'package:sana/features/azkar/presentation/widgets/common/tasbeeh_preset_grid.dart';

import '../../../../helpers/scroll_assertions.dart';

import 'azkar_widget_test_harness.dart';

void main() {
  late _FakeTasbeehRepository repository;

  setUp(() {
    repository = _FakeTasbeehRepository();
    sl.registerFactory<TasbeehCubit>(
      () => TasbeehCubit(
        GetTasbeehItemsUseCase(repository),
        SaveTasbeehItemUseCase(repository),
        DeleteTasbeehItemUseCase(repository),
      ),
    );
  });

  tearDown(() async => sl.reset());

  testWidgets(
    'does not animate the saved card after returning from its screen',
    (tester) async {
      await _pumpCard(tester);

      final pulse = find.byKey(const ValueKey('tasbeeh_counter_pulse'));
      expect(pulse, findsNothing);

      await tester.tap(find.text(AppStrings.continueCounting));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Return'));
      await tester.pumpAndSettle();

      expect(pulse, findsNothing);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('empty state shows the start gauge and the custom action', (
    tester,
  ) async {
    repository.items = [];
    await _pumpCard(tester);

    expect(find.byType(TasbeehPresetGrid), findsOneWidget);
    expect(find.text(AppStrings.chooseOrAddCustomTasbeeh), findsOneWidget);
    expect(find.text(AppStrings.tasbeehPresetIstighfar), findsOneWidget);
    expect(find.text(AppStrings.tasbeehPresetAlhamdulillah), findsOneWidget);
    expect(find.text(AppStrings.tasbeehPresetSubhanAllah), findsOneWidget);
  });

  testWidgets('tapping the gauge navigates to the counter screen', (
    tester,
  ) async {
    await _pumpCard(tester);

    final gauge = tester.getRect(find.byType(TasbeehBeadCounter));
    await tester.tapAt(Offset(gauge.center.dx, gauge.top + AppSize.p8));
    await tester.pumpAndSettle();

    // The gauge is now pressable and navigates to the counter screen (onContinue).
    expect(find.text('Return'), findsOneWidget);
  });

  testWidgets(
    'saved item uses two lines, no remaining label, and both actions',
    (
      tester,
    ) async {
      repository.items = [
        TasbeehItemEntity(
          id: 'long',
          text: 'سبحان الله وبحمده سبحان الله العظيم ' * 4,
          currentCount: 2,
          targetCount: 33,
          lastUsedAt: DateTime(2026),
        ),
      ];
      await _pumpCard(tester);

      expect(find.byType(TasbeehRecentItem), findsOneWidget);
      expect(find.text(AppStrings.continueCounting), findsOneWidget);
      expect(find.text(AppStrings.allTasbeeh), findsNothing);
      expect(find.textContaining('متبقي'), findsNothing);

      final title = tester.widget<Text>(
        find.text(repository.items.single.text),
      );
      expect(title.maxLines, AppConstants.maxTwoLines);
      expect(title.overflow, TextOverflow.ellipsis);
    },
  );

  testWidgets('a failed preset add shows the failure toast', (tester) async {
    repository.items = [];
    repository.saveFailure = true;
    await _pumpCard(tester);

    await tester.tap(find.text(AppStrings.tasbeehPresetIstighfar));
    for (var i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }

    expect(find.text('save failed'), findsOneWidget);
    await tester.pump(const Duration(seconds: 3));
  });

  testWidgets('the continue chip opens the counter screen', (tester) async {
    await _pumpCard(tester);

    await tester.tap(find.text(AppStrings.continueCounting));
    await tester.pumpAndSettle();

    expect(find.text('Return'), findsOneWidget);
    expect(find.byType(TasbeehOptionsBottomSheet), findsNothing);
  });

  testWidgets('adding a preset from the empty state opens the counter screen', (
    tester,
  ) async {
    repository.items = [];
    await _pumpCard(tester);

    await tester.tap(find.text(AppStrings.tasbeehPresetIstighfar));
    await tester.pumpAndSettle();

    expect(repository.items, isNotEmpty);
    expect(find.text('Return'), findsOneWidget);
  });

  testWidgets('the custom action creates a tasbeeh and opens its screen', (
    tester,
  ) async {
    repository.items = [];
    await _pumpCard(tester);

    await tester.tap(find.text(AppStrings.chooseOrAddCustomTasbeeh));
    await tester.pumpAndSettle();
    expect(find.text(AppStrings.addTasbeeh), findsOneWidget);

    await _fillAndSaveTasbeeh(tester, 'سبحان الله وبحمده');

    expect(repository.items.single.text, 'سبحان الله وبحمده');
    expect(find.text('Return'), findsOneWidget);
  });

  testWidgets('the all-tasbeeh callback selects an item and opens it', (
    tester,
  ) async {
    await _pumpCard(tester);

    // The recent card keeps the open-all callback; invoke the production
    // closure directly because the card no longer renders a dedicated chip.
    final recent = tester.widget<TasbeehRecentItem>(
      find.byType(TasbeehRecentItem),
    );
    recent.onOpenAll!();
    await tester.pumpAndSettle();

    final sheet = find.byType(TasbeehOptionsBottomSheet);
    expect(sheet, findsOneWidget);
    await tester.tap(
      find.descendant(of: sheet, matching: find.text('سبحان الله')),
    );
    await tester.pumpAndSettle();

    expect(find.text('Return'), findsOneWidget);
  });

  testWidgets('the all-tasbeeh callback adds a tasbeeh when none are loaded', (
    tester,
  ) async {
    await _pumpCard(tester);
    final recent = tester.widget<TasbeehRecentItem>(
      find.byType(TasbeehRecentItem),
    );
    final openAll = recent.onOpenAll!;

    // Force the cubit into an error state so the options flow falls back to
    // its create path, which reports the newly added id through onAdded.
    repository.loadFailure = true;
    final cubit = tester
        .element(find.byType(TasbeehRecentItem))
        .read<TasbeehCubit>();
    await cubit.loadItems();
    await tester.pumpAndSettle();
    expect(find.text(AppStrings.tasbeehLoadError), findsOneWidget);

    openAll();
    await tester.pumpAndSettle();
    expect(find.text(AppStrings.addTasbeeh), findsOneWidget);

    repository.loadFailure = false;
    await _fillAndSaveTasbeeh(tester, 'الحمد لله');

    expect(find.text('Return'), findsOneWidget);
  });

  testWidgets('the error state retries and reloads the items', (tester) async {
    repository.loadFailure = true;
    await _pumpCard(tester);
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.tasbeehLoadError), findsOneWidget);
    expectNoExtraScroll(tester, reason: 'home tasbeeh error must not scroll');

    repository.loadFailure = false;
    await tester.tap(find.text(AppStrings.tryAgain));
    await tester.pumpAndSettle();

    expect(find.byType(TasbeehRecentItem), findsOneWidget);
  });
}

Future<void> _fillAndSaveTasbeeh(WidgetTester tester, String text) async {
  await tester.enterText(
    find.descendant(
      of: find.byType(AppTextAreaField),
      matching: find.byType(TextField),
    ),
    text,
  );
  await tester.pumpAndSettle();
  await tester.tap(find.text(AppStrings.save));
  await tester.pumpAndSettle();
}

Future<void> _pumpCard(WidgetTester tester) async {
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  final settings = await createLoadedSettingsCubit();
  final router = GoRouter(
    initialLocation: '/home',
    routes: [
      GoRoute(
        path: '/home',
        builder: (context, state) => const Scaffold(
          body: CustomScrollView(
            slivers: [SliverToBoxAdapter(child: TasbeehHomeCard())],
          ),
        ),
      ),
      GoRoute(
        path: '/counter',
        name: AppRoutes.tasbeehView,
        builder: (context, state) => Scaffold(
          body: TextButton(
            onPressed: () => context.pop(),
            child: const Text('Return'),
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
        return BlocProvider<AzkarTasbeehSettingsCubit>.value(
          value: settings,
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: child!,
          ),
        );
      },
    ),
  );
  // A moving label never settles, so pump a bounded amount instead.
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 100));
}

class _FakeTasbeehRepository implements TasbeehRepository {
  _FakeTasbeehRepository({List<TasbeehItemEntity>? items})
    : items =
          items ??
          [
            TasbeehItemEntity(
              id: 'subhan',
              text: 'سبحان الله',
              currentCount: 0,
              targetCount: 33,
              lastUsedAt: DateTime(2026),
            ),
          ];

  List<TasbeehItemEntity> items;
  bool saveFailure = false;
  bool loadFailure = false;

  @override
  Future<Result<void>> deleteTasbeehItem(String id) async {
    items = items.where((item) => item.id != id).toList();
    return const Result.success(null);
  }

  @override
  Future<Result<List<TasbeehItemEntity>>> getTasbeehItems() async => loadFailure
      ? const Result.failure(CacheFailure(message: 'load failed'))
      : Result.success(List.of(items));

  @override
  Future<Result<void>> saveTasbeehItem(TasbeehItemEntity item) async {
    if (saveFailure) {
      return const Result.failure(CacheFailure(message: 'save failed'));
    }
    final index = items.indexWhere((candidate) => candidate.id == item.id);
    if (index < 0) {
      items = [item, ...items];
    } else {
      items = List.of(items)..[index] = item;
    }
    return const Result.success(null);
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/di/app_injector.dart';
import 'package:sana/core/error/failure.dart';
import 'package:sana/core/error/result.dart';
import 'package:sana/core/services/volume_buttons/volume_buttons_service.dart';
import 'package:sana/core/theme/app_theme.dart';
import 'package:sana/core/theme/icons/app_icons.dart';
import 'package:sana/core/widgets/inputs/app_text_area_field.dart';
import 'package:sana/features/azkar/domain/entities/azkar_tasbeeh_settings_entity.dart';
import 'package:sana/features/azkar/domain/entities/tasbeeh_item_entity.dart';
import 'package:sana/features/azkar/domain/repositories/azkar_tasbeeh_settings_repository.dart';
import 'package:sana/features/azkar/domain/repositories/tasbeeh_repository.dart';
import 'package:sana/features/azkar/domain/use_cases/delete_tasbeeh_item_use_case.dart';
import 'package:sana/features/azkar/domain/use_cases/get_azkar_tasbeeh_settings_use_case.dart';
import 'package:sana/features/azkar/domain/use_cases/get_tasbeeh_items_use_case.dart';
import 'package:sana/features/azkar/domain/use_cases/save_tasbeeh_item_use_case.dart';
import 'package:sana/features/azkar/domain/use_cases/update_azkar_tasbeeh_settings_use_case.dart';
import 'package:sana/features/azkar/presentation/cubits/azkar_tasbeeh_settings/azkar_tasbeeh_settings_cubit.dart';
import 'package:sana/features/azkar/presentation/cubits/tasbeeh/tasbeeh_cubit.dart';
import 'package:sana/features/azkar/presentation/views/tasbeeh_view.dart';
import 'package:sana/features/azkar/presentation/widgets/common/tasbeeh_options_bottom_sheet.dart';
import 'package:sana/features/azkar/presentation/widgets/common/tasbeeh_preset_grid.dart';
import 'package:sana/features/azkar/presentation/widgets/tasbeeh/tasbeeh_item_card.dart';

import '../../../../helpers/fake_volume_buttons_service.dart';
import '../../../../helpers/scroll_assertions.dart';

void main() {
  late FakeVolumeButtonsService volumeButtons;
  late _FakeTasbeehRepository repository;

  setUp(() {
    volumeButtons = FakeVolumeButtonsService();
    sl.registerSingleton<VolumeButtonsService>(volumeButtons);
    repository = _FakeTasbeehRepository();
    sl.registerFactory<TasbeehCubit>(() => _tasbeehCubit(repository));
    sl.registerFactory<AzkarTasbeehSettingsCubit>(_azkarTasbeehSettingsCubit);
  });

  tearDown(() async => sl.reset());

  testWidgets('renders and counts from the populated tasbeeh screen', (
    tester,
  ) async {
    await _pumpView(tester);

    expect(tester.takeException(), isNull);
    expect(find.text(AppStrings.tasbeehTitle), findsOneWidget);
    expect(find.text(AppStrings.tasbeehListTitle), findsOneWidget);

    // Open the list and choose a different tasbeeh.
    await tester.tap(find.text(AppStrings.tasbeehListTitle));
    await tester.pumpAndSettle();

    expect(find.byType(TasbeehOptionsBottomSheet), findsOneWidget);
    final sheet = find.byType(TasbeehOptionsBottomSheet);
    expect(
      find.descendant(of: sheet, matching: find.text('سبحان الله')),
      findsOneWidget,
    );
    expect(
      find.descendant(of: sheet, matching: find.text('الحمد لله')),
      findsOneWidget,
    );
    expect(find.text(AppStrings.fontSize), findsNothing);
    expect(find.text(AppStrings.hapticFeedback), findsNothing);

    await tester.tap(
      find.descendant(of: sheet, matching: find.text('الحمد لله')),
    );
    await tester.pumpAndSettle();

    expect(find.byType(TasbeehItemCard), findsOneWidget);
    expect(_selectedItem(tester).id, 'hamd');
    expect(_selectedItem(tester).currentCount, 0);
    expect(find.byKey(const ValueKey('counter_33')), findsOneWidget);

    // Counter adjustments now live behind the minus icon of the card menu.
    final minus = find.descendant(
      of: find.byType(TasbeehItemCard),
      matching: find.byIcon(AppIcons.minus),
    );
    expect(minus, findsOneWidget);

    // Tapping the card counts one repetition.
    await tester.tap(find.text('الحمد لله'));
    await tester.pumpAndSettle();
    expect(_selectedCount(tester), 1);
    expect(find.byKey(const ValueKey('counter_32')), findsOneWidget);

    expect(volumeButtons.handler, isNotNull);
    volumeButtons.emit(VolumeButtonDirection.up);
    await tester.pumpAndSettle();
    expect(_selectedCount(tester), 2);

    volumeButtons.emit(VolumeButtonDirection.down);
    await tester.pumpAndSettle();
    expect(_selectedCount(tester), 1);

    // Decrement through the menu.
    await tester.tap(minus);
    await tester.pumpAndSettle();
    expect(
      find.byKey(const ValueKey('count_decrement_action')),
      findsOneWidget,
    );
    expect(find.byKey(const ValueKey('count_reset_action')), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('count_decrement_action')));
    await tester.pumpAndSettle();
    expect(_selectedCount(tester), 0);

    // Count up again and reset fully through the menu.
    for (var index = 0; index < 3; index++) {
      await tester.tap(find.text('الحمد لله'));
      await tester.pumpAndSettle();
    }
    expect(_selectedCount(tester), 3);

    await tester.tap(minus);
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('count_reset_action')));
    await tester.pumpAndSettle();
    expect(_selectedCount(tester), 0);

    for (var index = 0; index < 33; index++) {
      await tester.tap(find.text('الحمد لله'));
      await tester.pumpAndSettle();
    }

    expect(_selectedCount(tester), 33);
    expect(find.byKey(const ValueKey('counter_done')), findsOneWidget);

    // A tap after completion starts a fresh target cycle.
    await tester.tap(find.text('الحمد لله'));
    await tester.pumpAndSettle();
    expect(_selectedCount(tester), 1);
    expect(find.byKey(const ValueKey('counter_32')), findsOneWidget);

    await tester.tap(find.byTooltip(AppStrings.azkarTasbeehSettingsTitle));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.fontSize), findsOneWidget);
    expect(find.text(AppStrings.hapticFeedback), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('an empty list shows the preset grid and adds a preset', (
    tester,
  ) async {
    repository.items = [];
    await _pumpView(tester);

    expect(find.byType(TasbeehPresetGrid), findsOneWidget);
    expect(find.text(AppStrings.chooseOrAddCustomTasbeeh), findsOneWidget);

    await tester.tap(find.text(AppStrings.tasbeehPresetSubhanAllah));
    await tester.pumpAndSettle();

    expect(find.byType(TasbeehPresetGrid), findsNothing);
    expect(find.byType(TasbeehItemCard), findsOneWidget);
    expect(_selectedItem(tester).text, AppStrings.tasbeehPresetSubhanAllah);
  });

  testWidgets('the empty state custom action opens the add sheet', (
    tester,
  ) async {
    repository.items = [];
    await _pumpView(tester);

    await tester.tap(find.text(AppStrings.chooseOrAddCustomTasbeeh));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.addTasbeeh), findsOneWidget);
    expect(find.text(AppStrings.tasbeehName), findsOneWidget);

    await tester.enterText(
      find.descendant(
        of: find.byType(AppTextAreaField),
        matching: find.byType(TextField),
      ),
      'سبحان الله وبحمده',
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text(AppStrings.save));
    await tester.pumpAndSettle();

    expect(find.byType(TasbeehItemCard), findsOneWidget);
    expect(_selectedItem(tester).text, 'سبحان الله وبحمده');
  });

  testWidgets('the loaded body add action opens the add sheet', (tester) async {
    await _pumpView(tester);

    await tester.tap(find.text(AppStrings.addTasbeeh));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.tasbeehName), findsOneWidget);
  });

  testWidgets('reading settings can navigate to the font size sheet', (
    tester,
  ) async {
    await _pumpView(tester);

    await tester.tap(find.byTooltip(AppStrings.azkarTasbeehSettingsTitle));
    await tester.pumpAndSettle();
    expect(find.text(AppStrings.fontSize), findsOneWidget);

    await tester.tap(find.text(AppStrings.fontSize));
    await tester.pumpAndSettle();

    expect(find.byTooltip(AppStrings.back), findsOneWidget);

    // Going back from the font size sheet reopens the reading settings sheet.
    await tester.tap(find.byTooltip(AppStrings.back));
    await tester.pumpAndSettle();
    expect(find.text(AppStrings.fontSize), findsOneWidget);
    expect(find.text(AppStrings.hapticFeedback), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('the error state retries and loads the tasbeehs', (tester) async {
    repository.loadFailure = true;
    await _pumpView(tester);

    expect(find.text('load failed'), findsOneWidget);
    expectNoExtraScroll(tester, reason: 'tasbeeh error state must not scroll');

    repository.loadFailure = false;
    await tester.tap(find.text(AppStrings.tryAgain));
    await tester.pumpAndSettle();

    expect(find.byType(TasbeehItemCard), findsOneWidget);
  });
}

Future<void> _pumpView(WidgetTester tester) async {
  tester.view.physicalSize = const Size(800, 1200);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  final router = GoRouter(
    initialLocation: '/tasbeeh',
    routes: [
      GoRoute(
        path: '/tasbeeh',
        builder: (context, state) => const TasbeehView(),
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
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child!,
        );
      },
    ),
  );
  await tester.pumpAndSettle();
}

TasbeehItemEntity _selectedItem(WidgetTester tester) =>
    tester.widget<TasbeehItemCard>(find.byType(TasbeehItemCard)).item;

int _selectedCount(WidgetTester tester) => _selectedItem(tester).currentCount;

TasbeehCubit _tasbeehCubit(_FakeTasbeehRepository repository) => TasbeehCubit(
  GetTasbeehItemsUseCase(repository),
  SaveTasbeehItemUseCase(repository),
  DeleteTasbeehItemUseCase(repository),
);

AzkarTasbeehSettingsCubit _azkarTasbeehSettingsCubit() {
  final repository = _FakeAzkarTasbeehSettingsRepository();
  return AzkarTasbeehSettingsCubit(
    GetAzkarTasbeehSettingsUseCase(repository),
    UpdateAzkarTasbeehSettingsUseCase(repository),
  );
}

class _FakeTasbeehRepository implements TasbeehRepository {
  List<TasbeehItemEntity> items = [
    TasbeehItemEntity(
      id: 'subhan',
      text: 'سبحان الله',
      currentCount: 0,
      targetCount: 33,
      lastUsedAt: DateTime(2026),
    ),
    TasbeehItemEntity(
      id: 'hamd',
      text: 'الحمد لله',
      currentCount: 0,
      targetCount: 33,
      lastUsedAt: DateTime(2026),
    ),
  ];

  bool loadFailure = false;

  @override
  Future<Result<void>> deleteTasbeehItem(String id) async {
    items.removeWhere((item) => item.id == id);
    return const Result.success(null);
  }

  @override
  Future<Result<List<TasbeehItemEntity>>> getTasbeehItems() async => loadFailure
      ? const Result.failure(CacheFailure(message: 'load failed'))
      : Result.success(List.unmodifiable(items));

  @override
  Future<Result<void>> saveTasbeehItem(TasbeehItemEntity item) async {
    final index = items.indexWhere((candidate) => candidate.id == item.id);
    if (index < 0) {
      items.add(item);
    } else {
      items[index] = item;
    }
    return const Result.success(null);
  }
}

class _FakeAzkarTasbeehSettingsRepository
    implements AzkarTasbeehSettingsRepository {
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

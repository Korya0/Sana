import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/di/app_injector.dart';
import 'package:sana/core/error/result.dart';
import 'package:sana/core/services/volume_buttons/volume_buttons_service.dart';
import 'package:sana/core/theme/app_theme.dart';
import 'package:sana/core/theme/icons/app_icons.dart';
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
import 'package:sana/features/azkar/presentation/widgets/common/reading_text_content.dart';
import 'package:sana/features/azkar/presentation/widgets/tasbeeh/tasbeeh_counter_content.dart';
import 'package:sana/features/azkar/presentation/widgets/common/tasbeeh_counter_widgets.dart';

import '../../../../helpers/fake_volume_buttons_service.dart';

void main() {
  late FakeVolumeButtonsService volumeButtons;

  setUp(() {
    volumeButtons = FakeVolumeButtonsService();
    sl.registerSingleton<VolumeButtonsService>(volumeButtons);
    sl.registerFactory<TasbeehCubit>(_tasbeehCubit);
    sl.registerFactory<AzkarTasbeehSettingsCubit>(_azkarTasbeehSettingsCubit);
  });

  tearDown(() async => sl.reset());

  testWidgets('renders and counts from the populated tasbeeh screen', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
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

    expect(tester.takeException(), isNull);
    expect(
      find.byKey(const ValueKey('tasbeeh_selection_button')),
      findsOneWidget,
    );
    expect(find.text(AppStrings.chooseTasbeeh), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('tasbeeh_selection_button')));
    await tester.pumpAndSettle();

    expect(find.byType(TasbeehOptionsBottomSheet), findsOneWidget);
    expect(find.text(AppStrings.allTasbeeh), findsOneWidget);
    expect(find.text(AppStrings.chooseTasbeeh), findsOneWidget);
    expect(find.text(AppStrings.fontSize), findsNothing);
    expect(find.text(AppStrings.hapticFeedback), findsNothing);

    await tester.tap(find.text('الحمد لله').last);
    await tester.pumpAndSettle();

    expect(find.byType(TasbeehCounterContent), findsOneWidget);
    expect(
      tester
          .widget<TasbeehCounterContent>(find.byType(TasbeehCounterContent))
          .item
          .id,
      'hamd',
    );

    final contentRect = tester.getRect(
      find.byType(TasbeehCounterContent),
    );
    final textRect = tester.getRect(find.byType(ReadingTextContent));
    final counterRect = tester.getRect(find.byType(TasbeehCounter));
    final selectionRect = tester.getRect(
      find.byKey(const ValueKey('tasbeeh_selection_button')),
    );
    final resetRect = tester.getRect(
      find.byKey(const ValueKey('tasbeeh_reset_button')),
    );
    expect(
      (textRect.top + counterRect.bottom) / 2,
      closeTo(contentRect.center.dy, 1),
    );
    expect(find.byIcon(AppIcons.refresh), findsOneWidget);
    expect(find.text(AppStrings.resetCounter), findsOneWidget);
    expect(
      tester.getRect(find.byIcon(AppIcons.refresh)).center.dy,
      lessThan(tester.getRect(find.text(AppStrings.resetCounter)).center.dy),
    );
    final resetLabel = tester.widget<Text>(
      find.text(AppStrings.resetCounter),
    );
    expect(resetLabel.maxLines, 1);
    expect(resetLabel.softWrap, isFalse);
    expect(
      resetRect.center.dy,
      closeTo(selectionRect.center.dy, 1),
    );
    expect(resetRect.height, selectionRect.height);
    expect(resetRect.width, greaterThanOrEqualTo(AppSize.w88));
    expect(resetRect.right, lessThan(selectionRect.left));
    final resetDecoration =
        tester
                .widget<Container>(
                  find.descendant(
                    of: find.byKey(const ValueKey('tasbeeh_reset_button')),
                    matching: find.byType(Container),
                  ),
                )
                .decoration!
            as BoxDecoration;
    final selectionDecoration =
        tester
                .widget<Container>(
                  find.descendant(
                    of: find.byKey(const ValueKey('tasbeeh_selection_button')),
                    matching: find.byType(Container),
                  ),
                )
                .decoration!
            as BoxDecoration;
    expect(resetDecoration.borderRadius, selectionDecoration.borderRadius);

    await tester.tap(find.byType(TasbeehCounter));
    await tester.pumpAndSettle();

    final resetContainer = tester.widget<Container>(
      find.descendant(
        of: find.byKey(const ValueKey('tasbeeh_reset_button')),
        matching: find.byType(Container),
      ),
    );
    expect(
      (resetContainer.decoration! as BoxDecoration).color,
      AppTheme.light.colorScheme.primary,
    );
    expect(
      tester.widget<Text>(find.text(AppStrings.resetCounter)).style!.color,
      AppTheme.light.colorScheme.onPrimary,
    );
    expect(
      tester.widget<Icon>(find.byIcon(AppIcons.refresh)).color,
      AppTheme.light.colorScheme.onPrimary,
    );
    expect(
      tester
          .widget<TasbeehCounterContent>(find.byType(TasbeehCounterContent))
          .item
          .currentCount,
      1,
    );
    expect(find.byKey(const ValueKey('tasbeeh_counter_32')), findsOneWidget);

    expect(volumeButtons.handler, isNotNull);
    volumeButtons.emit(VolumeButtonDirection.up);
    await tester.pumpAndSettle();
    expect(
      tester
          .widget<TasbeehCounterContent>(find.byType(TasbeehCounterContent))
          .item
          .currentCount,
      2,
    );

    volumeButtons.emit(VolumeButtonDirection.down);
    await tester.pumpAndSettle();
    expect(
      tester
          .widget<TasbeehCounterContent>(find.byType(TasbeehCounterContent))
          .item
          .currentCount,
      1,
    );

    // Reach three so the two reset choices are distinguishable.
    await tester.tap(find.byType(TasbeehCounter));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(TasbeehCounter));
    await tester.pumpAndSettle();
    expect(
      tester
          .widget<TasbeehCounterContent>(find.byType(TasbeehCounterContent))
          .item
          .currentCount,
      3,
    );

    await tester.tap(find.byKey(const ValueKey('tasbeeh_reset_button')));
    await tester.pumpAndSettle();

    expect(
      tester
          .widget<TasbeehCounterContent>(find.byType(TasbeehCounterContent))
          .item
          .currentCount,
      2,
    );

    await tester.longPress(find.byKey(const ValueKey('tasbeeh_reset_button')));
    await tester.pumpAndSettle();

    expect(
      tester
          .widget<TasbeehCounterContent>(find.byType(TasbeehCounterContent))
          .item
          .currentCount,
      0,
    );

    for (var index = 0; index < 33; index++) {
      await tester.tap(find.byType(TasbeehCounter));
      await tester.pumpAndSettle();
    }

    expect(
      tester
          .widget<TasbeehCounterContent>(find.byType(TasbeehCounterContent))
          .item
          .currentCount,
      33,
    );
    expect(find.byKey(const ValueKey('tasbeeh_counter_done')), findsOneWidget);

    await tester.tap(find.byType(TasbeehCounter));
    await tester.pumpAndSettle();

    expect(
      tester
          .widget<TasbeehCounterContent>(find.byType(TasbeehCounterContent))
          .item
          .currentCount,
      1,
    );
    expect(find.byKey(const ValueKey('tasbeeh_counter_32')), findsOneWidget);

    await tester.tap(find.byTooltip(AppStrings.tasbeehOptions));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.fontSize), findsOneWidget);
    expect(find.text(AppStrings.hapticFeedback), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

TasbeehCubit _tasbeehCubit() {
  final repository = _FakeTasbeehRepository();
  return TasbeehCubit(
    GetTasbeehItemsUseCase(repository),
    SaveTasbeehItemUseCase(repository),
    DeleteTasbeehItemUseCase(repository),
  );
}

AzkarTasbeehSettingsCubit _azkarTasbeehSettingsCubit() {
  final repository = _FakeAzkarTasbeehSettingsRepository();
  return AzkarTasbeehSettingsCubit(
    GetAzkarTasbeehSettingsUseCase(repository),
    UpdateAzkarTasbeehSettingsUseCase(repository),
  );
}

class _FakeTasbeehRepository implements TasbeehRepository {
  final List<TasbeehItemEntity> _items = [
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

  @override
  Future<Result<void>> deleteTasbeehItem(String id) async {
    _items.removeWhere((item) => item.id == id);
    return const Result.success(null);
  }

  @override
  Future<Result<List<TasbeehItemEntity>>> getTasbeehItems() async =>
      Result.success(List.unmodifiable(_items));

  @override
  Future<Result<void>> saveTasbeehItem(TasbeehItemEntity item) async {
    final index = _items.indexWhere((candidate) => candidate.id == item.id);
    if (index < 0) {
      _items.add(item);
    } else {
      _items[index] = item;
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

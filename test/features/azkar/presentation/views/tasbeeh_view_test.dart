import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/di/app_injector.dart';
import 'package:sana/core/error/result.dart';
import 'package:sana/core/theme/app_theme.dart';
import 'package:sana/features/azkar/domain/entities/reading_settings_entity.dart';
import 'package:sana/features/azkar/domain/entities/tasbeeh_item_entity.dart';
import 'package:sana/features/azkar/domain/repositories/reading_settings_repository.dart';
import 'package:sana/features/azkar/domain/repositories/tasbeeh_repository.dart';
import 'package:sana/features/azkar/domain/use_cases/delete_tasbeeh_item_use_case.dart';
import 'package:sana/features/azkar/domain/use_cases/get_reading_settings_use_case.dart';
import 'package:sana/features/azkar/domain/use_cases/get_tasbeeh_items_use_case.dart';
import 'package:sana/features/azkar/domain/use_cases/save_tasbeeh_item_use_case.dart';
import 'package:sana/features/azkar/domain/use_cases/update_reading_settings_use_case.dart';
import 'package:sana/features/azkar/presentation/cubits/reading_settings/reading_settings_cubit.dart';
import 'package:sana/features/azkar/presentation/cubits/tasbeeh/tasbeeh_cubit.dart';
import 'package:sana/features/azkar/presentation/views/tasbeeh_view.dart';
import 'package:sana/features/azkar/presentation/widgets/tasbeeh/tasbeeh_counter_content.dart';
import 'package:sana/features/azkar/presentation/widgets/tasbeeh/tasbeeh_counter_widgets.dart';

void main() {
  setUp(() {
    sl.registerFactory<TasbeehCubit>(_tasbeehCubit);
    sl.registerFactory<ReadingSettingsCubit>(_readingSettingsCubit);
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
    expect(find.text('سبحان الله'), findsOneWidget);
    expect(find.text('الحمد لله'), findsOneWidget);

    await tester.tap(find.text('الحمد لله'));
    await tester.pumpAndSettle();

    expect(find.byType(TasbeehCounterContent), findsOneWidget);
    expect(find.text('الحمد لله'), findsOneWidget);

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

ReadingSettingsCubit _readingSettingsCubit() {
  final repository = _FakeReadingSettingsRepository();
  return ReadingSettingsCubit(
    GetReadingSettingsUseCase(repository),
    UpdateReadingSettingsUseCase(repository),
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
  Future<Result<void>> deleteItem(String id) async {
    _items.removeWhere((item) => item.id == id);
    return const Result.success(null);
  }

  @override
  Future<Result<List<TasbeehItemEntity>>> getItems() async =>
      Result.success(List.unmodifiable(_items));

  @override
  Future<Result<void>> saveItem(TasbeehItemEntity item) async {
    final index = _items.indexWhere((candidate) => candidate.id == item.id);
    if (index < 0) {
      _items.add(item);
    } else {
      _items[index] = item;
    }
    return const Result.success(null);
  }
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

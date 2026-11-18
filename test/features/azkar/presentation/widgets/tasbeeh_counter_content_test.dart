import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/error/result.dart';
import 'package:sana/features/azkar/domain/entities/tasbeeh_item_entity.dart';
import 'package:sana/features/azkar/domain/repositories/tasbeeh_repository.dart';
import 'package:sana/features/azkar/domain/use_cases/delete_tasbeeh_item_use_case.dart';
import 'package:sana/features/azkar/domain/use_cases/get_tasbeeh_items_use_case.dart';
import 'package:sana/features/azkar/domain/use_cases/save_tasbeeh_item_use_case.dart';
import 'package:sana/features/azkar/presentation/cubits/azkar_tasbeeh_settings/azkar_tasbeeh_settings_cubit.dart';
import 'package:sana/features/azkar/presentation/cubits/tasbeeh/tasbeeh_cubit.dart';
import 'package:sana/features/azkar/presentation/widgets/common/tasbeeh_counter_widgets.dart';
import 'package:sana/features/azkar/presentation/widgets/tasbeeh/tasbeeh_counter_content.dart';

import 'azkar_widget_test_harness.dart';

void main() {
  testWidgets('shows the zikr and increments the cubit counter', (tester) async {
    final repository = _FakeTasbeehRepository([
      TasbeehItemEntity(
        id: 'a',
        text: 'سبحان الله',
        currentCount: 2,
        targetCount: 10,
        lastUsedAt: DateTime(2026),
      ),
    ]);
    final cubit = _createCubit(repository);
    await cubit.loadItems();
    addTearDown(cubit.close);
    final settings = await createLoadedSettingsCubit();

    await pumpAzkarWidget(
      tester,
      MultiBlocProvider(
        providers: [
          BlocProvider<TasbeehCubit>.value(value: cubit),
          BlocProvider<AzkarTasbeehSettingsCubit>.value(value: settings),
        ],
        child: TasbeehCounterContent(item: repository.items.single),
      ),
    );

    expect(find.text('سبحان الله'), findsOneWidget);
    expect(find.byType(TasbeehCounter), findsOneWidget);

    await tester.tap(find.byType(TasbeehCounter));
    await tester.pumpAndSettle();

    expect(repository.saved.single.currentCount, 3);
  });

  testWidgets('shows the completion state for a completed item', (
    tester,
  ) async {
    final item = TasbeehItemEntity(
      id: 'a',
      text: 'سبحان الله',
      currentCount: 3,
      targetCount: 3,
      lastUsedAt: DateTime(2026),
    );
    final repository = _FakeTasbeehRepository([item]);
    final cubit = _createCubit(repository);
    await cubit.loadItems();
    addTearDown(cubit.close);
    final settings = await createLoadedSettingsCubit();

    await pumpAzkarWidget(
      tester,
      MultiBlocProvider(
        providers: [
          BlocProvider<TasbeehCubit>.value(value: cubit),
          BlocProvider<AzkarTasbeehSettingsCubit>.value(value: settings),
        ],
        child: TasbeehCounterContent(item: item),
      ),
    );

    expect(find.byKey(const ValueKey('tasbeeh_counter_done')), findsOneWidget);
  });
}

TasbeehCubit _createCubit(_FakeTasbeehRepository repository) => TasbeehCubit(
  GetTasbeehItemsUseCase(repository),
  SaveTasbeehItemUseCase(repository),
  DeleteTasbeehItemUseCase(repository),
);

class _FakeTasbeehRepository implements TasbeehRepository {
  _FakeTasbeehRepository(this.items);

  List<TasbeehItemEntity> items;
  final List<TasbeehItemEntity> saved = [];

  @override
  Future<Result<List<TasbeehItemEntity>>> getTasbeehItems() async =>
      Result.success(List.of(items));

  @override
  Future<Result<void>> saveTasbeehItem(TasbeehItemEntity item) async {
    saved.add(item);
    final index = items.indexWhere((existing) => existing.id == item.id);
    if (index >= 0) {
      items = List.of(items)..[index] = item;
    } else {
      items = [item, ...items];
    }
    return const Result.success(null);
  }

  @override
  Future<Result<void>> deleteTasbeehItem(String id) async {
    items = items.where((item) => item.id != id).toList();
    return const Result.success(null);
  }
}

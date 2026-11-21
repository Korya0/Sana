import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/error/result.dart';
import 'package:sana/core/theme/icons/app_icons.dart';
import 'package:sana/core/widgets/buttons/app_icon_button.dart';
import 'package:sana/features/azkar/domain/entities/tasbeeh_item_entity.dart';
import 'package:sana/features/azkar/domain/extensions/tasbeeh_item_list_extensions.dart';
import 'package:sana/features/azkar/domain/repositories/tasbeeh_repository.dart';
import 'package:sana/features/azkar/domain/use_cases/delete_tasbeeh_item_use_case.dart';
import 'package:sana/features/azkar/domain/use_cases/get_tasbeeh_items_use_case.dart';
import 'package:sana/features/azkar/domain/use_cases/save_tasbeeh_item_use_case.dart';
import 'package:sana/features/azkar/presentation/cubits/azkar_tasbeeh_settings/azkar_tasbeeh_settings_cubit.dart';
import 'package:sana/features/azkar/presentation/cubits/tasbeeh/tasbeeh_cubit.dart';
import 'package:sana/features/azkar/presentation/cubits/tasbeeh/tasbeeh_state.dart';
import 'package:sana/features/azkar/presentation/widgets/tasbeeh/tasbeeh_loaded_body.dart';

import 'azkar_widget_test_harness.dart';

void main() {
  testWidgets('shows a card with counter and reset actions', (tester) async {
    final item = TasbeehItemEntity(
      id: 'a',
      text: 'سبحان الله',
      currentCount: 2,
      targetCount: 10,
      lastUsedAt: DateTime(2026),
    );
    final repository = _FakeTasbeehRepository([item]);
    final cubit = _createCubit(repository);
    await cubit.loadItems();
    addTearDown(cubit.close);
    final settings = await createLoadedSettingsCubit();

    await pumpAzkarSliver(
      tester,
      MultiBlocProvider(
        providers: [
          BlocProvider<TasbeehCubit>.value(value: cubit),
          BlocProvider<AzkarTasbeehSettingsCubit>.value(value: settings),
        ],
        child: TasbeehLoadedBody(
          selectedItem: item,
          onAdd: () {},
          onOpenList: () {},
        ),
      ),
      size: const Size(800, 1200),
    );

    expect(find.text('سبحان الله'), findsOneWidget);
    final menu = find.byIcon(AppIcons.minus);
    expect(menu, findsOneWidget);

    await tester.tap(menu);
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('count_decrement_action')), findsOneWidget);
    expect(find.byKey(const ValueKey('count_reset_action')), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('count_decrement_action')));
    await tester.pumpAndSettle();
    expect(_count(cubit), 1);

    await tester.tap(menu);
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('count_reset_action')));
    await tester.pumpAndSettle();
    expect(_count(cubit), 0);
  });

  testWidgets('reset is a no-op at zero and the card increments', (
    tester,
  ) async {
    final item = TasbeehItemEntity(
      id: 'a',
      text: 'سبحان الله',
      currentCount: 0,
      targetCount: 10,
      lastUsedAt: DateTime(2026),
    );
    final repository = _FakeTasbeehRepository([item]);
    final cubit = _createCubit(repository);
    await cubit.loadItems();
    addTearDown(cubit.close);
    final settings = await createLoadedSettingsCubit();

    await pumpAzkarSliver(
      tester,
      MultiBlocProvider(
        providers: [
          BlocProvider<TasbeehCubit>.value(value: cubit),
          BlocProvider<AzkarTasbeehSettingsCubit>.value(value: settings),
        ],
        child: TasbeehLoadedBody(
          selectedItem: item,
          onAdd: () {},
          onOpenList: () {},
        ),
      ),
      size: const Size(800, 1200),
    );

    // At zero the count menu cannot be opened: its minus trigger is disabled.
    final menuTrigger = find.byWidgetPredicate(
      (widget) => widget is AppIconButton && widget.icon == AppIcons.minus,
    );
    expect(menuTrigger, findsOneWidget);
    expect(tester.widget<AppIconButton>(menuTrigger).onPressed, isNull);
    expect(find.byKey(const ValueKey('count_reset_action')), findsNothing);
    expect(_count(cubit), 0);

    await tester.tap(find.text('سبحان الله'));
    await tester.pumpAndSettle();
    expect(_count(cubit), 1);
  });
}

int _count(TasbeehCubit cubit) {
  final state = cubit.state;
  if (state is! TasbeehLoaded) throw StateError('expected loaded state');
  return state.items.byId('a')!.currentCount;
}

TasbeehCubit _createCubit(_FakeTasbeehRepository repository) => TasbeehCubit(
  GetTasbeehItemsUseCase(repository),
  SaveTasbeehItemUseCase(repository),
  DeleteTasbeehItemUseCase(repository),
);

class _FakeTasbeehRepository implements TasbeehRepository {
  _FakeTasbeehRepository(this.items);

  List<TasbeehItemEntity> items;

  @override
  Future<Result<List<TasbeehItemEntity>>> getTasbeehItems() async =>
      Result.success(List.of(items));

  @override
  Future<Result<void>> saveTasbeehItem(TasbeehItemEntity item) async {
    final index = items.indexWhere((existing) => existing.id == item.id);
    if (index < 0) {
      items = [item, ...items];
    } else {
      items = List.of(items)..[index] = item;
    }
    return const Result.success(null);
  }

  @override
  Future<Result<void>> deleteTasbeehItem(String id) async {
    items = items.where((item) => item.id != id).toList();
    return const Result.success(null);
  }
}

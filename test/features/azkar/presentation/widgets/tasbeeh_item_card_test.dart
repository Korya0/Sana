import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/error/result.dart';
import 'package:sana/core/theme/icons/app_icons.dart';
import 'package:sana/features/azkar/domain/entities/tasbeeh_item_entity.dart';
import 'package:sana/features/azkar/domain/extensions/tasbeeh_item_list_extensions.dart';
import 'package:sana/features/azkar/domain/repositories/tasbeeh_repository.dart';
import 'package:sana/features/azkar/domain/use_cases/delete_tasbeeh_item_use_case.dart';
import 'package:sana/features/azkar/domain/use_cases/get_tasbeeh_items_use_case.dart';
import 'package:sana/features/azkar/domain/use_cases/save_tasbeeh_item_use_case.dart';
import 'package:sana/features/azkar/presentation/cubits/azkar_tasbeeh_settings/azkar_tasbeeh_settings_cubit.dart';
import 'package:sana/features/azkar/presentation/cubits/tasbeeh/tasbeeh_cubit.dart';
import 'package:sana/features/azkar/presentation/cubits/tasbeeh/tasbeeh_state.dart';
import 'package:sana/features/azkar/presentation/widgets/common/card_action_menu.dart';
import 'package:sana/features/azkar/presentation/widgets/common/counter_ring.dart';
import 'package:sana/features/azkar/presentation/widgets/tasbeeh/tasbeeh_item_card.dart';

import 'azkar_widget_test_harness.dart';

void main() {
  group('TasbeehItemCard', () {
    testWidgets('renders the text, counter and action menu', (tester) async {
      final item = _item();
      await _pump(tester, item);

      expect(find.text(item.text), findsOneWidget);
      expect(find.byType(CounterRing), findsOneWidget);
      expect(find.byType(CardActionMenu), findsOneWidget);
    });

    testWidgets('shows the remaining count in the ring', (tester) async {
      await _pump(tester, _item(count: 2, target: 10));

      expect(find.byKey(const ValueKey('counter_8')), findsOneWidget);
    });

    testWidgets('tapping the card increments its counter', (tester) async {
      final cubit = await _pump(tester, _item(count: 2, target: 10));

      await tester.tap(find.text('سبحان الله'));
      await tester.pumpAndSettle();

      expect(_count(cubit), 3);
    });

    testWidgets('decrement and reset actions change the counter', (
      tester,
    ) async {
      final cubit = await _pump(tester, _item(count: 3, target: 10));

      await tester.tap(find.byIcon(AppIcons.minus));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('count_decrement_action')));
      await tester.pumpAndSettle();
      expect(_count(cubit), 2);

      await tester.tap(find.byIcon(AppIcons.minus));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('count_reset_action')));
      await tester.pumpAndSettle();
      expect(_count(cubit), 0);
    });

    testWidgets('a completed item shows the completion indicator', (
      tester,
    ) async {
      await _pump(tester, _item(count: 10, target: 10));

      expect(find.byKey(const ValueKey('counter_done')), findsOneWidget);
    });

    testWidgets('a free tasbeeh at the maximum cannot be counted further', (
      tester,
    ) async {
      final cubit = await _pump(
        tester,
        _item(count: 9999, target: null),
        reduceMotion: true,
      );

      await tester.tap(find.text('سبحان الله'));
      await tester.pumpAndSettle();

      expect(_count(cubit), 9999);
    });

    testWidgets('edit action saves the updated text', (tester) async {
      final cubit = await _pump(tester, _item(count: 2, target: 10));

      await tester.tap(find.byIcon(AppIcons.info));
      await tester.pumpAndSettle();
      await tester.tap(find.text(AppStrings.editTasbeeh));
      await tester.pumpAndSettle();

      final fields = find.byType(TextField);
      await tester.ensureVisible(fields.first);
      await tester.pumpAndSettle();
      await tester.enterText(fields.first, 'الحمد لله');
      await tester.ensureVisible(find.text(AppStrings.save));
      await tester.pumpAndSettle();
      await tester.tap(find.text(AppStrings.save));
      await tester.pumpAndSettle();

      final state = cubit.state;
      if (state is! TasbeehLoaded) throw StateError('expected loaded state');
      expect(state.items.byId('a')!.text, 'الحمد لله');
    });

    testWidgets('delete action asks for confirmation and removes the item', (
      tester,
    ) async {
      final cubit = await _pump(tester, _item(count: 2, target: 10));

      await tester.tap(find.byIcon(AppIcons.info));
      await tester.pumpAndSettle();
      await tester.tap(find.text(AppStrings.deleteTasbeeh));
      await tester.pumpAndSettle();

      expect(find.text(AppStrings.deleteTasbeehDialogTitle), findsOneWidget);
      await tester.tap(find.text(AppStrings.delete).last);
      await tester.pumpAndSettle();

      final state = cubit.state;
      if (state is! TasbeehLoaded) throw StateError('expected loaded state');
      expect(state.items.byId('a'), isNull);
    });
  });
}

TasbeehItemEntity _item({int count = 2, int? target = 10}) => TasbeehItemEntity(
  id: 'a',
  text: 'سبحان الله',
  currentCount: count,
  targetCount: target,
  lastUsedAt: DateTime(2026),
);

Future<TasbeehCubit> _pump(
  WidgetTester tester,
  TasbeehItemEntity item, {
  bool reduceMotion = false,
}) async {
  final repository = _FakeTasbeehRepository([item]);
  final cubit = TasbeehCubit(
    GetTasbeehItemsUseCase(repository),
    SaveTasbeehItemUseCase(repository),
    DeleteTasbeehItemUseCase(repository),
  );
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
      child: reduceMotion
          ? Builder(
              builder: (context) => MediaQuery(
                data: MediaQuery.of(context).copyWith(disableAnimations: true),
                child: TasbeehItemCard(item: item),
              ),
            )
          : TasbeehItemCard(item: item),
    ),
    size: const Size(800, 900),
  );
  return cubit;
}

int _count(TasbeehCubit cubit) {
  final state = cubit.state;
  if (state is! TasbeehLoaded) throw StateError('expected loaded state');
  return state.items.byId('a')!.currentCount;
}

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

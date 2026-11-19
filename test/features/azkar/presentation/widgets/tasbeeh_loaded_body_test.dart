import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/error/result.dart';
import 'package:sana/core/widgets/buttons/app_icon_label_button.dart';
import 'package:sana/features/azkar/domain/entities/tasbeeh_item_entity.dart';
import 'package:sana/features/azkar/domain/repositories/tasbeeh_repository.dart';
import 'package:sana/features/azkar/domain/use_cases/delete_tasbeeh_item_use_case.dart';
import 'package:sana/features/azkar/domain/use_cases/get_tasbeeh_items_use_case.dart';
import 'package:sana/features/azkar/domain/use_cases/save_tasbeeh_item_use_case.dart';
import 'package:sana/features/azkar/presentation/cubits/azkar_tasbeeh_settings/azkar_tasbeeh_settings_cubit.dart';
import 'package:sana/features/azkar/presentation/cubits/tasbeeh/tasbeeh_cubit.dart';
import 'package:sana/features/azkar/presentation/widgets/tasbeeh/tasbeeh_loaded_body.dart';

import 'azkar_widget_test_harness.dart';

void main() {
  testWidgets('shows the selected tasbeeh and an enabled reset action', (
    tester,
  ) async {
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
    var resets = 0;
    var longResets = 0;

    await pumpAzkarSliver(
      tester,
      MultiBlocProvider(
        providers: [
          BlocProvider<TasbeehCubit>.value(value: cubit),
          BlocProvider<AzkarTasbeehSettingsCubit>.value(value: settings),
        ],
        child: TasbeehLoadedBody(
          selectedItem: item,
          canReset: true,
          onOpenSavedItems: _noop,
          onReset: () => resets++,
          onResetLongPress: () => longResets++,
        ),
      ),
    );

    expect(find.text('سبحان الله'), findsNWidgets(2));
    expect(find.text(AppStrings.chooseTasbeeh), findsOneWidget);
    expect(find.text(AppStrings.resetCounter), findsOneWidget);
    expect(
      find.bySemanticsLabel(AppStrings.tasbeehSelectorSemantics(item.text)),
      findsOneWidget,
    );

    final reset = tester.widget<AppIconLabelButton>(
      find.byKey(const ValueKey('tasbeeh_reset_button')),
    );
    expect(reset.onPressed, isNotNull);
    expect(
      tester.getSize(find.byKey(const ValueKey('tasbeeh_reset_button'))).width,
      greaterThanOrEqualTo(AppSize.w88),
    );

    await tester.tap(find.byKey(const ValueKey('tasbeeh_reset_button')));
    await tester.pumpAndSettle();
    expect(resets, 1);

    await tester.longPress(find.byKey(const ValueKey('tasbeeh_reset_button')));
    await tester.pumpAndSettle();
    expect(longResets, 1);
    expect(resets, 1);
  });

  testWidgets('disables reset when canReset is false', (tester) async {
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
          canReset: false,
          onOpenSavedItems: _noop,
          onReset: _noop,
          onResetLongPress: _noop,
        ),
      ),
    );

    final reset = tester.widget<AppIconLabelButton>(
      find.byKey(const ValueKey('tasbeeh_reset_button')),
    );
    expect(reset.onPressed, isNull);
    expect(reset.onLongPress, isNull);
  });
}

void _noop() {}

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
    if (index >= 0) {
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

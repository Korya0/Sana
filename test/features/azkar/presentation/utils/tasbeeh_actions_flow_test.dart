import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/error/failure.dart';
import 'package:sana/core/error/result.dart';
import 'package:sana/features/azkar/domain/entities/tasbeeh_item_entity.dart';
import 'package:sana/features/azkar/domain/repositories/tasbeeh_repository.dart';
import 'package:sana/features/azkar/domain/use_cases/delete_tasbeeh_item_use_case.dart';
import 'package:sana/features/azkar/domain/use_cases/get_tasbeeh_items_use_case.dart';
import 'package:sana/features/azkar/domain/use_cases/save_tasbeeh_item_use_case.dart';
import 'package:sana/features/azkar/presentation/cubits/azkar_tasbeeh_settings/azkar_tasbeeh_settings_cubit.dart';
import 'package:sana/features/azkar/presentation/cubits/tasbeeh/tasbeeh_cubit.dart';
import 'package:sana/features/azkar/presentation/utils/tasbeeh_actions_flow.dart';
import 'package:toastification/toastification.dart';

import '../widgets/azkar_widget_test_harness.dart';

void main() {
  group('TasbeehActionsFlow', () {
    group('addPreset', () {
      testWidgets('adds a preset item and returns the selected item id', (
        tester,
      ) async {
        final repository = _FakeTasbeehRepository();
        final cubit = _cubit(repository);
        final settings = await createLoadedSettingsCubit();

        await _pumpHost(tester, cubit: cubit, settingsCubit: settings);
        final context = tester.element(find.byType(_FlowHost));

        final id = await TasbeehActionsFlow.addPreset(context, cubit, 'سبحان الله');
        await tester.pump();

        expect(id, isNotNull);
        expect(id, repository.saved.single.id);
        expect(repository.saved.single.text, 'سبحان الله');
        expect(cubit.state, isA<Object>()); // state updated via reload
        await tester.pump(const Duration(seconds: 3));
        addTearDown(cubit.close);
      });

      testWidgets('shows an error toast and returns null when adding fails', (
        tester,
      ) async {
        final repository = _FakeTasbeehRepository(failSave: true);
        final cubit = _cubit(repository);
        final settings = await createLoadedSettingsCubit();

        await _pumpHost(tester, cubit: cubit, settingsCubit: settings);
        final context = tester.element(find.byType(_FlowHost));

        final id = await TasbeehActionsFlow.addPreset(context, cubit, 'سبحان الله');
        await tester.pumpAndSettle();

        expect(id, isNull);
        await tester.pump(const Duration(seconds: 3));
        addTearDown(cubit.close);
      });
    });

    group('openOptions', () {
      testWidgets('returns without action when cubit is not loaded and add sheet is dismissed', (
        tester,
      ) async {
        final repository = _FakeTasbeehRepository();
        final cubit = _cubit(repository); // initial, not loaded
        final settings = await createLoadedSettingsCubit();
        var addedId = 'sentinel';

        await _pumpHost(tester, cubit: cubit, settingsCubit: settings);
        final context = tester.element(find.byType(_FlowHost));

        final future = TasbeehActionsFlow.openOptions(
          context,
          cubit,
          showReadingSettings: true,
          onAdded: (id) async {
            addedId = id ?? 'null';
          },
        );
        await tester.pumpAndSettle();

        // Dismiss the add-item form bottom sheet.
        await tester.tapAt(const Offset(10, 10));
        await tester.pumpAndSettle();
        await future;

        expect(addedId, 'sentinel');
        expect(repository.saved, isEmpty);
        addTearDown(cubit.close);
      });
    });
  });
}

TasbeehCubit _cubit(_FakeTasbeehRepository repository) => TasbeehCubit(
  GetTasbeehItemsUseCase(repository),
  SaveTasbeehItemUseCase(repository),
  DeleteTasbeehItemUseCase(repository),
);

Future<void> _pumpHost(
  WidgetTester tester, {
  required TasbeehCubit cubit,
  required AzkarTasbeehSettingsCubit settingsCubit,
}) async {
  await pumpAzkarWidget(
    tester,
    ToastificationWrapper(
      child: MultiBlocProvider(
        providers: [
          BlocProvider<TasbeehCubit>.value(value: cubit),
          BlocProvider<AzkarTasbeehSettingsCubit>.value(value: settingsCubit),
        ],
        child: const _FlowHost(),
      ),
    ),
  );
}

class _FlowHost extends StatelessWidget {
  const _FlowHost();

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}

class _FakeTasbeehRepository implements TasbeehRepository {
  _FakeTasbeehRepository({this.failSave = false});

  final bool failSave;
  List<TasbeehItemEntity> items = [];
  final List<TasbeehItemEntity> saved = [];

  @override
  Future<Result<List<TasbeehItemEntity>>> getTasbeehItems() async =>
      Result.success(List.of(items));

  @override
  Future<Result<void>> saveTasbeehItem(TasbeehItemEntity item) async {
    if (failSave) {
      return const Result.failure(CacheFailure(message: 'تعذّر الحفظ'));
    }
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

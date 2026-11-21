import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/error/failure.dart';
import 'package:sana/core/error/result.dart';
import 'package:sana/core/widgets/buttons/app_text_button.dart';
import 'package:sana/features/azkar/domain/entities/tasbeeh_item_entity.dart';
import 'package:sana/features/azkar/domain/repositories/tasbeeh_repository.dart';
import 'package:sana/features/azkar/domain/use_cases/delete_tasbeeh_item_use_case.dart';
import 'package:sana/features/azkar/domain/use_cases/get_tasbeeh_items_use_case.dart';
import 'package:sana/features/azkar/domain/use_cases/save_tasbeeh_item_use_case.dart';
import 'package:sana/features/azkar/presentation/cubits/azkar_tasbeeh_settings/azkar_tasbeeh_settings_cubit.dart';
import 'package:sana/features/azkar/presentation/cubits/tasbeeh/tasbeeh_cubit.dart';
import 'package:sana/features/azkar/presentation/cubits/tasbeeh/tasbeeh_state.dart';
import 'package:sana/features/azkar/presentation/utils/tasbeeh_actions_flow.dart';
import 'package:sana/features/azkar/presentation/widgets/common/tasbeeh_item_form_bottom_sheet.dart';
import 'package:sana/features/azkar/presentation/widgets/common/tasbeeh_options_bottom_sheet.dart';
import 'package:toastification/toastification.dart';

import '../widgets/azkar_widget_test_harness.dart';

void main() {
  group('TasbeehActionsFlow', () {
    group('openAdd', () {
      testWidgets('saves the submitted form and returns the new selected id', (
        tester,
      ) async {
        final setup = await _setup(tester);

        final future = TasbeehActionsFlow.openAdd(setup.context, setup.cubit);
        await tester.pumpAndSettle();
        expect(find.byType(TasbeehItemFormBottomSheet), findsOneWidget);

        await _fillForm(tester, text: 'سبحان الله', count: '33');
        final id = await future;

        expect(setup.repository.saved, hasLength(1));
        expect(id, setup.repository.saved.single.id);
        expect(setup.repository.saved.single.text, 'سبحان الله');
        expect(setup.repository.saved.single.targetCount, 33);
        final state = setup.cubit.state as TasbeehLoaded;
        expect(state.selectedItemId, id);
      });

      testWidgets('returns null and shows an error toast when saving fails', (
        tester,
      ) async {
        final setup = await _setup(
          tester,
          failSave: true,
          failSaveMessage: 'فشل حفظ السبحة',
        );

        final future = TasbeehActionsFlow.openAdd(setup.context, setup.cubit);
        await tester.pumpAndSettle();
        await _fillForm(tester, text: 'سبحان الله');
        final id = await future;
        await tester.pumpAndSettle();

        expect(id, isNull);
        expect(setup.repository.saved, isEmpty);
        expect(find.text('فشل حفظ السبحة'), findsOneWidget);
        await tester.pump(const Duration(seconds: 3));
      });

      testWidgets('returns null and saves nothing when the form is dismissed', (
        tester,
      ) async {
        final setup = await _setup(tester);

        final future = TasbeehActionsFlow.openAdd(setup.context, setup.cubit);
        await tester.pumpAndSettle();
        await _dismissSheet(tester);

        expect(await future, isNull);
        expect(setup.repository.saved, isEmpty);
        expect(setup.cubit.state, isA<TasbeehInitial>());
      });

      testWidgets('rejects a text that duplicates only after whitespace '
          'normalization', (tester) async {
        final setup = await _setup(
          tester,
          items: [_item('a', 'الحمد   لله')],
          loaded: true,
        );

        final future = TasbeehActionsFlow.openAdd(setup.context, setup.cubit);
        await tester.pumpAndSettle();
        final field = _formFields(tester).first;
        await tester.enterText(field, 'الحمد لله');
        await tester.pump();

        // _existingTexts collapses the stored whitespace, so the duplicate
        // validator disables saving.
        expect(_saveButton(tester).onPressed, isNull);

        // Clear the field so the unsaved-changes guard lets the sheet close.
        await tester.enterText(field, '');
        await tester.pump();
        await _dismissSheet(tester);
        expect(await future, isNull);
        expect(setup.repository.saved, isEmpty);
      });
    });

    group('addPreset', () {
      testWidgets('adds a preset item and returns the selected item id', (
        tester,
      ) async {
        final setup = await _setup(tester);

        final id = await TasbeehActionsFlow.addPreset(
          setup.context,
          setup.cubit,
          'سبحان الله',
        );
        await tester.pump();

        expect(id, isNotNull);
        expect(id, setup.repository.saved.single.id);
        expect(setup.repository.saved.single.text, 'سبحان الله');
        final state = setup.cubit.state as TasbeehLoaded;
        expect(state.selectedItemId, id);
        await tester.pump(const Duration(seconds: 3));
      });

      testWidgets('shows an error toast and returns null when adding fails', (
        tester,
      ) async {
        final setup = await _setup(
          tester,
          failSave: true,
          failSaveMessage: 'تعذّر الحفظ',
        );

        final id = await TasbeehActionsFlow.addPreset(
          setup.context,
          setup.cubit,
          'سبحان الله',
        );
        await tester.pumpAndSettle();

        expect(id, isNull);
        expect(setup.repository.saved, isEmpty);
        expect(find.text('تعذّر الحفظ'), findsOneWidget);
        await tester.pump(const Duration(seconds: 3));
      });

      testWidgets('selects an existing item with whitespace-normalized text '
          'without saving a duplicate', (tester) async {
        final existing = _item('existing', '  سبحان   الله  ');
        final setup = await _setup(
          tester,
          items: [existing],
          loaded: true,
        );

        final id = await TasbeehActionsFlow.addPreset(
          setup.context,
          setup.cubit,
          'سبحان الله',
        );
        await tester.pumpAndSettle();

        expect(id, 'existing');
        expect(setup.repository.saved, isEmpty);
        expect(
          (setup.cubit.state as TasbeehLoaded).selectedItemId,
          'existing',
        );
      });

      testWidgets('adds a preset even when the state is not loaded', (
        tester,
      ) async {
        final setup = await _setup(tester);
        setup.cubit.forceState(TasbeehLoading());

        final id = await TasbeehActionsFlow.addPreset(
          setup.context,
          setup.cubit,
          'سبحان الله',
        );
        await tester.pumpAndSettle();

        expect(id, setup.repository.saved.single.id);
        expect(setup.repository.saved.single.text, 'سبحان الله');
        expect(
          (setup.cubit.state as TasbeehLoaded).selectedItemId,
          id,
        );
      });
    });

    group('openOptions', () {
      testWidgets('returns without action when cubit is not loaded and add '
          'sheet is dismissed', (tester) async {
        final setup = await _setup(tester);
        var addedId = 'sentinel';

        final future = TasbeehActionsFlow.openOptions(
          setup.context,
          setup.cubit,
          showReadingSettings: true,
          onAdded: (id) async => addedId = id ?? 'null',
        );
        await tester.pumpAndSettle();
        await _dismissSheet(tester);
        await future;

        expect(addedId, 'sentinel');
        expect(setup.repository.saved, isEmpty);
      });

      testWidgets('adds an item for a not-loaded state and forwards its id to '
          'onAdded', (tester) async {
        final setup = await _setup(tester);
        String? addedId;

        final future = TasbeehActionsFlow.openOptions(
          setup.context,
          setup.cubit,
          showReadingSettings: false,
          onAdded: (id) async => addedId = id,
        );
        await tester.pumpAndSettle();
        expect(find.byType(TasbeehItemFormBottomSheet), findsOneWidget);

        await _fillForm(tester, text: 'سبحان الله');
        await future;

        expect(addedId, setup.repository.saved.single.id);
        expect(setup.repository.saved.single.text, 'سبحان الله');
      });

      testWidgets('does nothing when the options sheet is dismissed', (
        tester,
      ) async {
        final item = _item('a', 'سبحان الله');
        final setup = await _setup(tester, items: [item], loaded: true);
        final selected = <String>[];
        final added = <String?>[];

        final future = TasbeehActionsFlow.openOptions(
          setup.context,
          setup.cubit,
          showReadingSettings: false,
          onSelect: (id) async => selected.add(id),
          onAdded: (id) async => added.add(id),
        );
        await tester.pumpAndSettle();
        expect(find.byType(TasbeehOptionsBottomSheet), findsOneWidget);

        await _dismissSheet(tester);
        await future;

        expect(selected, isEmpty);
        expect(added, isEmpty);
        expect(setup.repository.saved, isEmpty);
      });

      testWidgets('font size opens settings and reopens options on go back', (
        tester,
      ) async {
        final item = _item('a', 'سبحان الله');
        final setup = await _setup(tester, items: [item], loaded: true);
        final selected = <String>[];

        final future = TasbeehActionsFlow.openOptions(
          setup.context,
          setup.cubit,
          showReadingSettings: true,
          onSelect: (id) async => selected.add(id),
        );
        await tester.pumpAndSettle();

        // The settings action is routed through the flow; pop the sheet with
        // that result to exercise the routing branch.
        _popOption(
          tester,
          (action: TasbeehOption.fontSize, selectedItemId: null),
        );
        await tester.pumpAndSettle();
        expect(find.byTooltip(AppStrings.back), findsOneWidget);
        expect(find.text(AppStrings.tasbeehListTitle), findsNothing);

        await tester.tap(find.byTooltip(AppStrings.back));
        await tester.pumpAndSettle();
        expect(find.byType(TasbeehOptionsBottomSheet), findsOneWidget);
        expect(find.text(AppStrings.tasbeehListTitle), findsOneWidget);

        // The reopened sheet still has the original callbacks wired.
        await tester.tap(find.text(item.text));
        await tester.pumpAndSettle();
        await future;
        expect(selected, [item.id]);
      });

      testWidgets('create opens the add form and forwards the new id', (
        tester,
      ) async {
        final item = _item('a', 'سبحان الله');
        final setup = await _setup(tester, items: [item], loaded: true);
        final added = <String?>[];

        final future = TasbeehActionsFlow.openOptions(
          setup.context,
          setup.cubit,
          showReadingSettings: false,
          onAdded: (id) async => added.add(id),
        );
        await tester.pumpAndSettle();

        _popOption(
          tester,
          (action: TasbeehOption.create, selectedItemId: null),
        );
        await tester.pumpAndSettle();
        expect(find.byType(TasbeehItemFormBottomSheet), findsOneWidget);

        await _fillForm(tester, text: 'الحمد لله');
        await future;

        expect(added, [setup.repository.saved.single.id]);
        expect(setup.repository.saved.single.text, 'الحمد لله');
      });

      testWidgets('select forwards the tapped item id', (tester) async {
        final item = _item('a', 'سبحان الله');
        final setup = await _setup(tester, items: [item], loaded: true);
        final selected = <String>[];

        final future = TasbeehActionsFlow.openOptions(
          setup.context,
          setup.cubit,
          showReadingSettings: false,
          onSelect: (id) async => selected.add(id),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.text(item.text));
        await tester.pumpAndSettle();
        await future;

        expect(selected, [item.id]);
      });

      testWidgets('select with a missing id does not call onSelect', (
        tester,
      ) async {
        final item = _item('a', 'سبحان الله');
        final setup = await _setup(tester, items: [item], loaded: true);
        final selected = <String>[];

        final future = TasbeehActionsFlow.openOptions(
          setup.context,
          setup.cubit,
          showReadingSettings: false,
          onSelect: (id) async => selected.add(id),
        );
        await tester.pumpAndSettle();

        _popOption(
          tester,
          (action: TasbeehOption.select, selectedItemId: null),
        );
        await tester.pumpAndSettle();
        await future;

        expect(selected, isEmpty);
      });

      testWidgets('edit saves the updated item', (tester) async {
        final item = _item('a', 'سبحان الله', targetCount: 33);
        final setup = await _setup(tester, items: [item], loaded: true);

        final future = TasbeehActionsFlow.openOptions(
          setup.context,
          setup.cubit,
          showReadingSettings: false,
        );
        await tester.pumpAndSettle();
        await tester.tap(find.byTooltip(AppStrings.editTasbeeh));
        await tester.pumpAndSettle();
        expect(find.byType(TasbeehItemFormBottomSheet), findsOneWidget);

        await _fillForm(tester, text: 'الحمد لله', count: '44');
        await future;

        final saved = setup.repository.saved.single;
        expect(saved.id, 'a');
        expect(saved.text, 'الحمد لله');
        expect(saved.targetCount, 44);
        expect(
          (setup.cubit.state as TasbeehLoaded).items.single.text,
          'الحمد لله',
        );
      });

      testWidgets('edit shows an error toast when the save fails', (
        tester,
      ) async {
        final item = _item('a', 'سبحان الله');
        final setup = await _setup(
          tester,
          items: [item],
          loaded: true,
          failSave: true,
          failSaveMessage: 'تعذّر تعديل السبحة',
        );

        final future = TasbeehActionsFlow.openOptions(
          setup.context,
          setup.cubit,
          showReadingSettings: false,
        );
        await tester.pumpAndSettle();
        await tester.tap(find.byTooltip(AppStrings.editTasbeeh));
        await tester.pumpAndSettle();
        await _fillForm(tester, text: 'الحمد لله');
        await future;
        await tester.pumpAndSettle();

        expect(setup.repository.saved, isEmpty);
        expect(find.text('تعذّر تعديل السبحة'), findsOneWidget);
        expect(
          (setup.cubit.state as TasbeehLoaded).items.single.text,
          'سبحان الله',
        );
        await tester.pump(const Duration(seconds: 3));
      });

      testWidgets('edit excludes the edited item text from duplicate checks', (
        tester,
      ) async {
        final item = _item('a', 'سبحان  الله');
        final setup = await _setup(tester, items: [item], loaded: true);

        final future = TasbeehActionsFlow.openOptions(
          setup.context,
          setup.cubit,
          showReadingSettings: false,
        );
        await tester.pumpAndSettle();
        await tester.tap(find.byTooltip(AppStrings.editTasbeeh));
        await tester.pumpAndSettle();

        // Saving the unchanged text is allowed because its own id is excluded
        // from existingTexts, and the cubit normalizes the whitespace on save.
        expect(_saveButton(tester).onPressed, isNotNull);
        await tester.tap(_saveButtonFinder());
        await tester.pumpAndSettle();
        await future;

        expect(setup.repository.saved.single.id, 'a');
        expect(setup.repository.saved.single.text, 'سبحان الله');
      });

      testWidgets('ignores edit/delete with missing id, missing item or stale '
          'state', (tester) async {
        final item = _item('a', 'سبحان الله');
        final setup = await _setup(tester, items: [item], loaded: true);

        Future<void> openAndCheck(
          TasbeehOptionResult result, {
          bool stale = false,
        }) async {
          final future = TasbeehActionsFlow.openOptions(
            setup.context,
            setup.cubit,
            showReadingSettings: false,
          );
          await tester.pumpAndSettle();
          if (stale) setup.cubit.forceState(TasbeehLoading());
          _popOption(tester, result);
          await tester.pumpAndSettle();
          await future;

          expect(find.byType(TasbeehItemFormBottomSheet), findsNothing);
          expect(
            find.text(AppStrings.deleteTasbeehDialogTitle),
            findsNothing,
          );
          if (stale) await setup.cubit.loadItems();
        }

        await openAndCheck((action: TasbeehOption.edit, selectedItemId: null));
        await openAndCheck((action: TasbeehOption.delete, selectedItemId: null));
        await openAndCheck(
          (action: TasbeehOption.edit, selectedItemId: 'missing'),
        );
        await openAndCheck(
          (action: TasbeehOption.delete, selectedItemId: 'missing'),
        );
        await openAndCheck(
          (action: TasbeehOption.edit, selectedItemId: item.id),
          stale: true,
        );
        await openAndCheck(
          (action: TasbeehOption.delete, selectedItemId: item.id),
          stale: true,
        );

        expect(setup.repository.items, hasLength(1));
        expect(setup.repository.saved, isEmpty);
      });

      testWidgets('deletes the item after the confirmation is accepted', (
        tester,
      ) async {
        final item = _item('a', 'سبحان الله');
        final setup = await _setup(tester, items: [item], loaded: true);

        final future = TasbeehActionsFlow.openOptions(
          setup.context,
          setup.cubit,
          showReadingSettings: false,
        );
        await tester.pumpAndSettle();
        await tester.tap(find.byTooltip(AppStrings.deleteTasbeeh));
        await tester.pumpAndSettle();
        expect(find.text(AppStrings.deleteTasbeehDialogTitle), findsOneWidget);

        await tester.tap(find.text(AppStrings.delete));
        await tester.pumpAndSettle();
        await future;

        expect(setup.repository.items, isEmpty);
        expect((setup.cubit.state as TasbeehLoaded).items, isEmpty);
      });

      testWidgets('shows an error toast when deleting fails', (tester) async {
        final item = _item('a', 'سبحان الله');
        final setup = await _setup(
          tester,
          items: [item],
          loaded: true,
          failDelete: true,
          failDeleteMessage: 'تعذّر حذف السبحة',
        );

        final future = TasbeehActionsFlow.openOptions(
          setup.context,
          setup.cubit,
          showReadingSettings: false,
        );
        await tester.pumpAndSettle();
        await tester.tap(find.byTooltip(AppStrings.deleteTasbeeh));
        await tester.pumpAndSettle();
        await tester.tap(find.text(AppStrings.delete));
        await tester.pumpAndSettle();
        await future;
        await tester.pumpAndSettle();

        expect(find.text('تعذّر حذف السبحة'), findsOneWidget);
        expect(setup.repository.items, hasLength(1));
        expect(
          (setup.cubit.state as TasbeehLoaded).items,
          hasLength(1),
        );
        await tester.pump(const Duration(seconds: 3));
      });
    });
  });
}

TasbeehItemEntity _item(
  String id,
  String text, {
  int? targetCount,
}) => TasbeehItemEntity(
  id: id,
  text: text,
  currentCount: 0,
  targetCount: targetCount,
  lastUsedAt: DateTime(2026),
);

Future<_Setup> _setup(
  WidgetTester tester, {
  List<TasbeehItemEntity> items = const [],
  bool loaded = false,
  bool failSave = false,
  String failSaveMessage = 'تعذّر الحفظ',
  bool failDelete = false,
  String failDeleteMessage = 'تعذّر الحذف',
}) async {
  final repository = _FakeTasbeehRepository(
    items: items,
    failSave: failSave,
    failSaveMessage: failSaveMessage,
    failDelete: failDelete,
    failDeleteMessage: failDeleteMessage,
  );
  final cubit = _cubit(repository);
  if (loaded) await cubit.loadItems();
  final settings = await createLoadedSettingsCubit();
  await _pumpHost(tester, cubit: cubit, settingsCubit: settings);
  return _Setup(repository, cubit, tester.element(find.byType(_FlowHost)));
}

_SpyTasbeehCubit _cubit(_FakeTasbeehRepository repository) =>
    _SpyTasbeehCubit(
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

Future<void> _fillForm(
  WidgetTester tester, {
  required String text,
  String? count,
}) async {
  final fields = _formFields(tester);
  await tester.enterText(fields.first, text);
  if (count != null) await tester.enterText(fields.last, count);
  await tester.pump();
  expect(_saveButton(tester).onPressed, isNotNull);
  await tester.tap(_saveButtonFinder());
  await tester.pumpAndSettle();
}

Finder _formFields(WidgetTester tester) => find.descendant(
  of: find.byType(TasbeehItemFormBottomSheet),
  matching: find.byType(TextField),
);

Finder _saveButtonFinder() => find.widgetWithText(AppTextButton, AppStrings.save);

AppTextButton _saveButton(WidgetTester tester) =>
    tester.widget<AppTextButton>(_saveButtonFinder());

Future<void> _dismissSheet(WidgetTester tester) async {
  await tester.tapAt(const Offset(10, 10));
  await tester.pumpAndSettle();
}

void _popOption(WidgetTester tester, TasbeehOptionResult result) {
  final context = tester.element(find.byType(TasbeehOptionsBottomSheet));
  Navigator.of(context).pop(result);
}

class _Setup {
  const _Setup(this.repository, this.cubit, this.context);

  final _FakeTasbeehRepository repository;
  final _SpyTasbeehCubit cubit;
  final BuildContext context;
}

class _FlowHost extends StatelessWidget {
  const _FlowHost();

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}

class _SpyTasbeehCubit extends TasbeehCubit {
  _SpyTasbeehCubit(super.getItems, super.saveItem, super.deleteItem);

  void forceState(TasbeehState state) => emit(state);
}

class _FakeTasbeehRepository implements TasbeehRepository {
  _FakeTasbeehRepository({
    this.failSave = false,
    this.failSaveMessage = 'تعذّر الحفظ',
    this.failDelete = false,
    this.failDeleteMessage = 'تعذّر الحذف',
    List<TasbeehItemEntity>? items,
  }) : items = items ?? [];

  final bool failSave;
  final String failSaveMessage;
  final bool failDelete;
  final String failDeleteMessage;
  List<TasbeehItemEntity> items;
  final List<TasbeehItemEntity> saved = [];

  @override
  Future<Result<List<TasbeehItemEntity>>> getTasbeehItems() async =>
      Result.success(List.of(items));

  @override
  Future<Result<void>> saveTasbeehItem(TasbeehItemEntity item) async {
    if (failSave) {
      return Result.failure(CacheFailure(message: failSaveMessage));
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
    if (failDelete) {
      return Result.failure(CacheFailure(message: failDeleteMessage));
    }
    items = items.where((item) => item.id != id).toList();
    return const Result.success(null);
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/icons/app_icons.dart';
import 'package:sana/features/azkar/domain/entities/zikr_entity.dart';
import 'package:sana/features/azkar/presentation/cubits/azkar_tasbeeh_settings/azkar_tasbeeh_settings_cubit.dart';
import 'package:sana/features/azkar/presentation/widgets/custom_azkar_form/zikr_form_item_tile.dart';
import 'package:sana/features/azkar/presentation/widgets/custom_azkar_form/zikr_reorder_card.dart';
import 'package:sana/features/azkar/presentation/widgets/custom_azkar_form/zikr_reorder_drag_listener.dart';
import 'package:sana/features/azkar/presentation/widgets/custom_azkar_form/zikr_reorder_list.dart';

import 'azkar_widget_test_harness.dart';

void main() {
  group('ZikrReorderList', () {
    testWidgets('renders every item as an editable form tile', (tester) async {
      await _pump(tester, _items());

      expect(find.byType(ZikrFormItemTile), findsNWidgets(3));
      expect(find.text('الأول'), findsOneWidget);
      expect(find.text('الثاني'), findsOneWidget);
      expect(find.text('الثالث'), findsOneWidget);
    });

    testWidgets('edit action reports the index of the tapped tile', (
      tester,
    ) async {
      int? edited;
      await _pump(tester, _items(), onEdit: (index) => edited = index);

      final infos = find.byIcon(AppIcons.info);
      expect(infos, findsNWidgets(3));
      await tester.tap(infos.at(1));
      await tester.pumpAndSettle();
      await tester.tap(find.text(AppStrings.editZikr));
      await tester.pumpAndSettle();

      expect(edited, 1);
    });

    testWidgets('built-in non-added items cannot be deleted', (tester) async {
      var deletes = 0;
      await _pump(
        tester,
        _items(),
        isBuiltIn: true,
        onDelete: (_) => deletes++,
      );

      await tester.tap(find.byIcon(AppIcons.info).first);
      await tester.pumpAndSettle();

      expect(find.text(AppStrings.deleteZikr), findsNothing);
      expect(deletes, 0);
    });

    testWidgets('user-added items in a built-in list can be deleted', (
      tester,
    ) async {
      int? deleted;
      final items = [
        const ZikrEntity(id: 1, text: 'أصلي', count: 1),
        const ZikrEntity(
          id: 2,
          text: 'مضاف',
          count: 1,
          isUserAdded: true,
        ),
      ];
      await _pump(tester, items, isBuiltIn: true, onDelete: (i) => deleted = i);

      await tester.tap(find.byIcon(AppIcons.info).at(1));
      await tester.pumpAndSettle();
      await tester.tap(find.text(AppStrings.deleteZikr));
      await tester.pumpAndSettle();

      expect(deleted, 1);
    });

    testWidgets('a single item cannot be dragged', (tester) async {
      await _pump(tester, [_items().first]);

      final listener = tester.widget<ZikrReorderDragStartListener>(
        find.byType(ZikrReorderDragStartListener),
      );
      expect(listener.enabled, isFalse);
    });

    testWidgets('long press compacts the item and a drop reports the reorder', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(400, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      final settings = await createLoadedSettingsCubit();
      int? from;
      int? to;

      await pumpAzkarSliver(
        tester,
        BlocProvider<AzkarTasbeehSettingsCubit>.value(
          value: settings,
          child: ZikrReorderList(
            items: _items(),
            isBuiltIn: false,
            topInset: 0,
            onEdit: (_) {},
            onDelete: (_) {},
            onReorder: (a, b) {
              from = a;
              to = b;
            },
          ),
        ),
      );

      final gesture = await tester.startGesture(
        tester.getCenter(find.text('الأول')),
      );
      await tester.pump(const Duration(milliseconds: 600));
      await tester.pump();
      expect(find.byType(ZikrReorderCard), findsWidgets);

      await gesture.moveTo(const Offset(200, 700));
      for (var i = 0; i < 10; i++) {
        await tester.pump(const Duration(milliseconds: 50));
      }
      await gesture.up();
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pumpAndSettle();

      expect(from, isNotNull);
      expect(to, isNotNull);
      expect(to, isNot(from));
    });
  });
}

List<ZikrEntity> _items() => const [
  ZikrEntity(id: 1, text: 'الأول', count: 3),
  ZikrEntity(id: 2, text: 'الثاني', count: 3),
  ZikrEntity(id: 3, text: 'الثالث', count: 3),
];

Future<void> _pump(
  WidgetTester tester,
  List<ZikrEntity> items, {
  bool isBuiltIn = false,
  ValueChanged<int>? onEdit,
  ValueChanged<int>? onDelete,
}) async {
  final settings = await createLoadedSettingsCubit();
  await pumpAzkarSliver(
    tester,
    BlocProvider<AzkarTasbeehSettingsCubit>.value(
      value: settings,
      child: ZikrReorderList(
        items: items,
        isBuiltIn: isBuiltIn,
        topInset: 0,
        onEdit: onEdit ?? (_) {},
        onDelete: onDelete ?? (_) {},
        onReorder: (_, _) {},
      ),
    ),
  );
}

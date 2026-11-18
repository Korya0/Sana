import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/theme/icons/app_icons.dart';
import 'package:sana/features/azkar/domain/entities/zikr_entity.dart';
import 'package:sana/features/azkar/presentation/cubits/azkar_tasbeeh_settings/azkar_tasbeeh_settings_cubit.dart';
import 'package:sana/features/azkar/presentation/widgets/custom_azkar_form/zikr_form_item_tile.dart';

import 'azkar_widget_test_harness.dart';

void main() {
  testWidgets('renders the zikr, virtue and footer actions', (tester) async {
    final cubit = await createLoadedSettingsCubit();
    var edits = 0;
    var deletes = 0;

    await pumpAzkarWidget(
      tester,
      BlocProvider<AzkarTasbeehSettingsCubit>.value(
        value: cubit,
        child: ZikrFormItemTile(
          zikr: const ZikrEntity(
            id: 1,
            text: 'سبحان الله',
            description: 'فضل الذكر',
            count: 33,
            isUserAdded: true,
          ),
          onEdit: () => edits++,
          onDelete: () => deletes++,
        ),
      ),
    );

    expect(find.text('سبحان الله'), findsOneWidget);
    expect(find.text('فضل الذكر'), findsOneWidget);
    expect(find.byIcon(AppIcons.edit), findsOneWidget);
    expect(find.byIcon(AppIcons.delete), findsOneWidget);

    await tester.tap(find.byIcon(AppIcons.edit));
    await tester.pumpAndSettle();
    expect(edits, 1);

    await tester.tap(find.byIcon(AppIcons.delete));
    await tester.pumpAndSettle();
    expect(deletes, 1);
  });

  testWidgets('keeps the delete action disabled when onDelete is null', (
    tester,
  ) async {
    final cubit = await createLoadedSettingsCubit();

    await pumpAzkarWidget(
      tester,
      BlocProvider<AzkarTasbeehSettingsCubit>.value(
        value: cubit,
        child: const ZikrFormItemTile(
          zikr: ZikrEntity(id: 1, text: 'سبحان الله', count: 33),
          onEdit: _noop,
        ),
      ),
    );

    expect(find.byIcon(AppIcons.delete), findsOneWidget);
    await tester.tap(find.byIcon(AppIcons.delete));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}

void _noop() {}

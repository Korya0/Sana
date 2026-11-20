import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/icons/app_icons.dart';
import 'package:sana/features/azkar/domain/entities/zikr_entity.dart';
import 'package:sana/features/azkar/presentation/cubits/azkar_tasbeeh_settings/azkar_tasbeeh_settings_cubit.dart';
import 'package:sana/features/azkar/presentation/widgets/custom_azkar_form/custom_azkar_form_items_section.dart';

import 'azkar_widget_test_harness.dart';

void main() {
  testWidgets('renders each zikr and routes edit and delete taps', (
    tester,
  ) async {
    final cubit = await createLoadedSettingsCubit();
    var edited = -1;
    var deleted = -1;

    await pumpAzkarSliver(
      tester,
      BlocProvider<AzkarTasbeehSettingsCubit>.value(
        value: cubit,
        child: CustomAzkarFormItemsSection(
          items: const [
            ZikrEntity(id: 1, text: 'سبحان الله', count: 3),
            ZikrEntity(id: 2, text: 'الحمد لله', count: 3),
          ],
          isBuiltIn: false,
          topInset: 0,
          onEdit: (index) => edited = index,
          onDelete: (index) => deleted = index,
          onReorder: (_, _) {},
        ),
      ),
    );

    // Each zikr renders its text and an info button that hosts its actions.
    expect(find.text('سبحان الله'), findsOneWidget);
    expect(find.text('الحمد لله'), findsOneWidget);
    expect(find.byIcon(AppIcons.info), findsNWidgets(2));

    // Edit/delete live inside the info menu, so no direct icons are shown
    // until the menu is opened.
    expect(find.text(AppStrings.editZikr), findsNothing);
    expect(find.text(AppStrings.deleteZikr), findsNothing);
    expect(find.byIcon(AppIcons.edit), findsNothing);

    // Open the first tile's menu and route its edit action.
    await tester.tap(find.byIcon(AppIcons.info).at(0));
    await tester.pumpAndSettle();
    expect(find.text(AppStrings.editZikr), findsOneWidget);
    expect(find.text(AppStrings.deleteZikr), findsOneWidget);

    await tester.tap(find.text(AppStrings.editZikr));
    await tester.pumpAndSettle();
    expect(edited, 0);
    expect(find.text(AppStrings.editZikr), findsNothing);

    // Open the second tile's menu and route its delete action.
    await tester.tap(find.byIcon(AppIcons.info).at(1));
    await tester.pumpAndSettle();
    expect(find.text(AppStrings.deleteZikr), findsOneWidget);

    await tester.tap(find.text(AppStrings.deleteZikr));
    await tester.pumpAndSettle();
    expect(deleted, 1);
  });
}

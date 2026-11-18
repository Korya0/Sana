import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
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
          onEdit: (index) => edited = index,
          onDelete: (index) => deleted = index,
        ),
      ),
    );

    expect(find.text('سبحان الله'), findsOneWidget);
    expect(find.text('الحمد لله'), findsOneWidget);
    expect(find.byIcon(AppIcons.edit), findsNWidgets(2));
    expect(find.byIcon(AppIcons.delete), findsNWidgets(2));

    await tester.tap(find.byIcon(AppIcons.edit).first);
    await tester.pumpAndSettle();
    expect(edited, 0);

    await tester.tap(find.byIcon(AppIcons.delete).last);
    await tester.pumpAndSettle();
    expect(deleted, 1);
  });
}

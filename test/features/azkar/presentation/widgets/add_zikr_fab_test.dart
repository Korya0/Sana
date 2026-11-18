import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/icons/app_icons.dart';
import 'package:sana/features/azkar/presentation/widgets/custom_azkar_form/add_zikr_fab.dart';

import 'azkar_widget_test_harness.dart';

void main() {
  testWidgets('renders a circular add action and fires on press', (tester) async {
    var pressed = 0;
    await pumpAzkarWidget(
      tester,
      AddZikrFab(onPressed: () => pressed++),
    );

    expect(find.byIcon(AppIcons.add), findsOneWidget);
    expect(find.bySemanticsLabel(AppStrings.addZikr), findsOneWidget);

    await tester.tap(find.byIcon(AppIcons.add));
    await tester.pumpAndSettle();
    expect(pressed, 1);
  });
}

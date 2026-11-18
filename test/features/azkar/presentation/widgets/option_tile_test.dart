import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/icons/app_icons.dart';
import 'package:sana/features/azkar/presentation/widgets/common/option_tile.dart';

import 'azkar_widget_test_harness.dart';

void main() {
  testWidgets('shows the icon and label and fires on press', (tester) async {
    var pressed = 0;
    await pumpAzkarWidget(
      tester,
      OptionTile(
        icon: AppIcons.fontSize,
        label: AppStrings.fontSize,
        onPressed: () => pressed++,
      ),
    );

    expect(find.byIcon(AppIcons.fontSize), findsOneWidget);
    expect(find.text(AppStrings.fontSize), findsOneWidget);

    await tester.tap(find.text(AppStrings.fontSize));
    await tester.pumpAndSettle();
    expect(pressed, 1);
  });

  testWidgets('does nothing when onPressed is null', (tester) async {
    await pumpAzkarWidget(
      tester,
      const OptionTile(
        icon: AppIcons.fontSize,
        label: AppStrings.fontSize,
        onPressed: null,
      ),
    );

    await tester.tap(find.text(AppStrings.fontSize));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}

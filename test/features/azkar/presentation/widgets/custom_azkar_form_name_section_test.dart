import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/icons/app_icons.dart';
import 'package:sana/features/azkar/presentation/widgets/custom_azkar_form/custom_azkar_form_name_section.dart';

import 'azkar_widget_test_harness.dart';

void main() {
  testWidgets('shows the required name field when unlocked', (tester) async {
    final controller = TextEditingController(text: 'أذكاري');
    addTearDown(controller.dispose);

    await pumpAzkarSliver(
      tester,
      CustomAzkarFormNameSection(
        controller: controller,
        isLocked: false,
        validator: (_) => null,
      ),
    );

    expect(find.text(AppStrings.azkarName), findsOneWidget);
    expect(find.text(AppStrings.azkarNameHint), findsOneWidget);
    expect(find.text(AppStrings.requiredFieldMark), findsOneWidget);
    expect(find.byIcon(AppIcons.lock), findsNothing);
  });

  testWidgets('shows the lock icon when the name is locked', (tester) async {
    final controller = TextEditingController(text: 'أذكار الصباح');
    addTearDown(controller.dispose);

    await pumpAzkarSliver(
      tester,
      CustomAzkarFormNameSection(
        controller: controller,
        isLocked: true,
        validator: (_) => null,
      ),
    );

    expect(find.byIcon(AppIcons.lock), findsOneWidget);
  });
}

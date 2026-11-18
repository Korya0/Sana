import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/theme/icons/app_icons.dart';
import 'package:sana/features/azkar/presentation/widgets/common/option_section.dart';

import 'azkar_widget_test_harness.dart';

void main() {
  testWidgets('renders the title, optional leading widget and children', (
    tester,
  ) async {
    await pumpAzkarWidget(
      tester,
      const OptionSection(
        title: 'القسم',
        leading: Icon(AppIcons.back),
        children: [Text('child one'), Text('child two')],
      ),
    );

    expect(find.text('القسم'), findsOneWidget);
    expect(find.byIcon(AppIcons.back), findsOneWidget);
    expect(find.text('child one'), findsOneWidget);
    expect(find.text('child two'), findsOneWidget);
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/widgets/app_gap.dart';
import 'package:sana/core/widgets/dividers/app_divider.dart';
import 'package:sana/core/widgets/overlays/app_sheet_body.dart';

import '../../../features/azkar/presentation/widgets/azkar_widget_test_harness.dart';

void main() {
  group('AppSheetBody', () {
    testWidgets('always provides a bounded scroll path', (tester) async {
      await pumpAzkarWidget(
        tester,
        const AppSheetBody(children: [Text('first'), Text('second')]),
      );

      expect(find.byType(SingleChildScrollView), findsOneWidget);
      final constrained = tester.widget<ConstrainedBox>(
        find.ancestor(
          of: find.byType(SingleChildScrollView),
          matching: find.byType(ConstrainedBox),
        ),
      );
      expect(constrained.constraints.maxHeight, isNotNull);
    });

    testWidgets('puts one divider between real rows and skips AppGap', (
      tester,
    ) async {
      await pumpAzkarWidget(
        tester,
        AppSheetBody(
          children: [const Text('first'), AppGap.h(AppSize.p8), const Text('second')],
        ),
      );

      expect(find.text('first'), findsOneWidget);
      expect(find.text('second'), findsOneWidget);
      expect(find.byType(AppGap), findsOneWidget);
      expect(find.byType(AppDivider), findsOneWidget);
    });
  });
}

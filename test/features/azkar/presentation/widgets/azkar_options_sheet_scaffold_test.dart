import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/features/azkar/presentation/widgets/common/azkar_options_sheet_scaffold.dart';

import 'azkar_widget_test_harness.dart';

void main() {
  testWidgets('pads and stretches its children', (tester) async {
    await pumpAzkarWidget(
      tester,
      const AzkarOptionsSheetScaffold(
        children: [Text('first'), Text('second')],
      ),
    );

    expect(find.text('first'), findsOneWidget);
    expect(find.text('second'), findsOneWidget);

    final padding = tester.widget<Padding>(
      find
          .descendant(
            of: find.byType(AzkarOptionsSheetScaffold),
            matching: find.byType(Padding),
          )
          .first,
    );
    expect(
      padding.padding,
      EdgeInsets.symmetric(horizontal: AppSize.p20, vertical: AppSize.p16),
    );

    final column = tester.widget<Column>(
      find
          .descendant(
            of: find.byType(AzkarOptionsSheetScaffold),
            matching: find.byType(Column),
          )
          .first,
    );
    expect(column.crossAxisAlignment, CrossAxisAlignment.stretch);
  });
}

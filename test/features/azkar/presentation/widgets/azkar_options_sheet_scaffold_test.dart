import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/widgets/dividers/app_divider.dart';
import 'package:sana/core/widgets/overlays/app_sheet_body.dart';
import 'package:sana/features/azkar/presentation/widgets/common/azkar_options_sheet_scaffold.dart';

import 'azkar_widget_test_harness.dart';

void main() {
  testWidgets('renders a titled header, divider and body card', (tester) async {
    await pumpAzkarWidget(
      tester,
      AzkarOptionsSheetScaffold(
        title: 'خيارات',
        onDismiss: () {},
        children: const [Text('first'), Text('second')],
      ),
    );

    expect(find.text('خيارات'), findsOneWidget);
    expect(find.text('first'), findsOneWidget);
    expect(find.text('second'), findsOneWidget);
    expect(find.byType(AppSheetBody), findsOneWidget);
    expect(find.byType(AppDivider), findsWidgets);

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
      EdgeInsetsDirectional.only(start: AppSize.p16, end: AppSize.p16, top: AppSize.p8),
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

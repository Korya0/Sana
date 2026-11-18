import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/theme/app_theme.dart';
import 'package:sana/core/utils/context_extension.dart';
import 'package:sana/core/widgets/dividers/app_divider.dart';

void main() {
  testWidgets('renders a divider using theme and size tokens', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        builder: (context, child) {
          AppSize.init(context);
          return Directionality(
            textDirection: TextDirection.rtl,
            child: child!,
          );
        },
        home: const Scaffold(body: AppDivider()),
      ),
    );

    final divider = tester.widget<Divider>(find.byType(Divider));
    final context = tester.element(find.byType(AppDivider));

    expect(divider.height, AppSize.dividerThickness);
    expect(divider.thickness, AppSize.dividerThickness);
    expect(divider.color, context.color.dividerColor);
  });
}

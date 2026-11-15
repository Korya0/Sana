import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/theme/app_theme.dart';
import 'package:sana/core/theme/icons/app_icons.dart';
import 'package:sana/core/widgets/inputs/app_text_field.dart';

void main() {
  testWidgets(
    'locked field is read-only, non-focusable, and shows the lock icon',
    (tester) async {
      final controller = TextEditingController(text: 'أذكار الصباح');
      addTearDown(controller.dispose);

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
          home: Scaffold(
            body: AppTextField(
              controller: controller,
              isLocked: true,
              trailing: const Icon(AppIcons.lock),
            ),
          ),
        ),
      );

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.readOnly, isTrue);
      expect(textField.canRequestFocus, isFalse);
      expect(find.byIcon(AppIcons.lock), findsOneWidget);
    },
  );
}

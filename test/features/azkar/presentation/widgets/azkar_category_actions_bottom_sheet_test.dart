import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/theme/app_theme.dart';
import 'package:sana/core/widgets/overlays/app_bottom_sheet.dart';
import 'package:sana/features/azkar/presentation/widgets/azkar_categories/azkar_category_actions_bottom_sheet.dart';

void main() {
  testWidgets(
    'category actions sheet wraps its content instead of filling the screen',
    (tester) async {
      await tester.pumpWidget(_app());

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      final screenHeight =
          tester.view.physicalSize.height / tester.view.devicePixelRatio;
      final sheetHeight = tester
          .getSize(find.byType(AzkarCategoryActionsBottomSheet))
          .height;

      expect(sheetHeight, lessThan(screenHeight));
    },
  );
}

Widget _app() => MaterialApp(
  theme: AppTheme.light,
  builder: (context, child) {
    AppSize.init(context);
    return Directionality(textDirection: TextDirection.rtl, child: child!);
  },
  home: Scaffold(
    body: Builder(
      builder: (context) => Center(
        child: TextButton(
          onPressed: () => AppBottomSheet.show<AzkarCategoryAction>(
            context: context,
            child: const AzkarCategoryActionsBottomSheet(isCustom: true),
          ),
          child: const Text('open'),
        ),
      ),
    ),
  ),
);

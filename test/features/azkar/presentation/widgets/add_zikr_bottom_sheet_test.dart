import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/app_theme.dart';
import 'package:sana/features/azkar/presentation/widgets/custom_azkar/add_zikr_bottom_sheet.dart';

void main() {
  testWidgets('closing the add sheet with unsaved text asks for confirmation', (
    tester,
  ) async {
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
          body: AddZikrBottomSheet(
            nextId: () => 1700000000000000,
            onSave: (_) {},
          ),
        ),
      ),
    );

    await tester.enterText(
      find.byType(TextField).first,
      'سبحان الله وبحمده',
    );
    await tester.ensureVisible(find.text(AppStrings.cancel));
    await tester.pumpAndSettle();
    await tester.tap(find.text(AppStrings.cancel));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.unsavedChangesDialogTitle), findsOneWidget);
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/features/azkar/presentation/widgets/common/tasbeeh_chip.dart';

import 'azkar_widget_test_harness.dart';

void main() {
  group('TasbeehChip', () {
    testWidgets('renders its label and calls onPressed when tapped', (
      tester,
    ) async {
      var taps = 0;
      await pumpAzkarWidget(
        tester,
        TasbeehChip(label: 'سبحان الله', onPressed: () => taps++),
      );

      expect(find.text('سبحان الله'), findsOneWidget);

      await tester.tap(find.text('سبحان الله'));
      await tester.pumpAndSettle();

      expect(taps, 1);
    });

    testWidgets('renders the optional icon only when provided', (tester) async {
      await pumpAzkarWidget(
        tester,
        TasbeehChip(label: 'بلا أيقونة', onPressed: () {}),
      );
      expect(find.byIcon(Icons.add), findsNothing);

      await pumpAzkarWidget(
        tester,
        TasbeehChip(label: 'مع أيقونة', icon: Icons.add, onPressed: () {}),
      );
      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('keeps the label on a single ellipsized line', (tester) async {
      await pumpAzkarWidget(
        tester,
        TasbeehChip(label: 'نص طويل جدا', onPressed: () {}),
      );

      final text = tester.widget<Text>(find.text('نص طويل جدا'));
      expect(text.maxLines, AppConstants.maxOneLine);
      expect(text.overflow, TextOverflow.ellipsis);
    });
  });
}

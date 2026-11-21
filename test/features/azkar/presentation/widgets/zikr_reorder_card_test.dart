import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/core/widgets/cards/app_section_card.dart';
import 'package:sana/features/azkar/domain/entities/zikr_entity.dart';
import 'package:sana/features/azkar/presentation/widgets/custom_azkar_form/zikr_reorder_card.dart';

import 'azkar_widget_test_harness.dart';

void main() {
  group('ZikrReorderCard', () {
    testWidgets('renders the zikr text inside a section card', (tester) async {
      await pumpAzkarWidget(
        tester,
        const ZikrReorderCard(
          zikr: ZikrEntity(id: 1, text: 'سبحان الله وبحمده', count: 3),
        ),
      );

      expect(find.text('سبحان الله وبحمده'), findsOneWidget);
      expect(find.byType(AppSectionCard), findsOneWidget);
    });

    testWidgets('clamps long text to two ellipsized lines', (tester) async {
      await pumpAzkarWidget(
        tester,
        ZikrReorderCard(
          zikr: ZikrEntity(id: 1, text: 'ذكر' * 80, count: 1),
        ),
      );

      final text = tester.widget<Text>(find.text('ذكر' * 80));
      expect(text.maxLines, AppConstants.maxTwoLines);
      expect(text.overflow, TextOverflow.ellipsis);
      expect(text.textAlign, TextAlign.start);
    });

    testWidgets('uses a scalable min-height box aligned to the start', (tester) async {
      await pumpAzkarWidget(
        tester,
        const ZikrReorderCard(
          zikr: ZikrEntity(id: 1, text: 'الحمد لله', count: 1),
        ),
      );

      final align = tester.widget<Align>(
        find.descendant(
          of: find.byType(ZikrReorderCard),
          matching: find.byType(Align),
        ),
      );
      expect(align.alignment, AlignmentDirectional.centerStart);

      final box = tester.widget<ConstrainedBox>(
        find
            .descendant(
              of: find.byType(ZikrReorderCard),
              matching: find.byType(ConstrainedBox),
            )
            .first,
      );
      expect(box.constraints.minHeight, greaterThan(0));
    });
  });
}

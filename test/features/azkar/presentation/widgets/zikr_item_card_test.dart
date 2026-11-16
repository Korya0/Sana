import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/app_theme.dart';
import 'package:sana/core/theme/icons/app_icons.dart';
import 'package:sana/core/widgets/buttons/app_icon_button.dart';
import 'package:sana/features/azkar/domain/entities/zikr_entity.dart';
import 'package:sana/features/azkar/presentation/widgets/zikr_list/zikr_card/custom_zikr_badge.dart';
import 'package:sana/features/azkar/presentation/widgets/zikr_list/zikr_card/zikr_item_card.dart';

void main() {
  group('ZikrItemCardContent', () {
    test('wraps each share section without a divider', () {
      expect(
        AppStrings.zikrCopyText(
          categoryTitle: 'أذكار الزواج',
          zikrText: 'اللهم بارك لهما',
          description: 'دعاء للزوجين بالخير',
        ),
        '« أذكار الزواج »\n\n'
        '« اللهم بارك لهما »\n\n'
        '« فضل الذكر: دعاء للزوجين بالخير »',
      );
    });

    test('formatted share text omits an empty virtue section', () {
      expect(
        AppStrings.zikrCopyText(
          categoryTitle: 'أذكار الزواج',
          zikrText: 'اللهم بارك لهما',
          description: '  ',
        ),
        '« أذكار الزواج »\n\n« اللهم بارك لهما »',
      );
    });

    testWidgets('reset is visible and disabled while the counter is zero', (
      tester,
    ) async {
      await _pumpCard(
        tester,
        zikr: const ZikrEntity(id: 1, text: 'سبحان الله', count: 33),
        completedCount: 0,
      );

      final reset = tester.widget<AppIconButton>(
        find.widgetWithIcon(AppIconButton, AppIcons.refresh),
      );
      expect(reset.onPressed, isNull);
    });

    testWidgets('reset is enabled after the first repetition', (tester) async {
      await _pumpCard(
        tester,
        zikr: const ZikrEntity(id: 1, text: 'سبحان الله', count: 33),
        completedCount: 1,
      );

      final reset = tester.widget<AppIconButton>(
        find.widgetWithIcon(AppIconButton, AppIcons.refresh),
      );
      expect(reset.onPressed, isNotNull);
    });

    testWidgets('custom zikr shows the person+ badge', (tester) async {
      await _pumpCard(
        tester,
        zikr: const ZikrEntity(
          id: 2,
          text: 'ذكر مخصص',
          count: 3,
          isUserAdded: true,
        ),
        completedCount: 0,
      );

      expect(find.byType(CustomZikrBadge), findsOneWidget);
    });

    testWidgets('built-in zikr does not show the badge', (tester) async {
      await _pumpCard(
        tester,
        zikr: const ZikrEntity(id: 1, text: 'سبحان الله', count: 33),
        completedCount: 0,
      );

      expect(find.byType(CustomZikrBadge), findsNothing);
    });
  });
}

Future<void> _pumpCard(
  WidgetTester tester, {
  required ZikrEntity zikr,
  required int completedCount,
}) => tester.pumpWidget(
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
      body: SingleChildScrollView(
        child: ZikrItemCardContent(
          zikr: zikr,
          completedCount: completedCount,
          isCompleted: completedCount >= zikr.count,
          fontSize: 20,
          onReset: () {},
        ),
      ),
    ),
  ),
);

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/app_theme.dart';
import 'package:sana/core/theme/icons/app_icons.dart';
import 'package:sana/features/azkar/domain/entities/tasbeeh_item_entity.dart';
import 'package:sana/features/azkar/presentation/widgets/azkar_tasbeeh_home/tasbeeh/tasbeeh_recent_item.dart';
import 'package:sana/features/azkar/presentation/widgets/common/tasbeeh_bead_counter.dart';
import 'package:sana/features/azkar/presentation/widgets/common/tasbeeh_chip.dart';

void main() {
  group('TasbeehRecentItem', () {
    testWidgets('shows the bead gauge, a two-line title and one chip', (
      tester,
    ) async {
      var continued = 0;
      await _pump(
        tester,
        item: _item(targetCount: 100, currentCount: 33),
        onContinue: () => continued++,
      );

      final gauge = tester.widget<TasbeehBeadCounter>(
        find.byType(TasbeehBeadCounter),
      );
      expect(gauge.progress, closeTo(0.33, 0.01));
      expect(gauge.subtitleMaxLines, AppConstants.maxTwoLines);
      expect(gauge.contentTop, isNull);
      expect(gauge.contentBottom, AppSize.p4);
      expect(gauge.onPressed, isNotNull);
      expect(gauge.showTouchCue, isFalse);
      expect(
        tester.getSize(find.byType(TasbeehBeadCounter)).height,
        AppSize.h135,
      );
      expect(find.textContaining('متبقي'), findsNothing);
      expect(find.text(AppStrings.continueCounting), findsOneWidget);
      expect(find.text(AppStrings.allTasbeeh), findsNothing);
      expect(find.byIcon(AppIcons.play), findsOneWidget);
      expect(find.byIcon(AppIcons.arrowForward), findsNothing);
      expect(find.byIcon(AppIcons.list), findsNothing);
      expect(find.byIcon(AppIcons.fingerprint), findsNothing);
      expect(find.byType(TasbeehChip), findsNothing);

      final title = tester.widget<Text>(
        find.text('سبحان الله وبحمده، سبحان الله العظيم'),
      );
      expect(title.maxLines, AppConstants.maxTwoLines);
      expect(title.overflow, TextOverflow.ellipsis);

      await tester.tap(find.text(AppStrings.continueCounting));
      await tester.pump(const Duration(milliseconds: 120));
      expect(continued, 1);
    });

    testWidgets(
      'a free item fills the gauge and never shows a remaining line',
      (
        tester,
      ) async {
        await _pump(tester, item: _item(currentCount: 7));

        final gauge = tester.widget<TasbeehBeadCounter>(
          find.byType(TasbeehBeadCounter),
        );
        expect(gauge.progress, 1);
        expect(find.textContaining('متبقي'), findsNothing);
      },
    );

    testWidgets('a free item at zero leaves the gauge empty', (tester) async {
      await _pump(tester, item: _item(currentCount: 0));

      final gauge = tester.widget<TasbeehBeadCounter>(
        find.byType(TasbeehBeadCounter),
      );
      expect(gauge.progress, 0);
    });

    testWidgets('tapping the gauge triggers continue tasbeeh', (tester) async {
      var continued = 0;
      await _pump(
        tester,
        item: _item(targetCount: 100, currentCount: 33),
        onContinue: () => continued++,
      );

      final gauge = tester.getRect(find.byType(TasbeehBeadCounter));
      await tester.tapAt(Offset(gauge.center.dx, gauge.top + AppSize.p8));
      await tester.pump(const Duration(milliseconds: 120));

      expect(continued, 1);
    });
  });
}

TasbeehItemEntity _item({
  required int currentCount,
  int? targetCount,
}) => TasbeehItemEntity(
  id: '1',
  text: 'سبحان الله وبحمده، سبحان الله العظيم',
  currentCount: currentCount,
  targetCount: targetCount,
  lastUsedAt: DateTime(2026),
);

Future<void> _pump(
  WidgetTester tester, {
  required TasbeehItemEntity item,
  VoidCallback? onContinue,
  VoidCallback? onOpenAll,
  VoidCallback? onCount,
}) async {
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

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
        body: Center(
          child: SizedBox(
            width: 343,
            child: TasbeehRecentItem(
              item: item,
              onContinue: onContinue ?? () {},
              onOpenAll: onOpenAll ?? () {},
              onCount: onCount ?? () {},
            ),
          ),
        ),
      ),
    ),
  );
  await tester.pump();
}

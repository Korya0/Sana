import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/app_theme.dart';
import 'package:sana/core/theme/icons/app_icons.dart';
import 'package:sana/core/widgets/buttons/app_button.dart';
import 'package:sana/features/azkar/domain/entities/tasbeeh_item_entity.dart';
import 'package:sana/features/azkar/presentation/widgets/azkar_tasbeeh_home/tasbeeh/tasbeeh_recent_item.dart';
import 'package:sana/features/azkar/presentation/widgets/common/tasbeeh_bead_counter.dart';

void main() {
  group('TasbeehRecentItem', () {
    testWidgets('shows the bead gauge, a two-line title and two 48 buttons', (
      tester,
    ) async {
      var continued = 0;
      var openedAll = 0;
      await _pump(
        tester,
        item: _item(targetCount: 100, currentCount: 33),
        onContinue: () => continued++,
        onOpenAll: () => openedAll++,
      );

      final gauge = tester.widget<TasbeehBeadCounter>(
        find.byType(TasbeehBeadCounter),
      );
      expect(gauge.progress, closeTo(0.33, 0.01));
      expect(gauge.subtitleMaxLines, AppConstants.maxTwoLines);
      expect(gauge.contentTop, isNull);
      expect(
        tester.getSize(find.byType(TasbeehBeadCounter)).height,
        AppSize.h135,
      );
      expect(find.textContaining('متبقي'), findsNothing);
      expect(find.text(AppStrings.continueTasbeeh), findsOneWidget);
      expect(find.text(AppStrings.allTasbeeh), findsOneWidget);
      expect(find.byIcon(AppIcons.play), findsOneWidget);
      expect(find.byIcon(AppIcons.list), findsOneWidget);

      final title = tester.widget<Text>(
        find.text('سبحان الله وبحمده، سبحان الله العظيم'),
      );
      expect(title.maxLines, AppConstants.maxTwoLines);
      expect(title.overflow, TextOverflow.ellipsis);

      final buttons = find.byType(AppButton);
      expect(buttons, findsNWidgets(2));
      expect(tester.getSize(buttons.at(0)).height, AppSize.h48);
      expect(tester.getSize(buttons.at(1)).height, AppSize.h48);

      await tester.tap(find.text(AppStrings.continueTasbeeh));
      await tester.pump(const Duration(milliseconds: 120));
      expect(continued, 1);
      expect(openedAll, 0);
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

    testWidgets('tapping the gauge counts without continuing', (tester) async {
      var continued = 0;
      var counted = 0;
      await _pump(
        tester,
        item: _item(targetCount: 100, currentCount: 33),
        onContinue: () => continued++,
        onCount: () => counted++,
      );

      await tester.tap(find.byType(TasbeehBeadCounter));
      await tester.pump(const Duration(milliseconds: 120));

      expect(counted, 1);
      expect(continued, 0);
    });

    testWidgets('the all action opens the full list without continuing', (
      tester,
    ) async {
      var continued = 0;
      var openedAll = 0;
      await _pump(
        tester,
        item: _item(targetCount: 100, currentCount: 33),
        onContinue: () => continued++,
        onOpenAll: () => openedAll++,
      );

      await tester.tap(find.text(AppStrings.allTasbeeh));
      await tester.pump(const Duration(milliseconds: 120));

      expect(openedAll, 1);
      expect(continued, 0);
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

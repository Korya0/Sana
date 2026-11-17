import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/app_theme.dart';
import 'package:sana/core/widgets/buttons/app_button.dart';
import 'package:sana/features/azkar/domain/entities/tasbeeh_item_entity.dart';
import 'package:sana/features/azkar/presentation/widgets/azkar_tasbeeh_home/tasbeeh/tasbeeh_recent_item.dart';
import 'package:sana/features/azkar/presentation/widgets/common/tasbeeh_counter_widgets.dart';

void main() {
  group('TasbeehRecentItem', () {
    testWidgets('shows the 64 ring, remaining line and two 48 buttons', (
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

      expect(tester.getSize(find.byType(TasbeehCounter)).width, AppSize.h64);
      expect(
        find.text(AppStrings.remainingCountOfTotal(67, 100)),
        findsOneWidget,
      );
      expect(find.text(AppStrings.continueTasbeeh), findsOneWidget);
      expect(find.text(AppStrings.allTasbeeh), findsOneWidget);

      final buttons = find.byType(AppButton);
      expect(buttons, findsNWidgets(2));
      expect(tester.getSize(buttons.at(0)).height, AppSize.h48);
      expect(tester.getSize(buttons.at(1)).height, AppSize.h48);

      await tester.tap(find.text(AppStrings.continueTasbeeh));
      await tester.pump(const Duration(milliseconds: 120));
      expect(continued, 1);
      expect(openedAll, 0);
    });

    testWidgets('hides the progress line for a free counter', (tester) async {
      await _pump(tester, item: _item(targetCount: null, currentCount: 33));

      expect(find.textContaining('متبقي'), findsNothing);
    });

    testWidgets('does not pulse when animations are disabled', (tester) async {
      await _pump(
        tester,
        item: _item(targetCount: 100, currentCount: 33),
        disableAnimations: true,
      );

      final pulse = tester.widget<ScaleTransition>(
        find.byKey(const ValueKey('tasbeeh_counter_pulse')),
      );
      expect(pulse.scale.value, 1);
      await tester.pump(const Duration(milliseconds: 80));
      expect(pulse.scale.value, 1);
    });

    testWidgets('plays one ring pulse and settles', (tester) async {
      await _pump(tester, item: _item(targetCount: 100, currentCount: 33));

      final pulse = find.byKey(const ValueKey('tasbeeh_counter_pulse'));
      expect(tester.widget<ScaleTransition>(pulse).scale.value, 1);
      await tester.pump(const Duration(milliseconds: 80));
      expect(tester.widget<ScaleTransition>(pulse).scale.value, greaterThan(1));
      await tester.pumpAndSettle();
      expect(tester.widget<ScaleTransition>(pulse).scale.value, 1);
    });
  });
}

TasbeehItemEntity _item({required int? targetCount, required int currentCount}) =>
    TasbeehItemEntity(
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
  bool disableAnimations = false,
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
          child: MediaQuery(
            data: MediaQuery.of(context).copyWith(
              disableAnimations: disableAnimations,
            ),
            child: child!,
          ),
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
            ),
          ),
        ),
      ),
    ),
  );
  await tester.pump();
}

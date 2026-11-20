import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/icons/app_icons.dart';
import 'package:sana/features/azkar/presentation/widgets/common/card_action_menu.dart';

import 'azkar_widget_test_harness.dart';

void main() {
  group('CardActionMenu', () {
    testWidgets('opens count actions and runs decrement, then closes', (
      tester,
    ) async {
      var decrements = 0;
      var resets = 0;
      await pumpAzkarWidget(
        tester,
        CardActionMenu(
          canAdjust: true,
          onDecrement: () => decrements++,
          onReset: () => resets++,
        ),
      );

      await tester.tap(find.byIcon(AppIcons.minus));
      await tester.pumpAndSettle();

      expect(find.byKey(const ValueKey('count_decrement_action')), findsOneWidget);
      expect(find.byKey(const ValueKey('count_reset_action')), findsOneWidget);

      await tester.tap(find.byKey(const ValueKey('count_decrement_action')));
      await tester.pumpAndSettle();

      expect(decrements, 1);
      expect(resets, 0);
      expect(find.byKey(const ValueKey('count_decrement_action')), findsNothing);
    });

    testWidgets('runs reset from the count actions', (tester) async {
      var resets = 0;
      await pumpAzkarWidget(
        tester,
        CardActionMenu(
          canAdjust: true,
          onDecrement: () {},
          onReset: () => resets++,
        ),
      );

      await tester.tap(find.byIcon(AppIcons.minus));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('count_reset_action')));
      await tester.pumpAndSettle();

      expect(resets, 1);
    });

    testWidgets('minus is disabled and shows no menu when cannot adjust', (
      tester,
    ) async {
      var decrements = 0;
      await pumpAzkarWidget(
        tester,
        CardActionMenu(
          canAdjust: false,
          onDecrement: () => decrements++,
          onReset: () {},
        ),
      );

      await tester.tap(find.byIcon(AppIcons.minus));
      await tester.pumpAndSettle();

      expect(decrements, 0);
      expect(find.byKey(const ValueKey('count_decrement_action')), findsNothing);
    });

    testWidgets('hides the count button when showCountActions is false', (
      tester,
    ) async {
      await pumpAzkarWidget(
        tester,
        CardActionMenu(
          canAdjust: true,
          showCountActions: false,
          onDecrement: () {},
          onReset: () {},
        ),
      );

      expect(find.byIcon(AppIcons.minus), findsNothing);
      expect(find.byIcon(AppIcons.info), findsNothing);
    });

    testWidgets('item actions appear from the info button and run callbacks', (
      tester,
    ) async {
      var edits = 0;
      var deletes = 0;
      await pumpAzkarWidget(
        tester,
        CardActionMenu(
          canAdjust: true,
          showCountActions: false,
          onDecrement: () {},
          onReset: () {},
          onEdit: () => edits++,
          onDelete: () => deletes++,
          editLabel: AppStrings.editTasbeeh,
          deleteLabel: AppStrings.deleteTasbeeh,
        ),
      );

      expect(find.text(AppStrings.editTasbeeh), findsNothing);
      expect(find.byIcon(AppIcons.info), findsOneWidget);

      await tester.tap(find.byIcon(AppIcons.info));
      await tester.pumpAndSettle();

      expect(find.text(AppStrings.editTasbeeh), findsOneWidget);
      expect(find.text(AppStrings.deleteTasbeeh), findsOneWidget);

      await tester.tap(find.text(AppStrings.editTasbeeh));
      await tester.pumpAndSettle();
      expect(edits, 1);
      expect(deletes, 0);

      await tester.tap(find.byIcon(AppIcons.info));
      await tester.pumpAndSettle();
      await tester.tap(find.text(AppStrings.deleteTasbeeh));
      await tester.pumpAndSettle();
      expect(deletes, 1);
    });

    testWidgets('info button opens item actions, not count actions', (
      tester,
    ) async {
      await pumpAzkarWidget(
        tester,
        CardActionMenu(
          canAdjust: true,
          onDecrement: () {},
          onReset: () {},
          onEdit: () {},
          editLabel: AppStrings.editTasbeeh,
        ),
      );

      await tester.tap(find.byIcon(AppIcons.info));
      await tester.pumpAndSettle();

      expect(find.byKey(const ValueKey('count_decrement_action')), findsNothing);
      expect(find.text(AppStrings.editTasbeeh), findsOneWidget);
    });

    testWidgets('tapping outside closes the open menu', (tester) async {
      await pumpAzkarWidget(
        tester,
        CardActionMenu(
          canAdjust: true,
          onDecrement: () {},
          onReset: () {},
        ),
      );

      await tester.tap(find.byIcon(AppIcons.minus));
      await tester.pumpAndSettle();
      expect(find.byKey(const ValueKey('count_decrement_action')), findsOneWidget);

      await tester.tapAt(const Offset(1, 1));
      await tester.pumpAndSettle();

      expect(find.byKey(const ValueKey('count_decrement_action')), findsNothing);
    });

    testWidgets('tapping the close button closes the open menu', (
      tester,
    ) async {
      await pumpAzkarWidget(
        tester,
        CardActionMenu(
          canAdjust: true,
          onDecrement: () {},
          onReset: () {},
        ),
      );

      await tester.tap(find.byIcon(AppIcons.minus));
      await tester.pumpAndSettle();
      expect(find.byKey(const ValueKey('count_decrement_action')), findsOneWidget);
      expect(find.byTooltip(AppStrings.close), findsOneWidget);
      expect(find.text(AppStrings.azkarHomeOptions), findsNothing);

      await tester.tap(find.byTooltip(AppStrings.close));
      await tester.pumpAndSettle();

      expect(find.byKey(const ValueKey('count_decrement_action')), findsNothing);
    });

    testWidgets('adapts position upwards when icon is near screen bottom', (
      tester,
    ) async {
      await pumpAzkarWidget(
        tester,
        Align(
          alignment: Alignment.bottomCenter,
          child: CardActionMenu(
            canAdjust: true,
            onDecrement: () {},
            onReset: () {},
          ),
        ),
      );

      final iconBox = tester.renderObject<RenderBox>(find.byIcon(AppIcons.minus));
      final iconTop = iconBox.localToGlobal(Offset.zero).dy;

      await tester.tap(find.byIcon(AppIcons.minus));
      await tester.pumpAndSettle();

      final decrementBox = tester.renderObject<RenderBox>(
        find.byKey(const ValueKey('count_decrement_action')),
      );
      final menuTop = decrementBox.localToGlobal(Offset.zero).dy;

      // Menu should open above the icon when near the bottom
      expect(menuTop, lessThan(iconTop));
    });
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sana/features/azkar/presentation/widgets/custom_azkar_form/zikr_reorder_drag_listener.dart';

import 'azkar_widget_test_harness.dart';

void main() {
  group('ZikrReorderDragStartListener', () {
    testWidgets('arms the index after a long press and reports a started drag', (
      tester,
    ) async {
      int? armedIndex;
      bool? dragStarted;
      await _pumpInsideList(
        tester,
        onArm: (index) async {
          armedIndex = index;
          return true;
        },
        onRelease: (started) => dragStarted = started,
      );

      final gesture = await tester.startGesture(
        tester.getCenter(find.text('item 0')),
      );
      await tester.pump(const Duration(milliseconds: 600));
      await tester.pump();
      await gesture.up();
      await tester.pumpAndSettle();

      expect(armedIndex, 0);
      expect(dragStarted, isTrue);
    });

    testWidgets('reports a rejected arm as a drag that did not start', (
      tester,
    ) async {
      bool? dragStarted;
      await _pumpInsideList(
        tester,
        onArm: (_) async => false,
        onRelease: (started) => dragStarted = started,
      );

      final gesture = await tester.startGesture(
        tester.getCenter(find.text('item 0')),
      );
      await tester.pump(const Duration(milliseconds: 600));
      await tester.pump();
      await gesture.up();
      await tester.pumpAndSettle();

      expect(dragStarted, isFalse);
    });

    testWidgets('moving past the hit slop before the hold rejects the arm', (
      tester,
    ) async {
      var armCalls = 0;
      await _pumpInsideList(
        tester,
        onArm: (_) async {
          armCalls++;
          return true;
        },
        onRelease: (_) {},
      );

      final gesture = await tester.startGesture(
        tester.getCenter(find.text('item 0')),
      );
      await tester.pump(const Duration(milliseconds: 100));
      await gesture.moveTo(const Offset(390, 850));
      await tester.pump(const Duration(milliseconds: 600));
      await gesture.up();
      await tester.pumpAndSettle();

      expect(armCalls, 0);
    });
  });
}

Future<void> _pumpInsideList(
  WidgetTester tester, {
  required Future<bool> Function(int index) onArm,
  required void Function(bool dragStarted) onRelease,
}) async {
  await pumpAzkarSliver(
    tester,
    SliverReorderableList(
      itemCount: 2,
      onReorderItem: (_, _) {},
      itemBuilder: (context, index) => ZikrReorderDragStartListener(
        key: ValueKey(index),
        index: index,
        onArm: onArm,
        onRelease: onRelease,
        child: SizedBox(height: 80, child: Text('item $index')),
      ),
    ),
  );
}

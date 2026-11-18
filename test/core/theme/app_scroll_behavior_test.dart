import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/theme/app_scroll_behavior.dart';

void main() {
  testWidgets('AppScrollBehavior clamps scrolling and drops the edge effect', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: Scaffold()));

    final context = tester.element(find.byType(Scaffold));
    const behavior = AppScrollBehavior();
    const child = SizedBox.shrink();

    expect(behavior.getScrollPhysics(context), isA<ClampingScrollPhysics>());
    expect(
      behavior.buildOverscrollIndicator(
        context,
        child,
        const ScrollableDetails(direction: AxisDirection.down),
      ),
      same(child),
    );
  });
}

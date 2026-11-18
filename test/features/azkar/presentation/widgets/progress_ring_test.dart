import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/features/azkar/presentation/widgets/common/progress_ring.dart';

import 'azkar_widget_test_harness.dart';

void main() {
  testWidgets('uses the design defaults when no size is given', (
    tester,
  ) async {
    await pumpAzkarWidget(
      tester,
      const ProgressRing(value: 0.5, color: Colors.red),
    );

    final indicator = tester.widget<CircularProgressIndicator>(
      find.byType(CircularProgressIndicator),
    );
    expect(indicator.value, 0.5);
    expect(indicator.color, Colors.red);
    expect(indicator.strokeWidth, AppSize.progressStrokeWidth);
    expect(indicator.strokeCap, StrokeCap.butt);

    final size = tester.getSize(find.byType(ProgressRing));
    expect(size.width, AppSize.h56);
    expect(size.height, AppSize.h56);
  });

  testWidgets('honors an explicit dimension and stroke width', (tester) async {
    await pumpAzkarWidget(
      tester,
      const ProgressRing(
        value: 0.25,
        color: Colors.blue,
        dimension: 80,
        strokeWidth: 6,
        strokeCap: StrokeCap.round,
      ),
    );

    final indicator = tester.widget<CircularProgressIndicator>(
      find.byType(CircularProgressIndicator),
    );
    expect(indicator.strokeWidth, 6);
    expect(indicator.strokeCap, StrokeCap.round);
    expect(tester.getSize(find.byType(ProgressRing)).width, 80);
  });
}

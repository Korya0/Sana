import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/utils/context_extension.dart';
import 'package:sana/features/qibla/presentation/widgets/compass/compass_kaaba_icon.dart';

import '../widget_test_harness.dart';

void main() {
  testWidgets('uses neutral color when not facing', (tester) async {
    await pumpQiblaWidget(tester, const CompassKaabaIcon(isFacing: false));

    final context = tester.element(find.byType(CompassKaabaIcon));
    final neutral = context.color.iconNeutral;
    final icon = tester.widget<Icon>(find.byType(Icon));
    final container = tester.widget<Container>(find.byType(Container).first);
    final decoration = container.decoration! as BoxDecoration;
    final border = decoration.border! as Border;

    expect(icon.color, neutral);
    expect(icon.size, AppSize.icon24);
    expect(container.constraints!.maxWidth, AppSize.qiblaKaabaIconSize);
    expect(container.constraints!.maxHeight, AppSize.qiblaKaabaIconSize);
    expect(decoration.shape, BoxShape.circle);
    expect(border.top.color, neutral);
    expect(border.top.width, AppSize.borderWidth * 2);
  });

  testWidgets('uses active color when facing', (tester) async {
    await pumpQiblaWidget(tester, const CompassKaabaIcon(isFacing: false));
    final context = tester.element(find.byType(CompassKaabaIcon));
    final active = context.color.iconBrand;

    await pumpQiblaWidget(tester, const CompassKaabaIcon(isFacing: true));

    final icon = tester.widget<Icon>(find.byType(Icon));
    final container = tester.widget<Container>(find.byType(Container).first);
    final decoration = container.decoration! as BoxDecoration;
    expect(icon.color, active);
    expect((decoration.border! as Border).top.color, active);
  });
}

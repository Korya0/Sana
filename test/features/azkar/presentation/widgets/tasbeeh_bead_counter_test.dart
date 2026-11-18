import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/theme/app_theme.dart';
import 'package:sana/features/azkar/presentation/widgets/common/tasbeeh_bead_counter.dart';

void main() {
  testWidgets('counts up from zero to the saved count', (tester) async {
    await _pump(tester, count: 10);

    expect(find.text('0'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 900));
    expect(find.text('0'), findsNothing);
    expect(find.text('10'), findsNothing);

    await tester.pump(const Duration(milliseconds: 600));

    expect(find.text('10'), findsOneWidget);
    expect(find.text('0'), findsNothing);
  });

  testWidgets('shows the saved count immediately with reduced motion', (
    tester,
  ) async {
    await _pump(tester, count: 10, animationsDisabled: true);

    expect(find.text('10'), findsOneWidget);
  });
}

Future<void> _pump(
  WidgetTester tester, {
  required int count,
  bool animationsDisabled = false,
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
        return MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(disableAnimations: animationsDisabled),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: child!,
          ),
        );
      },
      home: Scaffold(
        body: TasbeehBeadCounter(
          count: count,
          subtitle: 'ذكر',
          progress: 0.3,
          onPressed: () {},
        ),
      ),
    ),
  );
  await tester.pump();
}

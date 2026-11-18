import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/widgets/text/app_marquee_text.dart';

void main() {
  Widget buildTestWidget({
    required String text,
    double width = 80,
    TextDirection textDirection = TextDirection.rtl,
  }) => MaterialApp(
    home: Directionality(
      textDirection: textDirection,
      child: Builder(
        builder: (context) {
          AppSize.init(context);
          return Scaffold(
            body: Center(
              child: SizedBox(
                width: width,
                child: AppMarqueeText(
                  text: text,
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ),
          );
        },
      ),
    ),
  );

  testWidgets('AppMarqueeText renders static text if content fits width', (
    tester,
  ) async {
    await tester.pumpWidget(
      buildTestWidget(text: 'ذكر', width: 300),
    );
    await tester.pumpAndSettle();

    expect(find.text('ذكر'), findsOneWidget);
  });

  testWidgets(
    'AppMarqueeText renders scrolling seamless dual copies when text overflows',
    (tester) async {
      await tester.pumpWidget(
        buildTestWidget(text: 'أذكار الصباح والمساء الطويلة جداً', width: 60),
      );
      await tester.pump();

      // Two copies are in the tree for seamless wrap-around loop
      expect(find.text('أذكار الصباح والمساء الطويلة جداً'), findsNWidgets(2));

      // Advance time for pause and animation
      await tester.pump(const Duration(seconds: 1));
      await tester.pump(const Duration(milliseconds: 500));
    },
  );
}

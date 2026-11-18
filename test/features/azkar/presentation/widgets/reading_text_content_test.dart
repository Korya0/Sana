import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sana/features/azkar/presentation/widgets/common/reading_text_content.dart';

import 'azkar_widget_test_harness.dart';

void main() {
  testWidgets('renders the main text at the requested font size', (
    tester,
  ) async {
    await pumpAzkarWidget(
      tester,
      const ReadingTextContent(text: 'سبحان الله', fontSize: 26),
    );

    final text = tester.widget<Text>(find.text('سبحان الله'));
    expect(text.style?.fontSize, 26);
    expect(text.textAlign, TextAlign.center);
  });

  testWidgets('renders an optional description below the text', (tester) async {
    await pumpAzkarWidget(
      tester,
      const ReadingTextContent(
        text: 'سبحان الله',
        subText: 'فضل الذكر',
        fontSize: 20,
      ),
    );

    expect(find.text('سبحان الله'), findsOneWidget);
    expect(find.text('فضل الذكر'), findsOneWidget);
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/theme/extensions/color_extension.dart';
import 'package:sana/features/azkar/presentation/widgets/zikr_card/zikr_content.dart';

void main() {
  group('ZikrContent', () {
    testWidgets('should display text with center alignment', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData().copyWith(extensions: [MyColors.light]),
          home: const Scaffold(
            body: ZikrContent(text: 'سُبْحَانَ اللَّهِ'),
          ),
        ),
      );

      expect(find.text('سُبْحَانَ اللَّهِ'), findsOneWidget);
    });

    testWidgets('should display subText when provided and not empty', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData().copyWith(extensions: [MyColors.light]),
          home: const Scaffold(
            body: ZikrContent(
              text: 'سُبْحَانَ اللَّهِ',
              subText: 'يقال ثلاث مرات',
            ),
          ),
        ),
      );

      expect(find.text('يقال ثلاث مرات'), findsOneWidget);
    });

    testWidgets('should not display subText when null', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData().copyWith(extensions: [MyColors.light]),
          home: const Scaffold(
            body: ZikrContent(text: 'سُبْحَانَ اللَّهِ'),
          ),
        ),
      );

      expect(find.text('يقال ثلاث مرات'), findsNothing);
    });

    testWidgets('should not display subText when empty', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData().copyWith(extensions: [MyColors.light]),
          home: const Scaffold(
            body: ZikrContent(text: 'سُبْحَانَ اللَّهِ', subText: ''),
          ),
        ),
      );

      expect(find.text(''), findsNothing);
    });

    testWidgets('should apply fontSize', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData().copyWith(extensions: [MyColors.light]),
          home: const Scaffold(
            body: ZikrContent(text: 'نص', fontSize: 24),
          ),
        ),
      );

      final textWidget = tester.widget<Text>(find.text('نص'));
      expect(textWidget.style?.fontSize, 24);
    });
  });

  group('ZikrShareContent', () {
    testWidgets('should display text', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData().copyWith(extensions: [MyColors.light]),
          home: const Scaffold(
            body: ZikrShareContent(text: 'سُبْحَانَ اللَّهِ'),
          ),
        ),
      );

      expect(find.text('سُبْحَانَ اللَّهِ'), findsOneWidget);
    });

    testWidgets('should display subText when provided', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData().copyWith(extensions: [MyColors.light]),
          home: const Scaffold(
            body: ZikrShareContent(
              text: 'سُبْحَانَ اللَّهِ',
              subText: 'وصف الذكر',
            ),
          ),
        ),
      );

      expect(find.text('وصف الذكر'), findsOneWidget);
    });

    testWidgets('should not display subText when null', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData().copyWith(extensions: [MyColors.light]),
          home: const Scaffold(
            body: ZikrShareContent(text: 'سُبْحَانَ اللَّهِ'),
          ),
        ),
      );

      expect(find.text('وصف الذكر'), findsNothing);
    });
  });
}

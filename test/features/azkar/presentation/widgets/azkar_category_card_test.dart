import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/theme/app_theme.dart';
import 'package:sana/core/theme/icons/app_icons.dart';
import 'package:sana/core/widgets/text/app_marquee_text.dart';
import 'package:sana/features/azkar/domain/enums/azkar_category_type.dart';
import 'package:sana/features/azkar/presentation/widgets/azkar_tasbeeh_home/azkar/azkar_category_card.dart';

void main() {
  group('AzkarCategoryCard', () {
    testWidgets('renders the title and a default icon without a type', (
      tester,
    ) async {
      await _pump(tester, title: 'قسمي', onTap: () {});

      expect(find.text('قسمي'), findsOneWidget);
      expect(find.byIcon(AppIcons.adhkar), findsOneWidget);
    });

    testWidgets('uses the icon mapped to a known category type', (
      tester,
    ) async {
      await _pump(
        tester,
        title: 'الصباح',
        type: AzkarCategoryType.morning,
        onTap: () {},
      );

      expect(find.byIcon(AppIcons.morning), findsOneWidget);
      expect(find.byIcon(AppIcons.adhkar), findsNothing);
    });

    testWidgets('uses a 52 circle, a 24 icon and a one-line moving title', (
      tester,
    ) async {
      await _pump(
        tester,
        title: 'أذكار الاستيقاظ',
        type: AzkarCategoryType.morning,
        onTap: () {},
      );

      final icon = tester.widget<Icon>(find.byIcon(AppIcons.morning));
      expect(icon.size, AppSize.icon24);
      expect(find.byType(AppMarqueeText), findsOneWidget);

      final title = tester.widget<Text>(find.text('أذكار الاستيقاظ'));
      expect(title.style?.fontSize, AppSize.f12);
      expect(title.maxLines, 1);

      final surface = tester.getSize(find.byType(DecoratedBox));
      expect(surface.width, AppSize.w52);
      expect(surface.height, AppSize.h52);
    });

    testWidgets('calls onTap and onLongPress', (tester) async {
      var taps = 0;
      var longPresses = 0;
      await _pump(
        tester,
        title: 'الصباح',
        onTap: () => taps++,
        onLongPress: () => longPresses++,
      );

      await tester.tap(find.text('الصباح'));
      await tester.longPress(find.text('الصباح'));

      expect(taps, 1);
      expect(longPresses, 1);
    });
  });
}

Future<void> _pump(
  WidgetTester tester, {
  required String title,
  required VoidCallback onTap,
  AzkarCategoryType? type,
  VoidCallback? onLongPress,
}) => tester.pumpWidget(
  MaterialApp(
    theme: AppTheme.light,
    builder: (context, child) {
      AppSize.init(context);
      return Directionality(textDirection: TextDirection.rtl, child: child!);
    },
    home: Scaffold(
      body: Center(
        child: SizedBox(
          width: 100,
          height: 120,
          child: AzkarCategoryCard(
            title: title,
            type: type,
            onTap: onTap,
            onLongPress: onLongPress,
          ),
        ),
      ),
    ),
  ),
);

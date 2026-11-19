import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/theme/app_theme.dart';
import 'package:sana/features/azkar/domain/entities/azkar_category_entity.dart';
import 'package:sana/features/azkar/presentation/widgets/azkar_tasbeeh_home/azkar/azkar_category_card.dart';
import 'package:sana/features/azkar/presentation/widgets/azkar_tasbeeh_home/azkar/azkar_categories_grid.dart';

void main() {
  group('AzkarCategoriesGrid', () {
    testWidgets('shows category tiles without entrance animation', (
      tester,
    ) async {
      await _pump(tester);

      expect(find.byType(AzkarCategoryCard), findsNWidgets(3));
      expect(find.byType(TweenAnimationBuilder<double>), findsNothing);
      expect(find.byType(AnimatedSwitcher), findsNothing);
    });

    testWidgets('fits the tile content at 360 and 320 widths', (tester) async {
      for (final width in [360.0, 320.0]) {
        await _pump(tester, width: width);
        await tester.pump(const Duration(milliseconds: 100));

        expect(tester.takeException(), isNull);
        final tileHeight = tester
            .getSize(
              find.byType(AzkarCategoryCard).first,
            )
            .height;
        final contentHeight = AppSize.h52 + AppSize.p8 + AppSize.f12 * 1.2;
        expect(tileHeight, greaterThanOrEqualTo(contentHeight));
      }
    });

    testWidgets('renders updated tiles after the list is reloaded', (
      tester,
    ) async {
      await _pump(tester, categories: _categories);

      await _pump(
        tester,
        categories: _categories
            .map(
              (category) => AzkarCategoryEntity(
                key: category.key,
                title: category.title,
                cardTitle: 'جديد ${category.cardTitle}',
              ),
            )
            .toList(),
      );
      await tester.pump();

      // A moving label draws two copies of its text.
      expect(find.text('جديد الصباح'), findsWidgets);
      expect(find.text('جديد المساء'), findsWidgets);
      expect(tester.takeException(), isNull);
    });
  });
}

const _categories = [
  AzkarCategoryEntity(
    key: 'morning',
    title: 'أذكار الصباح',
    cardTitle: 'الصباح',
  ),
  AzkarCategoryEntity(
    key: 'evening',
    title: 'أذكار المساء',
    cardTitle: 'المساء',
  ),
  AzkarCategoryEntity(
    key: 'custom',
    title: 'مخصصة',
    cardTitle: 'مخصصة',
  ),
];

Future<void> _pump(
  WidgetTester tester, {
  double width = 390,
  List<AzkarCategoryEntity> categories = _categories,
}) async {
  tester.view.physicalSize = Size(width, 844);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  await tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.light,
      builder: (context, child) {
        AppSize.init(context);
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child!,
        );
      },
      home: Scaffold(
        body: CustomScrollView(
          slivers: [
            AzkarCategoriesGrid(
              key: const ValueKey('grid'),
              categories: categories,
            ),
          ],
        ),
      ),
    ),
  );
  await tester.pump();
}

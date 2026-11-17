import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/theme/app_theme.dart';
import 'package:sana/features/azkar/domain/entities/azkar_category_entity.dart';
import 'package:sana/features/azkar/presentation/widgets/azkar_tasbeeh_home/azkar/azkar_categories_grid.dart';

void main() {
  group('AzkarCategoriesGrid stagger', () {
    testWidgets('staggers tiles by 40ms once and settles fully visible', (
      tester,
    ) async {
      await _pump(tester);

      expect(_opacityOf(tester, 0), 0);
      expect(_opacityOf(tester, 2), 0);

      await tester.pump(const Duration(milliseconds: 40));
      expect(_opacityOf(tester, 0), greaterThan(0));

      await tester.pumpAndSettle();
      expect(_opacityOf(tester, 0), 1);
      expect(_opacityOf(tester, 1), 1);
      expect(_opacityOf(tester, 2), 1);
    });

    testWidgets('shows every tile immediately when animations are disabled', (
      tester,
    ) async {
      await _pump(tester, disableAnimations: true);

      expect(_opacityOf(tester, 0), 1);
      expect(_opacityOf(tester, 2), 1);
    });

    testWidgets('renders every tile immediately when animate is false', (
      tester,
    ) async {
      await _pump(tester, animate: false);

      expect(_opacityOf(tester, 0), 1);
      expect(_opacityOf(tester, 2), 1);
    });
  });
}

double _opacityOf(WidgetTester tester, int index) => tester
    .widget<Opacity>(find.byKey(ValueKey('azkar_tile_fade_$index')))
    .opacity;

Future<void> _pump(
  WidgetTester tester, {
  bool animate = true,
  bool disableAnimations = false,
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
        return Directionality(
          textDirection: TextDirection.rtl,
          child: MediaQuery(
            data: MediaQuery.of(context).copyWith(
              disableAnimations: disableAnimations,
            ),
            child: child!,
          ),
        );
      },
      home: Scaffold(
        body: CustomScrollView(
          slivers: [
            AzkarCategoriesGrid(
              categories: const [
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
              ],
              animate: animate,
            ),
          ],
        ),
      ),
    ),
  );
  await tester.pump();
}

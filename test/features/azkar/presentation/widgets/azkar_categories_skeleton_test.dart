import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/features/azkar/presentation/widgets/azkar_tasbeeh_home/azkar/azkar_categories_grid.dart';
import 'package:sana/features/azkar/presentation/widgets/azkar_tasbeeh_home/azkar/azkar_categories_skeleton.dart';
import 'package:sana/features/azkar/presentation/widgets/azkar_tasbeeh_home/azkar/azkar_category_card.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'azkar_widget_test_harness.dart';

void main() {
  testWidgets('renders one skeleton card per placeholder category', (
    tester,
  ) async {
    await pumpAzkarSliver(
      tester,
      const AzkarCategoriesSkeleton(),
      size: const Size(400, 1400),
      settle: false,
    );
    await tester.pump();

    expect(find.byType(SliverSkeletonizer), findsOneWidget);
    expect(find.byType(AzkarCategoriesGrid), findsOneWidget);
    expect(
      find.byType(AzkarCategoryCard),
      findsNWidgets(AppConstants.azkarCategorySkeletonCount),
    );
  });
}

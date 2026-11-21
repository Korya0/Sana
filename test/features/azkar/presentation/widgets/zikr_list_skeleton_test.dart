import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/features/azkar/presentation/widgets/zikr_list/zikr_card/zikr_item_card.dart';
import 'package:sana/features/azkar/presentation/widgets/zikr_list/zikr_list_skeleton.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'azkar_widget_test_harness.dart';

void main() {
  testWidgets('renders the configured number of skeleton cards', (
    tester,
  ) async {
    await pumpAzkarSliver(tester, const ZikrListSkeleton(), settle: false);
    await tester.pump();

    expect(find.byType(SliverSkeletonizer), findsOneWidget);
    expect(
      find.byType(ZikrItemCardContent),
      findsNWidgets(AppConstants.azkarListSkeletonCount),
    );
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/widgets/buttons/app_primary_button.dart';
import 'package:sana/features/azkar/presentation/widgets/custom_azkar_list/custom_azkar_category_list_tile.dart';
import 'package:sana/features/azkar/presentation/widgets/custom_azkar_list/custom_azkar_list_skeleton.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'azkar_widget_test_harness.dart';

void main() {
  testWidgets('renders the list skeleton with a create action', (tester) async {
    await pumpAzkarSliver(tester, const CustomAzkarListSkeleton(), settle: false);
    await tester.pump();

    expect(find.byType(SliverSkeletonizer), findsOneWidget);
    expect(
      find.byType(CustomAzkarCategoryListTile),
      findsNWidgets(AppConstants.azkarListSkeletonCount),
    );
    expect(
      find.widgetWithText(AppPrimaryButton, AppStrings.addCustomAzkar),
      findsOneWidget,
    );
  });
}

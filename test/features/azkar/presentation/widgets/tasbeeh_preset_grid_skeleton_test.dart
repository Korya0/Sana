import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/features/azkar/presentation/widgets/common/tasbeeh_preset_grid.dart';
import 'package:sana/features/azkar/presentation/widgets/tasbeeh/tasbeeh_preset_grid_skeleton.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'azkar_widget_test_harness.dart';

void main() {
  testWidgets('shows the intro line and the preset grid inside a skeleton', (
    tester,
  ) async {
    await pumpAzkarWidget(tester, const TasbeehPresetGridSkeleton(), settle: false);
    await tester.pump();

    expect(
      find.byWidgetPredicate((widget) => widget is Skeletonizer),
      findsOneWidget,
    );
    expect(find.text(AppStrings.chooseTasbeehToStart), findsOneWidget);
    expect(find.byType(TasbeehPresetGrid), findsOneWidget);
  });
}

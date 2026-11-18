import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/icons/app_icons.dart';
import 'package:sana/features/azkar/presentation/widgets/common/zikr_badge.dart';

import 'azkar_widget_test_harness.dart';

void main() {
  testWidgets('shows the custom zikr tooltip and icon', (tester) async {
    await pumpAzkarWidget(tester, const ZikrBadge());

    expect(find.byTooltip(AppStrings.customZikr), findsOneWidget);
    expect(find.byIcon(AppIcons.personAdd), findsOneWidget);
  });
}

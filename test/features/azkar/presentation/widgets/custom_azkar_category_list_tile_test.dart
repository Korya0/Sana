import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/icons/app_icons.dart';
import 'package:sana/features/azkar/domain/entities/zikr_entity.dart';
import 'package:sana/features/azkar/domain/entities/custom_category_entity.dart';
import 'package:sana/features/azkar/presentation/widgets/custom_azkar_list/custom_azkar_category_list_tile.dart';

import 'azkar_widget_test_harness.dart';

void main() {
  testWidgets('shows restore for built-in categories', (tester) async {
    var restored = 0;
    await pumpAzkarWidget(
      tester,
      CustomAzkarCategoryListTile(
        category: const CustomCategoryEntity(
          id: 'morning',
          name: 'أذكار الصباح',
          azkar: [ZikrEntity(id: 1, text: 'ذكر', count: 1)],
        ),
        isBuiltIn: true,
        onEdit: _noop,
        onDelete: _noop,
        onRestore: () => restored++,
      ),
    );

    expect(find.text('أذكار الصباح'), findsOneWidget);
    expect(find.text(AppStrings.azkarCountLabel(1)), findsOneWidget);
    expect(find.byIcon(AppIcons.edit), findsOneWidget);
    expect(find.byIcon(AppIcons.refresh), findsOneWidget);
    expect(find.byIcon(AppIcons.delete), findsNothing);

    await tester.tap(find.byIcon(AppIcons.refresh));
    await tester.pumpAndSettle();
    expect(restored, 1);
  });

  testWidgets('shows delete for custom categories', (tester) async {
    var deleted = 0;
    await pumpAzkarWidget(
      tester,
      CustomAzkarCategoryListTile(
        category: const CustomCategoryEntity(
          id: 'custom_1',
          name: 'أذكاري',
          azkar: [],
        ),
        isBuiltIn: false,
        onEdit: _noop,
        onDelete: () => deleted++,
        onRestore: _noop,
      ),
    );

    expect(find.text('أذكاري'), findsOneWidget);
    expect(find.text(AppStrings.azkarCountLabel(0)), findsOneWidget);
    expect(find.byIcon(AppIcons.refresh), findsNothing);
    expect(find.byIcon(AppIcons.delete), findsOneWidget);

    await tester.tap(find.byIcon(AppIcons.delete));
    await tester.pumpAndSettle();
    expect(deleted, 1);
  });
}

void _noop() {}

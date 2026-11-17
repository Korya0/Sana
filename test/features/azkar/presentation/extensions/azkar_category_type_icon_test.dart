import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/theme/icons/app_icons.dart';
import 'package:sana/features/azkar/domain/enums/azkar_category_type.dart';
import 'package:sana/features/azkar/presentation/extensions/azkar_category_type_icon.dart';

void main() {
  group('AzkarCategoryTypeIcon', () {
    test('maps representative types to their icons', () {
      expect(AzkarCategoryType.morning.icon, AppIcons.morning);
      expect(AzkarCategoryType.home.icon, AppIcons.house);
      expect(AzkarCategoryType.travel.icon, AppIcons.travel);
      expect(
        AzkarCategoryType.openingSupplication.icon,
        AppIcons.openingSupplication,
      );
    });

    test('every category has an icon', () {
      for (final type in AzkarCategoryType.values) {
        expect(type.icon, isA<IconData>());
      }
    });
  });
}

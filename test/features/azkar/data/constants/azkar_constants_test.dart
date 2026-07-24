import 'package:flutter_test/flutter_test.dart';
import 'package:sana/features/azkar/data/constants/azkar_constants.dart';

void main() {
  group('AzkarConstants', () {
    test('metadataBoxName should be azkar_metadata_box', () {
      expect(AzkarConstants.metadataBoxName, 'azkar_metadata_box');
    });

    test('categoriesBoxName should be azkar_categories_box', () {
      expect(AzkarConstants.categoriesBoxName, 'azkar_categories_box');
    });

    test('azkarCategoryBoxPrefix should be azkar_category_', () {
      expect(AzkarConstants.azkarCategoryBoxPrefix, 'azkar_category_');
    });

    test('defaultFontSize should be 20', () {
      expect(AzkarConstants.defaultFontSize, 20);
    });

    test('minFontSize should be 12', () {
      expect(AzkarConstants.minFontSize, 12);
    });

    test('maxFontSize should be 28', () {
      expect(AzkarConstants.maxFontSize, 28);
    });

    test('minFontSize < defaultFontSize < maxFontSize', () {
      expect(AzkarConstants.minFontSize, lessThan(AzkarConstants.defaultFontSize));
      expect(AzkarConstants.defaultFontSize, lessThan(AzkarConstants.maxFontSize));
    });
  });
}

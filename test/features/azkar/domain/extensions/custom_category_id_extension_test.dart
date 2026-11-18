import 'package:flutter_test/flutter_test.dart';
import 'package:sana/features/azkar/data/constants/azkar_constants.dart';
import 'package:sana/features/azkar/domain/extensions/custom_category_id_extension.dart';

void main() {
  group('CustomCategoryIdExtension', () {
    test('returns true for ids starting with the custom prefix', () {
      expect('${customCategoryIdPrefix}123'.isCustomCategoryId, isTrue);
      expect('custom_abc'.isCustomCategoryId, isTrue);
    });

    test('returns true for the prefix itself', () {
      expect(customCategoryIdPrefix.isCustomCategoryId, isTrue);
    });

    test('returns false for built-in or unrelated ids', () {
      expect('morning'.isCustomCategoryId, isFalse);
      expect('evening'.isCustomCategoryId, isFalse);
      expect('my_custom_1'.isCustomCategoryId, isFalse);
    });

    test('returns false for an empty id', () {
      expect(''.isCustomCategoryId, isFalse);
    });
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:sana/features/azkar/data/constants/azkar_constants.dart';
import 'package:sana/features/azkar/domain/extensions/custom_category_id_extension.dart';

void main() {
  group('azkar constants', () {
    test('JSON keys keep their persisted values', () {
      expect(azkarIdKey, 'id');
      expect(azkarTextKey, 'text');
      expect(azkarCountKey, 'count');
      expect(azkarDescriptionKey, 'description');
      expect(azkarIsUserAddedKey, 'is_user_added');
      expect(azkarCategoryKey, 'key');
      expect(azkarTitleKey, 'title');
      expect(azkarCardTitleKey, 'card_title');
      expect(azkarNameKey, 'name');
      expect(azkarItemsKey, 'azkar');
      expect(azkarCreatedAtKey, 'created_at');
    });

    test('storage envelope keys and version are stable', () {
      expect(azkarStorageVersionKey, 'version');
      expect(azkarStorageItemsKey, 'items');
      expect(currentCustomAzkarSchemaVersion, 1);
    });

    test('isCustomCategoryId classifies ids by prefix', () {
      expect('custom_1'.isCustomCategoryId, isTrue);
      expect('morning'.isCustomCategoryId, isFalse);
    });
  });
}

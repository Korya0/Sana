import 'package:flutter_test/flutter_test.dart';
import 'package:sana/features/azkar/domain/entities/azkar_category_type.dart';

void main() {
  group('AzkarCategoryType', () {
    test('resolves every enum value from its key', () {
      for (final type in AzkarCategoryType.values) {
        expect(AzkarCategoryType.fromKey(type.key), type);
      }
    });

    test('returns null for a key this build does not know', () {
      expect(AzkarCategoryType.fromKey('future_category'), isNull);
    });
  });
}

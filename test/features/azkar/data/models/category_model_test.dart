import 'package:flutter_test/flutter_test.dart';
import 'package:sana/features/azkar/data/constants/azkar_constants.dart';
import 'package:sana/features/azkar/data/models/azkar_category_model.dart';

void main() {
  group('AzkarCategoryModel', () {
    test('parses key, title and card title', () {
      final model = AzkarCategoryModel.fromJson({
        azkarKeyKey: 'morning',
        azkarTitleKey: 'أذكار الصباح',
        azkarCardTitleKey: 'الصباح',
      });

      expect(model.key, 'morning');
      expect(model.title, 'أذكار الصباح');
      expect(model.cardTitle, 'الصباح');
    });

    test('falls back to the full title when card title is missing', () {
      final model = AzkarCategoryModel.fromJson({
        azkarKeyKey: 'evening',
        azkarTitleKey: 'أذكار المساء',
      });

      expect(model.cardTitle, 'أذكار المساء');
    });
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:sana/features/azkar/data/constants/azkar_constants.dart';
import 'package:sana/features/azkar/data/models/azkar_category_model.dart';

void main() {
  group('AzkarCategoryModel', () {
    test('parses key, title and card title from json', () {
      final model = AzkarCategoryModel.fromJson({
        azkarCategoryKey: 'morning',
        azkarTitleKey: 'أذكار الصباح',
        azkarCardTitleKey: 'الصباح',
      });

      expect(model.key, 'morning');
      expect(model.title, 'أذكار الصباح');
      expect(model.cardTitle, 'الصباح');
    });

    test('falls back to the full title when card title is missing', () {
      final model = AzkarCategoryModel.fromJson({
        azkarCategoryKey: 'evening',
        azkarTitleKey: 'أذكار المساء',
      });

      expect(model.key, 'evening');
      expect(model.title, 'أذكار المساء');
      expect(model.cardTitle, 'أذكار المساء');
    });

    test('falls back to the full title when card title is null', () {
      final model = AzkarCategoryModel.fromJson({
        azkarCategoryKey: 'sleep',
        azkarTitleKey: 'أذكار النوم',
        azkarCardTitleKey: null,
      });

      expect(model.cardTitle, 'أذكار النوم');
    });

    test('can be constructed directly', () {
      const model = AzkarCategoryModel(
        key: 'after_prayer',
        title: 'أذكار بعد الصلاة',
        cardTitle: 'بعد الصلاة',
      );

      expect(model.key, 'after_prayer');
      expect(model.title, 'أذكار بعد الصلاة');
      expect(model.cardTitle, 'بعد الصلاة');
    });
  });
}

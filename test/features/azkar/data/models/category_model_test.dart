import 'package:flutter_test/flutter_test.dart';
import 'package:sana/features/azkar/data/constants/azkar_constants.dart';
import 'package:sana/features/azkar/data/models/azkar_category_model.dart';

void main() {
  group('AzkarCategoryModel', () {
    test('parses key, title and card title', () {
      final model = AzkarCategoryModel.fromJson({
        azkarCategoryKey: 'morning',
        azkarTitleKey: 'Ø£Ø°ÙƒØ§Ø± Ø§Ù„ØµØ¨Ø§Ø­',
        azkarCardTitleKey: 'Ø§Ù„ØµØ¨Ø§Ø­',
      });

      expect(model.key, 'morning');
      expect(model.title, 'Ø£Ø°ÙƒØ§Ø± Ø§Ù„ØµØ¨Ø§Ø­');
      expect(model.cardTitle, 'Ø§Ù„ØµØ¨Ø§Ø­');
    });

    test('falls back to the full title when card title is missing', () {
      final model = AzkarCategoryModel.fromJson({
        azkarCategoryKey: 'evening',
        azkarTitleKey: 'Ø£Ø°ÙƒØ§Ø± Ø§Ù„Ù…Ø³Ø§Ø¡',
      });

      expect(model.cardTitle, 'Ø£Ø°ÙƒØ§Ø± Ø§Ù„Ù…Ø³Ø§Ø¡');
    });
  });
}

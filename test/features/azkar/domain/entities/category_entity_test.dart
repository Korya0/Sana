import 'package:flutter_test/flutter_test.dart';
import 'package:sana/features/azkar/domain/entities/azkar_category_entity.dart';

void main() {
  test('copyWith replaces only the provided fields', () {
    const category = AzkarCategoryEntity(
      key: 'morning',
      title: 'أذكار الصباح',
      cardTitle: 'الصباح',
    );

    final copy = category.copyWith(isModified: true, cardTitle: 'صباح');

    expect(copy.key, 'morning');
    expect(copy.title, 'أذكار الصباح');
    expect(copy.cardTitle, 'صباح');
    expect(copy.isCustom, isFalse);
    expect(copy.isModified, isTrue);
  });
}

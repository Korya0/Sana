import 'package:flutter_test/flutter_test.dart';
import 'package:sana/features/azkar/domain/entities/zikr_entity.dart';
import 'package:sana/features/azkar/domain/extensions/zikr_list_extensions.dart';

void main() {
  const items = [
    ZikrEntity(id: 1, text: 'أ', count: 3),
    ZikrEntity(id: 2, text: 'ب', count: 5),
  ];

  test('finds a zikr by id', () {
    expect(items.byId(2)?.text, 'ب');
  });

  test('returns null for a missing id', () {
    expect(items.byId(99), isNull);
  });

  test('returns null for an empty list', () {
    expect(<ZikrEntity>[].byId(1), isNull);
  });
}

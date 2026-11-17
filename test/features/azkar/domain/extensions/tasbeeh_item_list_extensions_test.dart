import 'package:flutter_test/flutter_test.dart';
import 'package:sana/features/azkar/domain/entities/tasbeeh_item_entity.dart';
import 'package:sana/features/azkar/domain/extensions/tasbeeh_item_list_extensions.dart';

void main() {
  final date = DateTime(2026, 11, 17);
  List<TasbeehItemEntity> items() => [
    TasbeehItemEntity(
      id: 'a',
      text: 'أ',
      currentCount: 0,
      lastUsedAt: date,
    ),
    TasbeehItemEntity(
      id: 'b',
      text: 'ب',
      currentCount: 0,
      lastUsedAt: date,
    ),
  ];

  test('finds an item by id', () {
    expect(items().byId('b')?.text, 'ب');
  });

  test('returns null for a missing id', () {
    expect(items().byId('missing'), isNull);
  });

  test('returns null for an empty list', () {
    expect(<TasbeehItemEntity>[].byId('a'), isNull);
  });
}

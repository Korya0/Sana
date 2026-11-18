import 'package:flutter_test/flutter_test.dart';
import 'package:sana/features/azkar/domain/entities/tasbeeh_item_entity.dart';
import 'package:sana/features/azkar/presentation/cubits/tasbeeh/tasbeeh_state.dart';

void main() {
  final date = DateTime(2026, 11, 17);
  final items = [
    TasbeehItemEntity(
      id: 'a',
      text: 'أ',
      currentCount: 2,
      lastUsedAt: date.subtract(const Duration(days: 2)),
    ),
    TasbeehItemEntity(
      id: 'b',
      text: 'ب',
      currentCount: 4,
      lastUsedAt: date,
    ),
    TasbeehItemEntity(
      id: 'c',
      text: 'ج',
      currentCount: 0,
      lastUsedAt: date.subtract(const Duration(days: 1)),
    ),
  ];

  group('TasbeehLoaded', () {
    test('canResetSelected follows the selected item count', () {
      expect(
        TasbeehLoaded(items: items, selectedItemId: 'b').canResetSelected,
        isTrue,
      );
      expect(
        TasbeehLoaded(items: items, selectedItemId: 'c').canResetSelected,
        isFalse,
      );
      expect(TasbeehLoaded(items: items).canResetSelected, isFalse);
    });

    test('recentItems sorts by lastUsedAt descending', () {
      final state = TasbeehLoaded(items: items);

      expect(state.recentItems.map((e) => e.id), ['b', 'c', 'a']);
    });

    test('copyWith replaces items and can clear selection', () {
      final original = TasbeehLoaded(items: items, selectedItemId: 'b');
      final copy = original.copyWith(
        items: const [],
        selectedItemId: () => null,
      );

      expect(copy.items, isEmpty);
      expect(copy.selectedItemId, isNull);
      expect(original.selectedItemId, 'b');
    });
  });
}

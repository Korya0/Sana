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
    test('selectedIndex resolves the selected id', () {
      final state = TasbeehLoaded(items: items, selectedItemId: 'b');

      expect(state.selectedIndex, 1);
      expect(
        TasbeehLoaded(items: items, selectedItemId: 'missing').selectedIndex,
        isNull,
      );
      expect(TasbeehLoaded(items: items).selectedIndex, isNull);
    });

    test('previousItem and nextItem respect list bounds', () {
      final first = TasbeehLoaded(items: items, selectedItemId: 'a');
      final middle = TasbeehLoaded(items: items, selectedItemId: 'b');
      final last = TasbeehLoaded(items: items, selectedItemId: 'c');

      expect(first.previousItem, isNull);
      expect(first.nextItem?.id, 'b');
      expect(middle.previousItem?.id, 'a');
      expect(middle.nextItem?.id, 'c');
      expect(last.nextItem, isNull);
    });

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

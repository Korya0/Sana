import 'package:flutter_test/flutter_test.dart';
import 'package:sana/features/azkar/domain/entities/zikr_entity.dart';

void main() {
  group('ZikrEntity.canBeDeleted', () {
    test('user-added zikr is deletable regardless of id', () {
      expect(
        const ZikrEntity(
          id: 1,
          text: 'ذكر',
          count: 1,
          isUserAdded: true,
        ).canBeDeleted,
        isTrue,
      );
    });

    test('built-in zikr is not deletable even with a large id', () {
      expect(
        const ZikrEntity(
          id: 100001,
          text: 'ذكر',
          count: 1,
          isUserAdded: false,
        ).canBeDeleted,
        isFalse,
      );
    });
  });

  group('ZikrEntity equality', () {
    test('entities with the same values are equal', () {
      final first = _buildZikr();
      final second = _buildZikr();

      expect(first, second);
      expect(first.hashCode, second.hashCode);
    });

    test('entities with different values are not equal', () {
      final first = _buildZikr();
      final second = _buildZikr(count: 34);

      expect(first, isNot(second));
    });
  });
}

ZikrEntity _buildZikr({int count = 33}) => ZikrEntity(
  id: 1,
  text: 'سبحان الله',
  count: count,
);

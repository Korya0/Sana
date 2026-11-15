import 'package:flutter_test/flutter_test.dart';
import 'package:sana/features/azkar/domain/entities/zikr_entity.dart';

void main() {
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

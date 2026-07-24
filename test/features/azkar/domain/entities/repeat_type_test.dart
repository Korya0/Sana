import 'package:flutter_test/flutter_test.dart';
import 'package:sana/features/azkar/domain/entities/repeat_type.dart';

void main() {
  group('RepeatType', () {
    test('should contain once, daily, custom', () {
      expect(RepeatType.values, contains(RepeatType.once));
      expect(RepeatType.values, contains(RepeatType.daily));
      expect(RepeatType.values, contains(RepeatType.custom));
    });

    test('should have exactly 3 values', () {
      expect(RepeatType.values.length, 3);
    });
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:sana/features/azkar/data/constants/tasbeeh_constants.dart';

void main() {
  group('tasbeeh constants', () {
    test('JSON keys keep their persisted values', () {
      expect(tasbeehIdKey, 'id');
      expect(tasbeehTextKey, 'text');
      expect(tasbeehCurrentCountKey, 'current_count');
      expect(tasbeehTargetCountKey, 'target_count');
      expect(tasbeehLastUsedAtKey, 'last_used_at');
      expect(tasbeehIsCustomKey, 'is_custom');
    });

    test('storage envelope keys and version are stable', () {
      expect(tasbeehStorageVersionKey, 'version');
      expect(tasbeehStorageItemsKey, 'items');
      expect(currentTasbeehSchemaVersion, 1);
    });
  });
}

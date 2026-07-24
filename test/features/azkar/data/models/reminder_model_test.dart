import 'package:flutter_test/flutter_test.dart';
import 'package:sana/features/azkar/data/models/reminder_model.dart';

void main() {
  group('ReminderModel', () {
    test('should create ReminderModel with all required fields', () {
      const model = ReminderModel(
        id: '1',
        azkarId: '2',
        time: '08:00',
        repeatType: 'daily',
        days: [1, 2, 3],
        isEnabled: true,
        timezone: 'Africa/Cairo',
        template: 'morning',
      );

      expect(model.id, '1');
      expect(model.azkarId, '2');
      expect(model.time, '08:00');
      expect(model.repeatType, 'daily');
      expect(model.days, [1, 2, 3]);
      expect(model.isEnabled, true);
      expect(model.timezone, 'Africa/Cairo');
      expect(model.template, 'morning');
    });

    test('typeId should be 1', () {
      expect(ReminderModel.typeId, 1);
    });
  });
}

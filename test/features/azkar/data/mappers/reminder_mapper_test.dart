import 'package:flutter_test/flutter_test.dart';
import 'package:sana/features/azkar/data/mappers/reminder_mapper.dart';
import 'package:sana/features/azkar/data/models/reminder_model.dart';
import 'package:sana/features/azkar/domain/entities/notification_template.dart';
import 'package:sana/features/azkar/domain/entities/reminder_entity.dart';
import 'package:sana/features/azkar/domain/entities/repeat_type.dart';

void main() {
  group('ReminderMapper', () {
    const testModel = ReminderModel(
      id: '1',
      azkarId: '2',
      time: '08:00',
      repeatType: 'daily',
      days: [1, 2, 3],
      isEnabled: true,
      timezone: 'Africa/Cairo',
      template: 'morning',
    );

    ReminderModel modelWithRepeatType(String repeatType) => ReminderModel(
      id: testModel.id,
      azkarId: testModel.azkarId,
      time: testModel.time,
      repeatType: repeatType,
      days: testModel.days,
      isEnabled: testModel.isEnabled,
      timezone: testModel.timezone,
      template: testModel.template,
    );

    ReminderModel modelWithTemplate(String template) => ReminderModel(
      id: testModel.id,
      azkarId: testModel.azkarId,
      time: testModel.time,
      repeatType: testModel.repeatType,
      days: testModel.days,
      isEnabled: testModel.isEnabled,
      timezone: testModel.timezone,
      template: template,
    );

    const testEntity = ReminderEntity(
      id: '1',
      azkarId: '2',
      time: '08:00',
      repeatType: RepeatType.daily,
      days: [1, 2, 3],
      isEnabled: true,
      timezone: 'Africa/Cairo',
      template: NotificationTemplate.morning,
    );

    ReminderEntity entityWithRepeatType(RepeatType type) => ReminderEntity(
      id: testEntity.id,
      azkarId: testEntity.azkarId,
      time: testEntity.time,
      repeatType: type,
      days: testEntity.days,
      isEnabled: testEntity.isEnabled,
      timezone: testEntity.timezone,
      template: testEntity.template,
    );

    ReminderEntity entityWithTemplate(NotificationTemplate template) => ReminderEntity(
      id: testEntity.id,
      azkarId: testEntity.azkarId,
      time: testEntity.time,
      repeatType: testEntity.repeatType,
      days: testEntity.days,
      isEnabled: testEntity.isEnabled,
      timezone: testEntity.timezone,
      template: template,
    );

    group('toEntity()', () {
      test('should convert ReminderModel to ReminderEntity with correct values', () {
        final entity = ReminderMapper.toEntity(testModel);

        expect(entity.id, testModel.id);
        expect(entity.azkarId, testModel.azkarId);
        expect(entity.time, testModel.time);
        expect(entity.days, testModel.days);
        expect(entity.isEnabled, testModel.isEnabled);
        expect(entity.timezone, testModel.timezone);
      });

      test('should convert repeatType String to RepeatType enum (once)', () {
        final entity = ReminderMapper.toEntity(modelWithRepeatType('once'));
        expect(entity.repeatType, RepeatType.once);
      });

      test('should convert repeatType String to RepeatType enum (daily)', () {
        final entity = ReminderMapper.toEntity(modelWithRepeatType('daily'));
        expect(entity.repeatType, RepeatType.daily);
      });

      test('should convert repeatType String to RepeatType enum (custom)', () {
        final entity = ReminderMapper.toEntity(modelWithRepeatType('custom'));
        expect(entity.repeatType, RepeatType.custom);
      });

      test('should fallback to RepeatType.once for unknown repeatType', () {
        final entity = ReminderMapper.toEntity(modelWithRepeatType('unknown'));
        expect(entity.repeatType, RepeatType.once);
      });

      test('should convert template String to NotificationTemplate enum (morning)', () {
        final entity = ReminderMapper.toEntity(modelWithTemplate('morning'));
        expect(entity.template, NotificationTemplate.morning);
      });

      test('should convert template String to NotificationTemplate enum (evening)', () {
        final entity = ReminderMapper.toEntity(modelWithTemplate('evening'));
        expect(entity.template, NotificationTemplate.evening);
      });

      test('should convert template String to NotificationTemplate enum (night)', () {
        final entity = ReminderMapper.toEntity(modelWithTemplate('night'));
        expect(entity.template, NotificationTemplate.night);
      });

      test('should convert template String to NotificationTemplate enum (wakeUp)', () {
        final entity = ReminderMapper.toEntity(modelWithTemplate('wakeUp'));
        expect(entity.template, NotificationTemplate.wakeUp);
      });

      test('should convert template String to NotificationTemplate enum (general)', () {
        final entity = ReminderMapper.toEntity(modelWithTemplate('general'));
        expect(entity.template, NotificationTemplate.general);
      });

      test('should fallback to NotificationTemplate.general for unknown template', () {
        final entity = ReminderMapper.toEntity(modelWithTemplate('unknown'));
        expect(entity.template, NotificationTemplate.general);
      });
    });

    group('toModel()', () {
      test('should convert ReminderEntity to ReminderModel with correct values', () {
        final model = ReminderMapper.toModel(testEntity);

        expect(model.id, testEntity.id);
        expect(model.azkarId, testEntity.azkarId);
        expect(model.time, testEntity.time);
        expect(model.days, testEntity.days);
        expect(model.isEnabled, testEntity.isEnabled);
        expect(model.timezone, testEntity.timezone);
      });

      test('should convert RepeatType enum to String correctly', () {
        expect(ReminderMapper.toModel(entityWithRepeatType(RepeatType.once)).repeatType, 'once');
        expect(ReminderMapper.toModel(entityWithRepeatType(RepeatType.daily)).repeatType, 'daily');
        expect(ReminderMapper.toModel(entityWithRepeatType(RepeatType.custom)).repeatType, 'custom');
      });

      test('should convert NotificationTemplate enum to String correctly', () {
        expect(ReminderMapper.toModel(entityWithTemplate(NotificationTemplate.morning)).template, 'morning');
        expect(ReminderMapper.toModel(entityWithTemplate(NotificationTemplate.evening)).template, 'evening');
        expect(ReminderMapper.toModel(entityWithTemplate(NotificationTemplate.general)).template, 'general');
      });
    });

    group('round-trip', () {
      test('toEntity(toModel(entity)) should produce same entity', () {
        final model = ReminderMapper.toModel(testEntity);
        final entityBack = ReminderMapper.toEntity(model);

        expect(entityBack.id, testEntity.id);
        expect(entityBack.azkarId, testEntity.azkarId);
        expect(entityBack.time, testEntity.time);
        expect(entityBack.repeatType, testEntity.repeatType);
        expect(entityBack.days, testEntity.days);
        expect(entityBack.isEnabled, testEntity.isEnabled);
        expect(entityBack.timezone, testEntity.timezone);
        expect(entityBack.template, testEntity.template);
      });

      test('toModel(toEntity(model)) should produce same model', () {
        final entity = ReminderMapper.toEntity(testModel);
        final modelBack = ReminderMapper.toModel(entity);

        expect(modelBack.id, testModel.id);
        expect(modelBack.azkarId, testModel.azkarId);
        expect(modelBack.time, testModel.time);
        expect(modelBack.repeatType, testModel.repeatType);
        expect(modelBack.days, testModel.days);
        expect(modelBack.isEnabled, testModel.isEnabled);
        expect(modelBack.timezone, testModel.timezone);
        expect(modelBack.template, testModel.template);
      });
    });
  });
}

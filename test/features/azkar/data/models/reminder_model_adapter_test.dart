import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sana/features/azkar/data/models/reminder_model.dart';

class MockBinaryReader extends Mock implements BinaryReader {}
class MockBinaryWriter extends Mock implements BinaryWriter {}

/// Helper to simulate Hive's field-based serialization style.
/// Builds a reader with sequential field-key/value pairs preceded by field count.
BinaryReader _buildReader(List<dynamic> fieldValues) {
  final reader = MockBinaryReader();
  final iterator = fieldValues.iterator;

  when(reader.readByte).thenAnswer((_) {
    iterator.moveNext();
    return iterator.current as int;
  });

  when(reader.read).thenAnswer((_) {
    iterator.moveNext();
    return iterator.current;
  });

  return reader;
}

void main() {
  group('ReminderModelAdapter', () {
    late ReminderModelAdapter adapter;

    setUp(() {
      adapter = ReminderModelAdapter();
    });

    test('typeId should be 1', () {
      expect(adapter.typeId, 1);
    });

    test('read() should deserialize ReminderModel from BinaryReader', () {
      final reader = _buildReader(<dynamic>[
        8,
        0, '1',
        1, '2',
        2, '08:00',
        3, 'daily',
        4, [1, 2, 3],
        5, true,
        6, 'Africa/Cairo',
        7, 'morning',
      ]);

      final model = adapter.read(reader);

      expect(model.id, '1');
      expect(model.azkarId, '2');
      expect(model.time, '08:00');
      expect(model.repeatType, 'daily');
      expect(model.days, [1, 2, 3]);
      expect(model.isEnabled, true);
      expect(model.timezone, 'Africa/Cairo');
      expect(model.template, 'morning');
    });

    test('write() should serialize ReminderModel to BinaryWriter', () {
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
      final writer = MockBinaryWriter();

      adapter.write(writer, model);

      verify(() => writer.writeByte(8)).called(1);
      verify(() => writer.writeByte(0)).called(1);
      verify(() => writer.write('1')).called(1);
      verify(() => writer.writeByte(1)).called(1);
      verify(() => writer.write('2')).called(1);
      verify(() => writer.writeByte(2)).called(1);
      verify(() => writer.write('08:00')).called(1);
      verify(() => writer.writeByte(3)).called(1);
      verify(() => writer.write('daily')).called(1);
      verify(() => writer.writeByte(4)).called(1);
      verify(() => writer.write([1, 2, 3])).called(1);
      verify(() => writer.writeByte(5)).called(1);
      verify(() => writer.write(true)).called(1);
      verify(() => writer.writeByte(6)).called(1);
      verify(() => writer.write('Africa/Cairo')).called(1);
      verify(() => writer.writeByte(7)).called(1);
      verify(() => writer.write('morning')).called(1);
    });

    test('hashCode should return same value for same typeId', () {
      final adapter2 = ReminderModelAdapter();
      expect(adapter.hashCode, adapter2.hashCode);
    });

    test('== should return true for adapters of same type', () {
      final adapter2 = ReminderModelAdapter();
      expect(adapter == adapter2, isTrue);
    });

    test('== should return false for different types', () {
      expect(adapter == Object(), isFalse);
    });
  });
}

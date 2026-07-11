import 'package:hive_flutter/hive_flutter.dart';

class ReminderModel {
  const ReminderModel({
    required this.id,
    required this.azkarId,
    required this.time,
    required this.repeatType,
    required this.days,
    required this.isEnabled,
    required this.timezone,
    required this.template,
  });

  static const int typeId = 1;

  final String id;
  final String azkarId;
  final String time;
  final String repeatType;
  final List<int> days;
  final bool isEnabled;
  final String timezone;
  final String template;
}

class ReminderModelAdapter extends TypeAdapter<ReminderModel> {
  @override
  final int typeId = ReminderModel.typeId;

  @override
  ReminderModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ReminderModel(
      id: fields[0] as String,
      azkarId: fields[1] as String,
      time: fields[2] as String,
      repeatType: fields[3] as String,
      days: (fields[4] as List).cast<int>(),
      isEnabled: fields[5] as bool,
      timezone: fields[6] as String,
      template: fields[7] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ReminderModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.azkarId)
      ..writeByte(2)
      ..write(obj.time)
      ..writeByte(3)
      ..write(obj.repeatType)
      ..writeByte(4)
      ..write(obj.days)
      ..writeByte(5)
      ..write(obj.isEnabled)
      ..writeByte(6)
      ..write(obj.timezone)
      ..writeByte(7)
      ..write(obj.template);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReminderModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prayer_time_status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PrayerTimeStatusImpl _$$PrayerTimeStatusImplFromJson(
  Map<String, dynamic> json,
) => _$PrayerTimeStatusImpl(
  id: json['id'] as String,
  status: json['status'] as String,
  description: json['description'] as String,
  source: json['source'] as String?,
);

Map<String, dynamic> _$$PrayerTimeStatusImplToJson(
  _$PrayerTimeStatusImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'status': instance.status,
  'description': instance.description,
  'source': instance.source,
};

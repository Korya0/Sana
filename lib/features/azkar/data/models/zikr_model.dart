import 'package:sana/features/azkar/constants/azkar_keys.dart';
import 'package:sana/features/azkar/domain/entities/zikr_entity.dart';

class ZikrModel extends ZikrEntity {
  const ZikrModel({
    required super.id,
    required super.text,
    required super.count,
    super.subText,
  });

  factory ZikrModel.fromJson(Map<String, dynamic> json) {
    return ZikrModel(
      id: json[AzkarKeys.id] as int,
      text: json[AzkarKeys.text] as String,
      subText: json[AzkarKeys.subText] as String?,
      count: json[AzkarKeys.count] as int,
    );
  }
}

import 'package:sana/features/azkar/data/constants/azkar_constants.dart';
import 'package:sana/features/azkar/domain/entities/zikr_entity.dart';

class ZikrModel extends ZikrEntity {
  const ZikrModel({
    required super.id,
    required super.text,
    required super.count,
    super.description,
  });

  // Parses zikr JSON
  factory ZikrModel.fromJson(Map<String, dynamic> json) => ZikrModel(
    id: json[azkarIdKey] as int,
    text: json[azkarTextKey] as String,
    count: json[azkarCountKey] as int,
    description: json[azkarDescriptionKey] as String?,
  );
}

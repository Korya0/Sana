import 'package:sana/features/azkar/data/constants/azkar_constants.dart';
import 'package:sana/features/azkar/domain/entities/zikr_entity.dart';

class ZikrModel extends ZikrEntity {
  const ZikrModel({
    required super.id,
    required super.text,
    required super.count,
    super.reference,
    super.description,
  });

  factory ZikrModel.fromJson(Map<String, dynamic> json) {
    return ZikrModel(
      id: json[AzkarConstants.idKey] as int,
      text: json[AzkarConstants.textKey] as String,
      count: json[AzkarConstants.countKey] as int,
      reference: json[AzkarConstants.referenceKey] as String?,
      description: json[AzkarConstants.descriptionKey] as String?,
    );
  }

}

import 'package:sana/features/azkar/data/constants/azkar_constants.dart';
import 'package:sana/features/azkar/domain/entities/zikr_entity.dart';

class ZikrModel extends ZikrEntity {
  const ZikrModel({
    required super.id,
    required super.text,
    required super.count,
    super.description,
    super.isUserAdded,
  });

  // Parses zikr JSON
  factory ZikrModel.fromJson(Map<String, dynamic> json) {
    final id = json[azkarIdKey] as int;
    final isUserAdded =
        (json['is_user_added'] as bool?) ?? (id > 100000);
    return ZikrModel(
      id: id,
      text: json[azkarTextKey] as String,
      count: json[azkarCountKey] as int,
      description: json[azkarDescriptionKey] as String?,
      isUserAdded: isUserAdded,
    );
  }

  // Creates model from domain entity
  factory ZikrModel.fromEntity(ZikrEntity entity) => ZikrModel(
    id: entity.id,
    text: entity.text,
    count: entity.count,
    description: entity.description,
    isUserAdded: entity.isUserAdded,
  );

  // Serializes zikr to JSON
  Map<String, dynamic> toJson() => {
    azkarIdKey: id,
    azkarTextKey: text,
    azkarCountKey: count,
    if (description != null) azkarDescriptionKey: description,
    if (isUserAdded) 'is_user_added': true,
  };
}

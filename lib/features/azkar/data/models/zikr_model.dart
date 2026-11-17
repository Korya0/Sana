import 'package:sana/features/azkar/data/constants/azkar_constants.dart';
import 'package:sana/features/azkar/domain/entities/zikr_entity.dart';

class ZikrModel extends ZikrEntity {
  // Creates model
  const ZikrModel({
    required super.id,
    required super.text,
    required super.count,
    super.description,
    super.isUserAdded,
  });

  // Parses JSON
  factory ZikrModel.fromJson(Map<String, dynamic> json) {
    final isUserAdded = json[azkarIsUserAddedKey] as bool? ?? false;
    return ZikrModel(
      id: json[azkarIdKey] as int,
      text: json[azkarTextKey] as String,
      count: json[azkarCountKey] as int,
      description: json[azkarDescriptionKey] as String?,
      isUserAdded: isUserAdded,
    );
  }

  // Maps entity
  factory ZikrModel.fromEntity(ZikrEntity entity) => ZikrModel(
    id: entity.id,
    text: entity.text,
    count: entity.count,
    description: entity.description,
    isUserAdded: entity.isUserAdded,
  );

  // Serializes JSON
  Map<String, dynamic> toJson() => {
    azkarIdKey: id,
    azkarTextKey: text,
    azkarCountKey: count,
    if (description != null) azkarDescriptionKey: description,
    azkarIsUserAddedKey: isUserAdded,
  };
}

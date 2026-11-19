import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/core/utils/app_validators.dart';
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
    final rawText = json[azkarTextKey];
    final rawDescription = json[azkarDescriptionKey];
    final rawCount = json[azkarCountKey];
    final description = rawDescription is String
        ? AppValidators.collapseWhitespace(rawDescription)
        : '';
    return ZikrModel(
      id: switch (json[azkarIdKey]) {
        final int value => value,
        _ => 0,
      },
      text: rawText is String
          ? AppValidators.collapseWhitespace(rawText)
          : '',
      count: rawCount is int
          ? rawCount.clamp(1, AppConstants.tasbeehMaxCount).toInt()
          : 1,
      description: description.isEmpty ? null : description,
      isUserAdded: json[azkarIsUserAddedKey] as bool? ?? false,
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

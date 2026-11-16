import 'package:sana/features/azkar/data/constants/tasbeeh_constants.dart';
import 'package:sana/features/azkar/domain/entities/tasbeeh_item_entity.dart';

class TasbeehItemModel extends TasbeehItemEntity {
  // Creates model
  const TasbeehItemModel({
    required super.id,
    required super.text,
    required super.currentCount,
    required super.lastUsedAt,
    super.targetCount,
    super.isCustom = true,
  });

  // Maps json
  factory TasbeehItemModel.fromJson(Map<String, dynamic> json) {
    final rawLastUsedAt = json[tasbeehLastUsedAtKey];
    final lastUsedAt = switch (rawLastUsedAt) {
      final String value => DateTime.tryParse(value) ?? DateTime.now(),
      final int value => DateTime.fromMillisecondsSinceEpoch(value),
      _ => DateTime.now(),
    };
    final rawTarget = json[tasbeehTargetCountKey];
    final targetCount = switch (rawTarget) {
      final int value when value > 0 => value,
      _ => null,
    };

    return TasbeehItemModel(
      id: (json[tasbeehIdKey] as String?) ?? '',
      text: (json[tasbeehTextKey] as String?) ?? '',
      currentCount: (json[tasbeehCurrentCountKey] as int?) ?? 0,
      targetCount: targetCount,
      lastUsedAt: lastUsedAt,
      isCustom: (json[tasbeehIsCustomKey] as bool?) ?? true,
    );
  }

  // Maps entity
  factory TasbeehItemModel.fromEntity(TasbeehItemEntity entity) =>
      TasbeehItemModel(
        id: entity.id,
        text: entity.text,
        currentCount: entity.currentCount,
        targetCount: entity.targetCount,
        lastUsedAt: entity.lastUsedAt,
        isCustom: entity.isCustom,
      );

  // Maps json
  Map<String, dynamic> toJson() => {
    tasbeehIdKey: id,
    tasbeehTextKey: text,
    tasbeehCurrentCountKey: currentCount,
    tasbeehTargetCountKey: targetCount,
    tasbeehLastUsedAtKey: lastUsedAt.toIso8601String(),
    tasbeehIsCustomKey: isCustom,
  };
}

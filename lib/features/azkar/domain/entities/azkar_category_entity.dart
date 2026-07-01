import 'package:sana/features/azkar/domain/entities/zikr_entity.dart';

class AzkarCategoryEntity {
  const AzkarCategoryEntity({
    required this.id,
    required this.category,
    required this.array,
  });

  final String id;
  final String category;
  final List<ZikrEntity> array;

  /// Returns the category name without the "أذكار" prefix
  String get shortName {
    return category.replaceFirst(RegExp(r'^(أذكار|اذكار)\s+'), '');
  }

  AzkarCategoryEntity copyWith({
    String? id,
    String? category,
    List<ZikrEntity>? array,
  }) {
    return AzkarCategoryEntity(
      id: id ?? this.id,
      category: category ?? this.category,
      array: array ?? this.array,
    );
  }
}

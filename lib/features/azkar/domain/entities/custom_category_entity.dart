import 'package:sana/features/azkar/domain/entities/azkar_category_entity.dart';
import 'package:sana/features/azkar/domain/entities/zikr_entity.dart';

class CustomCategoryEntity {
  // Creates entity
  const CustomCategoryEntity({
    required this.id,
    required this.name,
    required this.azkar,
    this.createdAt,
  });

  final String id;
  final String name;
  final List<ZikrEntity> azkar;
  final DateTime? createdAt;

  // Copies entity
  CustomCategoryEntity copyWith({
    String? id,
    String? name,
    List<ZikrEntity>? azkar,
    DateTime? createdAt,
  }) => CustomCategoryEntity(
    id: id ?? this.id,
    name: name ?? this.name,
    azkar: azkar ?? this.azkar,
    createdAt: createdAt ?? this.createdAt,
  );

  // Maps category
  AzkarCategoryEntity toCategoryEntity() => AzkarCategoryEntity(
    key: id,
    title: name,
    cardTitle: name,
    isCustom: true,
  );
}

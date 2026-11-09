import 'package:sana/features/azkar/domain/entities/category_entity.dart';
import 'package:sana/features/azkar/domain/entities/zikr_entity.dart';

class CustomCategoryEntity {
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

  CategoryEntity toCategoryEntity() => CategoryEntity(
    key: id,
    title: name,
    cardTitle: name,
    isCustom: true,
  );
}


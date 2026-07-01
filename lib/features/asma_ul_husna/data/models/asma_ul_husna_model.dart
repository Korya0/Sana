import 'package:sana/features/asma_ul_husna/constants/asma_keys.dart';
import 'package:sana/features/asma_ul_husna/domain/entities/asma_ul_husna_entity.dart';

class AsmaUlHusnaModel extends AsmaUlHusnaEntity {
  const AsmaUlHusnaModel({
    required super.id,
    required super.name,
    required super.meaningBrief,
    required super.meaningDetailed,
  });

  factory AsmaUlHusnaModel.fromJson(Map<String, dynamic> json) {
    return AsmaUlHusnaModel(
      id: json[AsmaKeys.id] as int,
      name: json[AsmaKeys.name] as String,
      meaningBrief: json[AsmaKeys.meaningBrief] as String,
      meaningDetailed: json[AsmaKeys.meaningDetailed] as String,
    );
  }
}

import '../../domain/entities/asma_ul_husna.dart';

class AsmaUlHusnaModel extends AsmaUlHusna {
  const AsmaUlHusnaModel({
    required super.id,
    required super.name,
    required super.meaningBrief,
    required super.meaningDetailed,
  });

  factory AsmaUlHusnaModel.fromJson(Map<String, dynamic> json) {
    return AsmaUlHusnaModel(
      id: json['id'] as int,
      name: json['name'] as String,
      meaningBrief: json['meaning_brief'] as String,
      meaningDetailed: json['meaning_detailed'] as String,
    );
  }
}

import 'package:sana/features/asma_ul_husna/constants/asma_keys.dart';

class AsmaulHusnaModel {
  const AsmaulHusnaModel({
    required this.id,
    required this.name,
    required this.meaningBrief,
    required this.meaningDetailed,
  });

  factory AsmaulHusnaModel.fromJson(Map<String, dynamic> json) {
    return AsmaulHusnaModel(
      id: json[AsmaKeys.id] as int,
      name: json[AsmaKeys.name] as String,
      meaningBrief: json[AsmaKeys.meaningBrief] as String,
      meaningDetailed: json[AsmaKeys.meaningDetailed] as String,
    );
  }
  final int id;
  final String name;
  final String meaningBrief;
  final String meaningDetailed;
}

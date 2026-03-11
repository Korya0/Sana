import 'package:equatable/equatable.dart';
import 'package:sana/features/asma_ul_husna/data/constants/asma_keys.dart';

class AsmaulHusnaModel extends Equatable {
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

  Map<String, dynamic> toJson() {
    return {
      AsmaKeys.id: id,
      AsmaKeys.name: name,
      AsmaKeys.meaningBrief: meaningBrief,
      AsmaKeys.meaningDetailed: meaningDetailed,
    };
  }

  @override
  List<Object?> get props => [id, name, meaningBrief, meaningDetailed];
}

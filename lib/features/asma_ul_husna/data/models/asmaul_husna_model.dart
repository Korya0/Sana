import 'package:equatable/equatable.dart';
import 'package:sana/core/constants/json_keys.dart';

class AsmaulHusnaModel extends Equatable {
  const AsmaulHusnaModel({
    required this.id,
    required this.name,
    required this.meaningBrief,
    required this.meaningDetailed,
  });

  factory AsmaulHusnaModel.fromJson(Map<String, dynamic> json) {
    return AsmaulHusnaModel(
      id: json[JsonKeys.id] as int,
      name: json[JsonKeys.name] as String,
      meaningBrief: json[JsonKeys.meaningBrief] as String,
      meaningDetailed: json[JsonKeys.meaningDetailed] as String,
    );
  }
  final int id;
  final String name;
  final String meaningBrief;
  final String meaningDetailed;

  Map<String, dynamic> toJson() {
    return {
      JsonKeys.id: id,
      JsonKeys.name: name,
      JsonKeys.meaningBrief: meaningBrief,
      JsonKeys.meaningDetailed: meaningDetailed,
    };
  }

  @override
  List<Object?> get props => [id, name, meaningBrief, meaningDetailed];
}

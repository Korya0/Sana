import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sana/features/asma_ul_husna/constants/asma_keys.dart';

part 'asmaul_husna_model.freezed.dart';

@freezed
class AsmaulHusnaModel with _$AsmaulHusnaModel {
  const factory AsmaulHusnaModel({
    required int id,
    required String name,
    required String meaningBrief,
    required String meaningDetailed,
  }) = _AsmaulHusnaModel;

  factory AsmaulHusnaModel.fromJson(Map<String, dynamic> json) {
    return AsmaulHusnaModel(
      id: json[AsmaKeys.id] as int,
      name: json[AsmaKeys.name] as String,
      meaningBrief: json[AsmaKeys.meaningBrief] as String,
      meaningDetailed: json[AsmaKeys.meaningDetailed] as String,
    );
  }
}

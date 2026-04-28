import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sana/features/azkar/constants/azkar_keys.dart';

part 'zikr_model.freezed.dart';

@freezed
class ZikrModel with _$ZikrModel {
  const factory ZikrModel({
    required int id,
    required String text,
    required int count,
    String? subText,
  }) = _ZikrModel;

  factory ZikrModel.fromJson(Map<String, dynamic> json) {
    return ZikrModel(
      id: json[AzkarKeys.id] as int,
      text: json[AzkarKeys.text] as String,
      subText: json[AzkarKeys.subText] as String?,
      count: json[AzkarKeys.count] as int,
    );
  }
}

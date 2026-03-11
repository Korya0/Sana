import 'package:sana/features/azkar/data/constants/azkar_keys.dart';

class ZikrModel {
  ZikrModel({
    required this.id,
    required this.text,
    required this.count,
    this.subText,
  });

  factory ZikrModel.fromJson(Map<String, dynamic> json) {
    return ZikrModel(
      id: json[AzkarKeys.id] as int,
      text: json[AzkarKeys.text] as String,
      subText: json[AzkarKeys.subText] as String?,
      count: json[AzkarKeys.count] as int,
    );
  }
  final int id;
  final String text;
  final String? subText;
  final int count;

  Map<String, dynamic> toJson() {
    return {
      AzkarKeys.id: id,
      AzkarKeys.text: text,
      AzkarKeys.subText: subText,
      AzkarKeys.count: count,
    };
  }
}

import 'package:sana/core/constants/json_keys.dart';

class ZikrModel {
  ZikrModel({
    required this.id,
    required this.text,
    required this.count,
    this.subText,
  });

  factory ZikrModel.fromJson(Map<String, dynamic> json) {
    return ZikrModel(
      id: json[JsonKeys.id] as int,
      text: json[JsonKeys.text] as String,
      subText: json[JsonKeys.subText] as String?,
      count: json[JsonKeys.count] as int,
    );
  }
  final int id;
  final String text;
  final String? subText;
  final int count;

  Map<String, dynamic> toJson() {
    return {
      JsonKeys.id: id,
      JsonKeys.text: text,
      JsonKeys.subText: subText,
      JsonKeys.count: count,
    };
  }
}

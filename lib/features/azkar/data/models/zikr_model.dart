import 'package:sana/features/azkar/constants/azkar_keys.dart';

class ZikrModel {
  const ZikrModel({
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
  final int count;
  final String? subText;

  ZikrModel copyWith({
    int? id,
    String? text,
    int? count,
    String? subText,
  }) {
    return ZikrModel(
      id: id ?? this.id,
      text: text ?? this.text,
      count: count ?? this.count,
      subText: subText ?? this.subText,
    );
  }
}

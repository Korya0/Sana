import 'package:sana/features/azkar/domain/entities/zikr.dart';

class ZikrModel extends Zikr {
  const ZikrModel({
    required super.text,
    required super.totalCount,
    super.subText,
  });
  factory ZikrModel.fromJson(Map<String, dynamic> json) {
    return ZikrModel(
      text: json['text'] as String? ?? '',
      subText: json['subText'] as String? ?? '',
      totalCount: (json['count'] is int)
          ? json['count'] as int
          : int.tryParse(json['count'].toString()) ?? 1,
      // Audio is ignored in UI as requested, but available in JSON
    );
  }
}

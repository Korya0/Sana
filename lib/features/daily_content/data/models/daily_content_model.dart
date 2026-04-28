import 'package:sana/features/daily_content/constants/daily_content_keys.dart';

enum DailyContentType { hadith, sunnah }

class DailyContentModel {
  const DailyContentModel({
    required this.content,
    required this.category,
    this.header,
    this.attribution,
    this.explanation,
  });

  factory DailyContentModel.fromJson(
    Map<String, dynamic> json,
    DailyContentType category,
  ) {
    return DailyContentModel(
      header: json[DailyContentKeys.header] as String?,
      content: json[DailyContentKeys.content] as String,
      attribution: json[DailyContentKeys.attribution] as String?,
      explanation: json[DailyContentKeys.explanation] as String?,
      category: category,
    );
  }

  final String content;
  final DailyContentType category;
  final String? header;
  final String? attribution;
  final String? explanation;

  String get shortContent =>
      content.length > 30 ? '${content.substring(0, 30)}...' : content;

  Map<String, dynamic> toJson() {
    return {
      DailyContentKeys.header: header,
      DailyContentKeys.content: content,
      DailyContentKeys.attribution: attribution,
      DailyContentKeys.explanation: explanation,
    };
  }

  DailyContentModel copyWith({
    String? content,
    DailyContentType? category,
    String? header,
    String? attribution,
    String? explanation,
  }) {
    return DailyContentModel(
      content: content ?? this.content,
      category: category ?? this.category,
      header: header ?? this.header,
      attribution: attribution ?? this.attribution,
      explanation: explanation ?? this.explanation,
    );
  }
}

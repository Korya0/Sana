import 'package:equatable/equatable.dart';
import 'package:sana/core/constants/json_keys.dart';

enum DailyContentType { hadith, sunnah }

class DailyContentModel extends Equatable {
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
      header: json[JsonKeys.header] as String?,
      content: json[JsonKeys.content] as String,
      attribution: json[JsonKeys.attribution] as String?,
      explanation: json[JsonKeys.explanation] as String?,
      category: category,
    );
  }
  final String? header;
  final String content;
  final String? attribution;
  final String? explanation;
  final DailyContentType category;

  Map<String, dynamic> toJson() {
    return {
      JsonKeys.header: header,
      JsonKeys.content: content,
      JsonKeys.attribution: attribution,
      JsonKeys.explanation: explanation,
      JsonKeys.category: category.name,
    };
  }

  @override
  List<Object?> get props => [
    header,
    content,
    attribution,
    explanation,
    category,
  ];
}

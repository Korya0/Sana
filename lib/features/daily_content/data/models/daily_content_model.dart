import 'package:equatable/equatable.dart';
import 'package:sana/features/daily_content/data/constants/daily_content_keys.dart';

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
      header: json[DailyContentKeys.header] as String?,
      content: json[DailyContentKeys.content] as String,
      attribution: json[DailyContentKeys.attribution] as String?,
      explanation: json[DailyContentKeys.explanation] as String?,
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
      DailyContentKeys.header: header,
      DailyContentKeys.content: content,
      DailyContentKeys.attribution: attribution,
      DailyContentKeys.explanation: explanation,
      DailyContentKeys.category: category.name,
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

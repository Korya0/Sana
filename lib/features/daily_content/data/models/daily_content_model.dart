import 'package:equatable/equatable.dart';

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
      header: json['header'] as String?,
      content: json['content'] as String,
      attribution: json['attribution'] as String?,
      explanation: json['explanation'] as String?,
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
      'header': header,
      'content': content,
      'attribution': attribution,
      'explanation': explanation,
      'category': category.name,
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

import 'package:equatable/equatable.dart';

enum DailyContentType { hadith, sunnah }

class DailyContentModel extends Equatable {
  const DailyContentModel({
    required this.content,
    required this.category,
    this.header,
    this.attribution,
  });

  factory DailyContentModel.fromJson(
    Map<String, dynamic> json,
    DailyContentType category,
  ) {
    return DailyContentModel(
      header: json['header'] as String?,
      content: json['content'] as String,
      attribution: json['attribution'] as String?,
      category: category,
    );
  }
  final String? header;
  final String content;
  final String? attribution;
  final DailyContentType category;

  Map<String, dynamic> toJson() {
    return {
      'header': header,
      'content': content,
      'attribution': attribution,
      'category': category.name,
    };
  }

  @override
  List<Object?> get props => [header, content, attribution, category];
}

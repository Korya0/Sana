import 'package:equatable/equatable.dart';

class DailyContentModel extends Equatable {
  const DailyContentModel({
    required this.content,
    this.header,
    this.attribution,
  });

  factory DailyContentModel.fromJson(Map<String, dynamic> json) {
    return DailyContentModel(
      header: json['header'] as String?,
      content: json['content'] as String,
      attribution: json['attribution'] as String?,
    );
  }
  final String? header;
  final String content;
  final String? attribution;

  Map<String, dynamic> toJson() {
    return {'header': header, 'content': content, 'attribution': attribution};
  }

  @override
  List<Object?> get props => [header, content, attribution];
}

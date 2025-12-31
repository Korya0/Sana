class DailyContentModel {
  final String? header;
  final String content;
  final String? attribution;

  const DailyContentModel({
    this.header,
    required this.content,
    this.attribution,
  });

  factory DailyContentModel.fromJson(Map<String, dynamic> json) {
    return DailyContentModel(
      header: json['header'] as String?,
      content: json['content'] as String,
      attribution: json['attribution'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'header': header, 'content': content, 'attribution': attribution};
  }
}

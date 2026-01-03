class ZikrModel {
  final int id;
  final String text;
  final String? subText;
  final int count;

  ZikrModel({
    required this.id,
    required this.text,
    this.subText,
    required this.count,
  });

  factory ZikrModel.fromJson(Map<String, dynamic> json) {
    return ZikrModel(
      id: json['id'] as int,
      text: json['text'] as String,
      subText: json['subText'] as String?,
      count: json['count'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'text': text, 'subText': subText, 'count': count};
  }
}

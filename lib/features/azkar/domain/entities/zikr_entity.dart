class ZikrEntity {
  const ZikrEntity({
    required this.id,
    required this.text,
    required this.count,
    this.subText,
  });

  final int id;
  final String text;
  final int count;
  final String? subText;

  ZikrEntity copyWith({
    int? id,
    String? text,
    int? count,
    String? subText,
  }) {
    return ZikrEntity(
      id: id ?? this.id,
      text: text ?? this.text,
      count: count ?? this.count,
      subText: subText ?? this.subText,
    );
  }
}

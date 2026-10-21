class ZikrEntity {
  const ZikrEntity({
    required this.id,
    required this.text,
    required this.count,
    this.description,
  });

  final int id;
  final String text;
  final int count;
  final String? description;
}

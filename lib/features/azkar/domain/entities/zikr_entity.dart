class ZikrEntity {
  const ZikrEntity({
    required this.id,
    required this.text,
    required this.count,
    this.reference,
    this.description,
  });
  final int id;
  final String text;
  final int count;
  final String? reference;
  final String? description;
}

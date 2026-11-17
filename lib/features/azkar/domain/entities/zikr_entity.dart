class ZikrEntity {
  // Creates entity
  const ZikrEntity({
    required this.id,
    required this.text,
    required this.count,
    this.description,
    this.isUserAdded = false,
  });

  final int id;
  final String text;
  final int count;
  final String? description;
  final bool isUserAdded;

  // Checks deletion
  bool get canBeDeleted => isUserAdded;

  // Copies entity
  ZikrEntity copyWith({
    int? id,
    String? text,
    int? count,
    String? description,
    bool? isUserAdded,
  }) => ZikrEntity(
    id: id ?? this.id,
    text: text ?? this.text,
    count: count ?? this.count,
    description: description ?? this.description,
    isUserAdded: isUserAdded ?? this.isUserAdded,
  );

  // Compares entities
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ZikrEntity &&
          id == other.id &&
          text == other.text &&
          count == other.count &&
          description == other.description &&
          isUserAdded == other.isUserAdded;

  // Hashes entity
  @override
  int get hashCode => Object.hash(id, text, count, description, isUserAdded);
}

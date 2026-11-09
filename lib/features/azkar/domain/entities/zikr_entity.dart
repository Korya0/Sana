class ZikrEntity {
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

  /// Whether this zikr was added by the user and can be deleted.
  bool get canBeDeleted => isUserAdded || id > 100000;
}

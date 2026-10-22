class CategoryEntity {
  const CategoryEntity({
    required this.key,
    required this.title,
    required this.cardTitle,
  });

  /// Stable key from JSON; also the asset file name.
  final String key;

  /// Full title shown inside the reader.
  final String title;

  /// Short title shown on the category card.
  final String cardTitle;
}

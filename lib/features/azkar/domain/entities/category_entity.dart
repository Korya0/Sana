class CategoryEntity {
  const CategoryEntity({
    required this.key,
    required this.title,
    required this.cardTitle,
    this.isCustom = false,
  });

  /// Stable key from JSON; also the asset file name or custom category id.
  final String key;

  /// Full title shown inside the reader.
  final String title;

  /// Short title shown on the category card.
  final String cardTitle;

  /// Whether this is a user-created custom category.
  final bool isCustom;

  CategoryEntity copyWith({
    String? key,
    String? title,
    String? cardTitle,
    bool? isCustom,
  }) => CategoryEntity(
    key: key ?? this.key,
    title: title ?? this.title,
    cardTitle: cardTitle ?? this.cardTitle,
    isCustom: isCustom ?? this.isCustom,
  );
}

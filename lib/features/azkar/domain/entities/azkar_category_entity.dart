class AzkarCategoryEntity {
  // Creates entity
  const AzkarCategoryEntity({
    required this.key,
    required this.title,
    required this.cardTitle,
    this.isCustom = false,
    this.isModified = false,
  });

  final String key;
  final String title;
  final String cardTitle;
  final bool isCustom;
  final bool isModified;

  // Copies entity
  AzkarCategoryEntity copyWith({
    String? key,
    String? title,
    String? cardTitle,
    bool? isCustom,
    bool? isModified,
  }) => AzkarCategoryEntity(
    key: key ?? this.key,
    title: title ?? this.title,
    cardTitle: cardTitle ?? this.cardTitle,
    isCustom: isCustom ?? this.isCustom,
    isModified: isModified ?? this.isModified,
  );
}

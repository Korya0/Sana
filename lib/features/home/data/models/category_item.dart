class CategoryItem {
  const CategoryItem({
    required this.id,
    required this.title,
    required this.icon,
    required this.route,
    this.extra,
    this.isRestricted = false,
    this.isComingSoon = false,
  });
  final String id;
  final String title;
  final dynamic icon;
  final String route;
  final Map<String, dynamic>? extra;
  final bool isRestricted;
  final bool isComingSoon;
}

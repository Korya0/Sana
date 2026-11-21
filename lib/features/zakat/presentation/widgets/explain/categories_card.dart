import 'package:flutter/material.dart';
import '../zakat_info_card.dart';

class CategoriesCard extends StatelessWidget {
  const CategoriesCard({super.key, required this.categories});

  final List<String> categories;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return ZakatInfoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'من يستحق الزكاة؟',
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
              color: primary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'الفئات الثماني المذكورة في سورة التوبة، الآية 60:',
            style: TextStyle(fontSize: 16, height: 1.8),
          ),
          const SizedBox(height: 8),
          for (var i = 0; i < categories.length; i++)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 13,
                    backgroundColor: primary.withValues(alpha: 0.12),
                    child: Text(
                      '${i + 1}',
                      style: TextStyle(
                        fontSize: 13,
                        color: primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      categories[i],
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

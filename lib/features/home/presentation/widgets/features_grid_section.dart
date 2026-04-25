import 'package:flutter/material.dart';
import 'package:sana/core/theme/style/app_spacing.dart';
import 'package:sana/features/home/data/models/category_item.dart';
import 'package:sana/features/home/presentation/widgets/category/category_section_header.dart';
import 'package:sana/features/home/presentation/widgets/category/feature_circular_card.dart';

class FeaturesGridSection extends StatelessWidget {
  const FeaturesGridSection({
    required this.title,
    required this.features,
    super.key,
  });

  final String title;
  final List<CategoryItem> features;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CategorySectionHeader(title: title),
        const SizedBox(height: AppSpacing.v12),
        GridView.builder(
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.v18),
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 0.6,
          ),
          itemCount: features.length,
          itemBuilder: (context, index) {
            final item = features[index];
            return FeatureCircularCard(
              title: item.title,
              icon: item.icon,
              onTap: () async {
                if (item.onTap != null) {
                  await item.onTap!(context);
                }
              },
            );
          },
        ),
      ],
    );
  }
}

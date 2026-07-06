import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sana/core/utils/utils.dart';
import 'package:sana/core/theme/app_spacing.dart';
import 'package:sana/features/azkar/domain/entities/category_entity.dart';
import 'package:sana/features/azkar/presentation/widgets/category_icon_mapper.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    required this.category,
    required this.onTap,
    super.key,
  });

  final CategoryEntity category;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            color: context.color.secondaryScaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(AppSpacing.radiusL),
            border: Border.all(
              color: context.color.primary.withValues(alpha: 0.1),
            ),
          ),
          padding: const EdgeInsets.all(AppSpacing.v16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                CategoryIconMapper.getIconPath(category.id),
                height: 48,
                width: 48,
                colorFilter: ColorFilter.mode(
                  context.color.primary,
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(height: AppSpacing.v12),
              Text(
                category.title,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: context
                      .color
                      .primary, // Used primary instead of undefined primaryText
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

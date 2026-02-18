// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_colors.dart';

class CategoryCard extends StatefulWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final bool isRestricted;

  const CategoryCard({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
    this.isRestricted = false,
  });

  @override
  State<CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.92,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(scale: _scaleAnimation.value, child: child);
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              Container(
                width: 110, // Increased width for better proportions
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  // Subtle gradient for depth
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.secondaryBackground,
                      AppColors.secondaryBackground.withOpacity(0.8),
                    ],
                  ),
                  // Thin elegant border
                  border: Border.all(color: AppColors.gold.withOpacity(0.12)),
                  // Soft shadow for elevation feel
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Icon container with subtle glow background
                    Icon(
                      widget.icon,
                      color: widget.isRestricted ? Colors.grey : AppColors.gold,
                      size: 26,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      widget.title,
                      style: AppTextStyles.font12W500White(context).copyWith(
                        fontWeight: FontWeight.w600,
                        height: 1.2,
                        color: widget.isRestricted ? Colors.grey : null,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              if (widget.isRestricted)
                Positioned(
                  top: 0,
                  left: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: const BoxDecoration(
                      color: AppColors.gold,
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(8),
                      ),
                    ),
                    child: Text(
                      'غير متاح',
                      style: AppTextStyles.font12W700Black(context),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

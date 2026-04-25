import 'package:flutter/material.dart';
import 'package:sana/core/common/decorations/custom_app_divider.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:sana/core/theme/style/app_spacing.dart';
import 'package:sana/features/teaching_prayer/data/models/teaching_prayer_model.dart';
import 'package:sana/features/teaching_prayer/presentation/widgets/teaching_topic_card.dart';
import 'package:solar_icons/solar_icons.dart';

class TeachingSectionCard extends StatefulWidget {
  const TeachingSectionCard({required this.section, super.key});
  final TeachingPrayerSection section;

  @override
  State<TeachingSectionCard> createState() => _TeachingSectionCardState();
}

class _TeachingSectionCardState extends State<TeachingSectionCard>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _rotationAnimation = Tween<double>(begin: 0, end: 0.5).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _toggleExpand() async {
    setState(() {
      _isExpanded = !_isExpanded;
    });
    if (_isExpanded) {
      await _animationController.forward();
    } else {
      await _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.only(bottom: AppSpacing.v12),
      decoration: BoxDecoration(
        color: AppColors.secondaryBackground,
        borderRadius: BorderRadius.circular(AppSpacing.radiusL),
        border: Border.all(
          color: _isExpanded
              ? AppColors.primary.withValues(alpha: 0.3)
              : AppColors.textWhite.withValues(alpha: 0.05),
        ),
        boxShadow: _isExpanded
            ? [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ]
            : [],
      ),
      child: Column(
        children: [
          // Header
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(AppSpacing.radiusL),
              onTap: _toggleExpand,
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.v16),
                child: Row(
                  children: [
                    // Icon
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.v8),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(AppSpacing.radiusM),
                      ),
                      child: const Icon(
                        SolarIconsBold.book,
                        color: AppColors.iconPrimary,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.v16),

                    // Category Title
                    Expanded(
                      child: Text(
                        widget.section.category,
                        style: AppTextStyles.font18W700White(context),
                      ),
                    ),

                    // Topics Count Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(AppSpacing.radiusS),
                      ),
                      child: Text(
                        '${widget.section.topics.length}',
                        style: AppTextStyles.font14W600primary(context),
                      ),
                    ),

                    const SizedBox(width: AppSpacing.v12),

                    // Expand/Collapse Icon
                    RotationTransition(
                      turns: _rotationAnimation,
                      child: const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: AppColors.iconPrimary,
                        size: 28,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Expandable Topics List
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            alignment: Alignment.topCenter,
            child: _isExpanded
                ? Container(
                    padding: const EdgeInsets.only(
                      left: AppSpacing.v12,
                      right: AppSpacing.v12,
                      bottom: AppSpacing.v12,
                    ),
                    child: Column(
                      children: [
                        const CustomAppDivider(),
                        const SizedBox(height: AppSpacing.v8),
                        ...widget.section.topics.map((topic) {
                          return TeachingTopicCard(topic: topic);
                        }),
                      ],
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

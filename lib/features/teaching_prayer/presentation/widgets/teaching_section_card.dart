// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:sana/features/teaching_prayer/data/models/teaching_prayer_model.dart';
import 'package:sana/features/teaching_prayer/presentation/widgets/teaching_topic_card.dart';
import 'package:solar_icons/solar_icons.dart';

class TeachingSectionCard extends StatefulWidget {
  final TeachingPrayerSection section;

  const TeachingSectionCard({super.key, required this.section});

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

  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.secondaryBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _isExpanded
              ? AppColors.gold.withOpacity(0.3)
              : AppColors.textWhite.withOpacity(0.05),
        ),
        boxShadow: _isExpanded
            ? [
                BoxShadow(
                  color: AppColors.gold.withOpacity(0.1),
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
              borderRadius: BorderRadius.circular(16),
              onTap: _toggleExpand,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    // Icon
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.gold.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        SolarIconsBold.book,
                        color: AppColors.gold,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),

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
                        color: AppColors.gold.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${widget.section.topics.length}',
                        style: AppTextStyles.font14W600Gold(context),
                      ),
                    ),

                    const SizedBox(width: 12),

                    // Expand/Collapse Icon
                    RotationTransition(
                      turns: _rotationAnimation,
                      child: const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: AppColors.gold,
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
                      left: 12,
                      right: 12,
                      bottom: 12,
                    ),
                    child: Column(
                      children: [
                        Divider(
                          color: AppColors.textWhite.withOpacity(0.1),
                          height: 1,
                        ),
                        const SizedBox(height: 8),
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

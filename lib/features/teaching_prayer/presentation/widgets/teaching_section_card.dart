import 'package:flutter/material.dart';
import 'package:sana/core/common/common.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/app_spacing.dart';
import 'package:sana/core/utils/utils.dart';
import 'package:sana/features/teaching_prayer/domain/entities/teaching_prayer_entity.dart';
import 'package:sana/features/teaching_prayer/presentation/widgets/teaching_topic_details_bottom_sheet.dart';

class TeachingSectionCard extends StatelessWidget {
  const TeachingSectionCard({required this.section, super.key});
  final TeachingPrayerSectionEntity section;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.v24),
      child: Column(
        children: [
          Text(
            section.title,
            style: AppTextStyles.font16W700(
              context,
            ).copyWith(color: context.color.textPrimary),
          ),
          const AppGap.h(AppSpacing.v16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.v16),
            decoration: BoxDecoration(
              color: context.color.secondaryScaffoldBackgroundColor.withValues(
                alpha: 0.3,
              ),
              borderRadius: BorderRadius.circular(AppSpacing.radiusL),
              border: Border.all(
                color: context.color.textPrimary.withValues(alpha: 0.1),
              ),
            ),
            child: Wrap(
              spacing: AppSpacing.v12,
              runSpacing: AppSpacing.v12,
              alignment: WrapAlignment.center,
              children: section.topics.map((topic) {
                return _TopicChipDisplay(
                  topic: topic,
                  sectionTitle: section.title,
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _TopicChipDisplay extends StatefulWidget {
  const _TopicChipDisplay({
    required this.topic,
    required this.sectionTitle,
  });

  final TeachingPrayerTopicEntity topic;
  final String sectionTitle;

  @override
  State<_TopicChipDisplay> createState() => _TopicChipDisplayState();
}

class _TopicChipDisplayState extends State<_TopicChipDisplay> {
  late VoidCallback _onTap;

  @override
  void initState() {
    super.initState();
    _initCallback();
  }

  @override
  void didUpdateWidget(_TopicChipDisplay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.topic != oldWidget.topic) {
      _initCallback();
    }
  }

  void _initCallback() {
    final topic = widget.topic;
    final sectionTitle = widget.sectionTitle;
    _onTap = () async {
      await showCustomBottomSheet(
        context,
        child: TeachingTopicDetailsBottomSheet(
          sectionTitle: sectionTitle,
          topic: topic,
        ),
      );
    };
  }

  @override
  Widget build(BuildContext context) {
    return _TopicChip(
      title: widget.topic.title,
      onTap: _onTap,
    );
  }
}

class _TopicChip extends StatelessWidget {
  const _TopicChip({required this.title, required this.onTap});

  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusM),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.v16,
            vertical: AppSpacing.v8,
          ),
          decoration: BoxDecoration(
            color: context.color.scaffoldBackgroundColor.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(AppSpacing.radiusM),
            border: Border.all(
              color: context.color.textPrimary.withValues(alpha: 0.1),
            ),
          ),
          child: Text(
            title,
            style: AppTextStyles.font14W500(
              context,
            ).copyWith(color: context.color.textPrimary),
          ),
        ),
      ),
    );
  }
}

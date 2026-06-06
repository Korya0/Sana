import 'package:flutter/material.dart';
import 'package:sana/core/utils/context_extension.dart';
import 'package:sana/core/common/widgets/app_toggle_list.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/features/teaching_prayer/data/models/teaching_prayer_model.dart';
import 'package:sana/features/teaching_prayer/presentation/widgets/teaching_topic_card.dart';

class TeachingSectionCard extends StatelessWidget {
  const TeachingSectionCard({required this.section, super.key});
  final TeachingPrayerSectionModel section;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AppToggleList(
        title: Text(
          section.title,
          style: AppTextStyles.font16W700(context).copyWith(color: context.color.textPrimary),
        ),
        children: [
          ...section.topics.map((topic) {
            return TeachingTopicCard(
              key: ValueKey(topic.id),
              topic: topic,
            );
          }),
        ],
      ),
    );
  }
}

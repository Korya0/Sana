import 'package:flutter/material.dart';
import 'package:sana/core/common/common.dart';
import 'package:sana/core/constants/constants.dart';
import 'package:sana/features/teaching_prayer/domain/entities/teaching_prayer_entity.dart';
import 'package:sana/features/teaching_prayer/presentation/widgets/teaching_section_card.dart';

class TeachingPrayerSuccessWidget extends StatelessWidget {
  const TeachingPrayerSuccessWidget({required this.sections, super.key});

  final List<TeachingPrayerSectionEntity> sections;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        const CommonSliverAppBar(title: AppStrings.teachPrayer),
        AnimatedSliverList<TeachingPrayerSectionEntity>(
          dataList: sections,
          itemContentBuilder: (context, section, index) => _SectionCardItem(
            section: section,
          ),
        ),
      ],
    );
  }
}

class _SectionCardItem extends StatelessWidget {
  const _SectionCardItem({required this.section});

  final TeachingPrayerSectionEntity section;

  @override
  Widget build(BuildContext context) {
    return TeachingSectionCard(
      key: ValueKey(section.id),
      section: section,
    );
  }
}

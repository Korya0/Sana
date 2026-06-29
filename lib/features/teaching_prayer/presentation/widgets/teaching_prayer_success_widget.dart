import 'package:flutter/material.dart';
import 'package:sana/core/common/common.dart';
import 'package:sana/core/constants/constants.dart';
import 'package:sana/features/teaching_prayer/data/models/teaching_prayer_model.dart';
import 'package:sana/features/teaching_prayer/presentation/widgets/teaching_section_card.dart';

class TeachingPrayerSuccessWidget extends StatelessWidget {
  const TeachingPrayerSuccessWidget({required this.sections, super.key});

  final List<TeachingPrayerSectionModel> sections;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        const CommonSliverAppBar(title: AppStrings.teachPrayer),
        AnimatedSliverList<TeachingPrayerSectionModel>(
          dataList: sections,
          itemContentBuilder: (context, section, index) => TeachingSectionCard(
            key: ValueKey(section.id),
            section: section,
          ),
        ),
      ],
    );
  }
}

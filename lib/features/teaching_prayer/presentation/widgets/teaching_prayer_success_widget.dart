import 'package:flutter/material.dart';
import 'package:sana/core/common/slivers/animated_sliver_list.dart';
import 'package:sana/core/common/slivers/common_sliver_app_bar.dart';
import 'package:sana/core/constants/app_strings.dart';
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
          itemContentBuilder: (context, section, index) =>
              TeachingSectionCard(section: section),
        ),
      ],
    );
  }
}

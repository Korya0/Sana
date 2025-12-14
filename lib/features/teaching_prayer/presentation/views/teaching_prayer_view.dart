import 'package:flutter/material.dart';
import 'package:sana/core/common/widgets/animated_sliver_list.dart';
import 'package:sana/core/common/widgets/common_sliver_app_bar.dart';
import 'package:sana/features/teaching_prayer/data/models/teaching_prayer_model.dart';
import 'package:sana/features/teaching_prayer/presentation/widgets/teaching_section_card.dart';

class TeachingPrayerView extends StatelessWidget {
  const TeachingPrayerView({super.key});

  @override
  Widget build(BuildContext context) {
    // Access static data directly
    final sections = TeachingPrayerData.sections;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const CommonSliverAppBar(title: 'تعلم الصلاة'),
          AnimatedSliverList<TeachingPrayerSection>(
            items: sections,
            itemBuilder: (context, section, index) =>
                TeachingSectionCard(section: section),
          ),
        ],
      ),
    );
  }
}

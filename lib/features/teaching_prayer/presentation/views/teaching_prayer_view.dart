import 'package:flutter/material.dart';
import 'package:sana/core/common/widgets/animated_sliver_list.dart';
import 'package:sana/core/common/widgets/common_sliver_app_bar.dart';
import 'package:sana/features/teaching_prayer/data/datasources/teaching_prayer_local_data_source.dart';
import 'package:sana/features/teaching_prayer/data/models/teaching_prayer_model.dart';
import 'package:sana/features/teaching_prayer/presentation/widgets/teaching_section_card.dart';

class TeachingPrayerView extends StatelessWidget {
  const TeachingPrayerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<TeachingPrayerSection>>(
        future: TeachingPrayerLocalDataSource.getSections(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text("Error loading data"));
          }

          final sections = snapshot.data ?? [];

          return CustomScrollView(
            slivers: [
              const CommonSliverAppBar(title: 'تعلم الصلاة'),
              AnimatedSliverList<TeachingPrayerSection>(
                items: sections,
                itemBuilder: (context, section, index) =>
                    TeachingSectionCard(section: section),
              ),
            ],
          );
        },
      ),
    );
  }
}

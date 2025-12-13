import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sana/core/common/widgets/animated_sliver_list.dart';
import 'package:sana/core/common/widgets/common_sliver_app_bar.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:sana/features/teaching_prayer/data/models/teaching_prayer_model.dart';
import 'package:sana/features/teaching_prayer/presentation/widgets/teaching_section_card.dart';

class TeachingPrayerView extends StatefulWidget {
  const TeachingPrayerView({super.key});

  @override
  State<TeachingPrayerView> createState() => _TeachingPrayerViewState();
}

class _TeachingPrayerViewState extends State<TeachingPrayerView> {
  late Future<List<TeachingPrayerSection>> _sectionsFuture;

  @override
  void initState() {
    super.initState();
    _sectionsFuture = _loadData();
  }

  Future<List<TeachingPrayerSection>> _loadData() async {
    final String response = await rootBundle.loadString(
      'assets/json/teaching_prayer.json',
    );
    final data = json.decode(response);
    if (data['guides'] != null) {
      return (data['guides'] as List)
          .map((e) => TeachingPrayerSection.fromJson(e))
          .toList();
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: FutureBuilder<List<TeachingPrayerSection>>(
        future: _sectionsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('حدث خطأ: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('لا توجد بيانات متاحة'));
          }

          final sections = snapshot.data!;

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

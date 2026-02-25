import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:sana/features/asma_ul_husna/presentation/widgets/asma_ul_husna_name_of_the_day_card.dart';
import 'package:sana/features/daily_content/presentation/widgets/card/daily_hadith_card.dart';
import 'package:sana/features/daily_content/presentation/widgets/card/daily_sunnah_card.dart';
import 'package:sana/features/home/presentation/widgets/category/category_section_header.dart';

class DailyWisdomSection extends StatelessWidget {
  const DailyWisdomSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CategorySectionHeader(title: 'أنوار اليوم'),
        const SizedBox(height: 12),
        CarouselSlider(
          items: const [
            DailyHadithCard(),
            DailySunnahCard(),
            AsmaUlHusnaNameOfTheDayCard(),
          ],
          options: CarouselOptions(
            height: 190,
            viewportFraction: 0.92,
            enlargeCenterPage: true,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 5),
            autoPlayCurve: Curves.easeInOutCubic,
          ),
        ),
      ],
    );
  }
}

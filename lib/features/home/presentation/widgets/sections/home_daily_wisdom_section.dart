import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:sana/features/asma_ul_husna/presentation/widgets/asma_ul_husna_name_of_the_day_card.dart';
import 'package:sana/features/daily_content/presentation/widgets/card/daily_hadith_card.dart';
import 'package:sana/features/daily_content/presentation/widgets/card/daily_sunnah_card.dart';
import 'package:sana/features/home/presentation/widgets/category/category_section_header.dart';

class HomeDailyWisdomSection extends StatelessWidget {
  const HomeDailyWisdomSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 12,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        const CategorySectionHeader(title: 'أنوار اليوم'),

        // Carousel
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
            autoPlayInterval: const Duration(seconds: 3),
            autoPlayCurve: Curves.easeInOutCubic,
          ),
        ),
      ],
    );
  }
}

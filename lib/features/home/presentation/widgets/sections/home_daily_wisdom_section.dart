import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/common/layout/custom_carousel_slider.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/features/daily_content/presentation/cubit/daily_content_cubit.dart';
import 'package:sana/features/daily_content/presentation/cubit/daily_content_state.dart';
import 'package:sana/features/daily_content/presentation/widgets/card/daily_asma_ul_husna_card.dart';
import 'package:sana/features/daily_content/presentation/widgets/card/daily_hadith_card.dart';
import 'package:sana/features/daily_content/presentation/widgets/card/daily_sunnah_card.dart';
import 'package:sana/features/home/presentation/widgets/category/category_section_header.dart';
import 'package:sana/features/home/presentation/widgets/skeleton/skeletonizer_home_daily_wisdom.dart';

class HomeDailyWisdomSection extends StatelessWidget {
  const HomeDailyWisdomSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DailyContentCubit, DailyContentState>(
      builder: (context, state) {
        if (state.status == DailyContentStatus.loading) {
          return const SkeletonizerHomeDailyWisdom();
        }

        return const Column(
          spacing: 12,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            CategorySectionHeader(title: AppStrings.dailyWisdomHeader),

            // Carousel
            CustomCarouselSlider(
              items: [
                DailyHadithCard(),
                DailySunnahCard(),
                DailyAsmaUlHusnaCard(),
              ],
              height: 190,
              viewportFraction: 0.92,
              enlargeCenterPage: true,
              autoPlayCurve: Curves.easeInOutCubic,
            ),
          ],
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sana/core/common/layout/custom_carousel_slider.dart';
import 'package:sana/core/constants/constants.dart';
import 'package:sana/core/routing/app_routes.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_spacing.dart';
import 'package:sana/core/utils/utils.dart';
import 'package:sana/features/asma_ul_husna/presentation/widgets/card/daily_asma_ul_husna_card.dart';
import 'package:sana/features/daily_content/presentation/cubit/daily_content_cubit.dart';
import 'package:sana/features/daily_content/presentation/cubit/daily_content_state.dart';
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

        return Column(
          spacing: AppSpacing.v12,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            CategorySectionHeader(
              title: AppStrings.dailyWisdomHeader,
              child: GestureDetector(
                onTap: () => context.pushNamed(AppRoutes.dailyContentFavorites),
                child: Text(
                  AppStrings.dailyContentFavorites,
                  style: AppTextStyles.font12W700(
                    context,
                  ).copyWith(color: context.color.primary),
                ),
              ),
            ),

            // Carousel
            const CustomCarouselSlider(
              items: [
                DailyHadithCard(),
                DailySunnahCard(),
                DailyAsmaUlHusnaCard(),
              ],
              height: 160,
              viewportFraction: 0.9,
              enlargeCenterPage: true,
              autoPlayCurve: Curves.easeInOutCubic,
            ),
          ],
        );
      },
    );
  }
}

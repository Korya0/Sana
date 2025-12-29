import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/di/service_locator.dart';
import 'package:sana/core/services/date_gregorian_and_hijri/cubit/app_date_cubit.dart';
import 'package:sana/features/azkar/data/models/azkar_category_model.dart';
import 'package:sana/features/daily_content/presentation/controller/daily_content_cubit.dart';
import 'package:sana/features/home/data/model/category_item.dart';
import 'package:sana/features/home/presentation/cubit/sortable_category_cubit.dart';
import 'package:sana/features/home/presentation/widgets/sections/azkar_category_bloc_builder.dart';
import 'package:sana/features/home/presentation/widgets/sections/prayer_category_section_bloc_builder.dart';
import 'package:sana/features/prayer/presentation/widgets/prayer_bloc_builder_widget.dart';
import 'package:sana/features/quran/presentation/widgets/quran_card/quran_card.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              sl<SortableCategoryCubit<AzkarCategoryModel>>()..loadFeatures(),
        ),
        BlocProvider(
          create: (context) =>
              sl<SortableCategoryCubit<CategoryItem>>()..loadFeatures(),
        ),
        BlocProvider(
          create: (context) =>
              DailyContentCubit(context.read<AppDateCubit>())
                ..loadDailyContent(),
        ),
      ],
      child: Builder(
        builder: (context) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            // Trigger heavy services after UI is ready
            initializeAppPostFrame();
          });
          return const Scaffold(
            body: CustomScrollView(
              physics: BouncingScrollPhysics(),
              slivers: [
                // Prayer Section
                SliverToBoxAdapter(child: PrayerBlocBuilderWidget()),

                // Quran Card
                SliverPadding(
                  padding: EdgeInsets.only(left: 8, right: 8, top: 16),
                  sliver: SliverToBoxAdapter(child: QuranCard()),
                ),

                // Azkar Categoray
                SliverPadding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  sliver: SliverToBoxAdapter(child: AzkarCategoryBlocBuilder()),
                ),

                // Features Categoray
                SliverPadding(
                  padding: EdgeInsets.only(bottom: 24),
                  sliver: SliverToBoxAdapter(
                    child: FeaturesCategoryBlocBuilder(),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

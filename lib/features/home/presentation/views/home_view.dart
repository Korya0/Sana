import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/di/service_locator.dart';
import 'package:sana/features/azkar/data/models/azkar_category_model.dart';
import 'package:sana/features/home/data/model/category_item.dart';
import 'package:sana/features/home/presentation/cubit/sortable_category_cubit.dart';
import 'package:sana/features/home/presentation/widgets/sections/azkar_category_bloc_builder.dart';
import 'package:sana/features/home/presentation/widgets/sections/home_settings_section.dart';
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
      ],
      child: Builder(
        builder: (context) {
          return const Scaffold(
            body: CustomScrollView(
              physics: BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(child: PrayerBlocBuilderWidget()),
                SliverToBoxAdapter(child: QuranCard()),
                SliverToBoxAdapter(child: SizedBox(height: 16)),
                SliverToBoxAdapter(child: AzkarCategoryBlocBuilder()),
                SliverToBoxAdapter(child: SizedBox(height: 16)),
                SliverToBoxAdapter(child: FeaturesCategoryBlocBuilder()),
                SliverToBoxAdapter(child: SizedBox(height: 16)),
                SliverToBoxAdapter(child: HomeSettingsSection()),
                SliverToBoxAdapter(child: SizedBox(height: 50)),
              ],
            ),
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sana/core/common/slivers/animated_sliver_list.dart';
import 'package:sana/core/common/widgets/app_error_widget.dart';
import 'package:sana/core/common/slivers/common_sliver_app_bar.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/di/service_locator.dart';
import 'package:sana/features/teaching_prayer/data/models/teaching_prayer_model.dart';
import 'package:sana/features/teaching_prayer/presentation/controller/teaching_prayer_cubit.dart';
import 'package:sana/features/teaching_prayer/presentation/widgets/teaching_section_card.dart';

class TeachingPrayerView extends StatelessWidget {
  const TeachingPrayerView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<TeachingPrayerCubit>()..loadSections(),
      child: Scaffold(
        body: BlocBuilder<TeachingPrayerCubit, TeachingPrayerState>(
          builder: (context, state) {
            if (state is TeachingPrayerLoading ||
                state is TeachingPrayerInitial) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is TeachingPrayerError) {
              return AppErrorWidget(
                message: state.message,
                onRetry: () =>
                    context.read<TeachingPrayerCubit>().loadSections(),
              );
            }

            final sections = state is TeachingPrayerLoaded
                ? state.sections
                : <TeachingPrayerSection>[];

            return CustomScrollView(
              slivers: [
                const CommonSliverAppBar(title: AppStrings.teachPrayer),
                AnimatedSliverList<TeachingPrayerSection>(
                  dataList: sections,
                  itemContentBuilder: (context, section, index) =>
                      TeachingSectionCard(section: section),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

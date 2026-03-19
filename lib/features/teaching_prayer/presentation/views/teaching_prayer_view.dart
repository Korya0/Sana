import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/common/slivers/animated_sliver_list.dart';
import 'package:sana/core/common/slivers/common_sliver_app_bar.dart';
import 'package:sana/core/common/widgets/app_error_view.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/di/service_locator.dart';
import 'package:sana/features/teaching_prayer/data/models/teaching_prayer_model.dart';
import 'package:sana/features/teaching_prayer/presentation/cubit/teaching_prayer_cubit.dart';
import 'package:sana/features/teaching_prayer/presentation/cubit/teaching_prayer_state.dart';
import 'package:sana/features/teaching_prayer/presentation/widgets/teaching_section_card.dart';

class TeachingPrayerView extends StatelessWidget {
  const TeachingPrayerView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = sl<TeachingPrayerCubit>();
        unawaited(cubit.loadSections());
        return cubit;
      },
      child: Scaffold(
        body: BlocBuilder<TeachingPrayerCubit, TeachingPrayerState>(
          builder: (context, state) {
            return state.maybeWhen(
              initial: () => const Center(child: CircularProgressIndicator()),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (message) => AppErrorView(
                message: message,
                onRetry: () => unawaited(
                  context.read<TeachingPrayerCubit>().loadSections(),
                ),
              ),
              loaded: (sections) => CustomScrollView(
                slivers: [
                  const CommonSliverAppBar(title: AppStrings.teachPrayer),
                  AnimatedSliverList<TeachingPrayerSection>(
                    dataList: sections,
                    itemContentBuilder: (context, section, index) =>
                        TeachingSectionCard(section: section),
                  ),
                ],
              ),
              orElse: () => const SizedBox.shrink(),
            );
          },
        ),
      ),
    );
  }
}

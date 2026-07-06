import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/common/common.dart';
import 'package:sana/features/teaching_prayer/presentation/cubit/teaching_prayer_cubit.dart';
import 'package:sana/features/teaching_prayer/presentation/cubit/teaching_prayer_state.dart';
import 'package:sana/features/teaching_prayer/presentation/widgets/teaching_prayer_success_widget.dart';

class TeachingPrayerView extends StatelessWidget {
  const TeachingPrayerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<TeachingPrayerCubit, TeachingPrayerState>(
        builder: (context, state) {
          return switch (state) {
            TeachingPrayerInitial() || TeachingPrayerLoading() => const Center(
              child: CircularProgressIndicator(),
            ),
            TeachingPrayerError(:final message) => AppErrorView(
              message: message,
              onRetry: () => unawaited(
                context.read<TeachingPrayerCubit>().loadSections(),
              ),
            ),
            TeachingPrayerSuccess(:final sections) =>
              TeachingPrayerSuccessWidget(sections: sections),
          };
        },
      ),
    );
  }
}

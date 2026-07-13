import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/common/common.dart';
import 'package:sana/features/teaching_prayer/domain/entities/teaching_prayer_entity.dart';
import 'package:sana/features/teaching_prayer/presentation/cubit/teaching_prayer_cubit.dart';
import 'package:sana/features/teaching_prayer/presentation/cubit/teaching_prayer_state.dart';
import 'package:sana/features/teaching_prayer/presentation/widgets/teaching_prayer_success_widget.dart';
import 'package:skeletonizer/skeletonizer.dart';

class TeachingPrayerView extends StatelessWidget {
  const TeachingPrayerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<TeachingPrayerCubit, TeachingPrayerState>(
        builder: (context, state) {
          return switch (state) {
            TeachingPrayerInitial() ||
            TeachingPrayerLoading() => const _SkeletonLoadingView(),
            TeachingPrayerError(:final message) => _TeachingPrayerErrorView(
              message: message,
            ),
            TeachingPrayerSuccess(:final sections) =>
              TeachingPrayerSuccessWidget(sections: sections),
          };
        },
      ),
    );
  }
}

class _SkeletonLoadingView extends StatelessWidget {
  const _SkeletonLoadingView();

  static final List<TeachingPrayerSectionEntity> _dummySections = List.generate(
    5,
    (index) => TeachingPrayerSectionEntity(
      id: 'dummy_$index',
      title: 'عنوان القسم الوهمي $index',
      topics: const <TeachingPrayerTopicEntity>[],
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      child: TeachingPrayerSuccessWidget(sections: _dummySections),
    );
  }
}

class _TeachingPrayerErrorView extends StatefulWidget {
  const _TeachingPrayerErrorView({required this.message});

  final String message;

  @override
  State<_TeachingPrayerErrorView> createState() =>
      _TeachingPrayerErrorViewState();
}

class _TeachingPrayerErrorViewState extends State<_TeachingPrayerErrorView> {
  late VoidCallback _onRetry;

  @override
  void initState() {
    super.initState();
    _initCallback();
  }

  @override
  void didUpdateWidget(_TeachingPrayerErrorView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.message != oldWidget.message) {
      _initCallback();
    }
  }

  void _initCallback() {
    _onRetry = () => unawaited(
      context.read<TeachingPrayerCubit>().loadSections(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppErrorView(
      message: widget.message,
      onRetry: _onRetry,
    );
  }
}

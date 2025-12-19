import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sana/features/prayer/data/get_prayers_list.dart';
import 'package:sana/features/prayer/presentation/cubit/prayer_times_cubit.dart';
import 'package:sana/features/prayer/presentation/widgets/countdown_timer.dart';
import 'package:sana/features/prayer/presentation/widgets/date_and_location_and_next_prayer_widget.dart';
import 'package:sana/features/prayer/utils/prayer_progress_calculator.dart';
import 'package:sana/core/services/date/cubit/app_date_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PrayerTimerBuilder extends StatefulWidget {
  final PrayerTimesState state;

  const PrayerTimerBuilder({super.key, required this.state});

  @override
  State<PrayerTimerBuilder> createState() => PrayerTimerBuilderState();
}

class PrayerTimerBuilderState extends State<PrayerTimerBuilder> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Calculate countdown
    String countdown = "00:00:00";
    final now = context.read<AppDateCubit>().currentDate;
    if (widget.state.nextPrayerTime != null) {
      // final now = DateTime.now();
      final diff = widget.state.nextPrayerTime!.difference(now);
      if (!diff.isNegative) {
        countdown =
            "${diff.inHours.toString().padLeft(2, '0')}:${(diff.inMinutes % 60).toString().padLeft(2, '0')}:${(diff.inSeconds % 60).toString().padLeft(2, '0')}";
      }
    }

    // Get next prayer name
    String nextPrayerName = '';
    if (widget.state.prayerTimes != null && widget.state.nextPrayer != null) {
      try {
        nextPrayerName = getPrayersList(
          widget.state.prayerTimes!,
        ).firstWhere((p) => p.prayer == widget.state.nextPrayer).name;
      } catch (_) {}
    }

    return DateAndLocationAndNextPrayerWidget(
      countdownTimerWidget: CountdownTimer(
        duration: countdown,
        nextPrayerName: nextPrayerName,
      ),
      fillProgress: calculateFillProgress(widget.state, now),
    );
  }
}

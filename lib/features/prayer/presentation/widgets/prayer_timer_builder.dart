import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sana/features/prayer/presentation/cubit/prayer_times_cubit.dart';
import 'package:sana/features/prayer/presentation/widgets/countdown_timer.dart';
import 'package:sana/features/prayer/presentation/widgets/date_and_location_and_next_prayer_widget.dart';
import 'package:sana/features/prayer/utils/prayer_progress_calculator.dart';

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
    if (widget.state.prayers.isEmpty) {
      return const SizedBox.shrink();
    }

    // Calculate countdown using current time
    String countdown = "00:00:00";
    final now = DateTime.now();

    // Get next prayer from state
    // Use firstWhereOrNull logic to be safe, or just check length
    final nextPrayer = widget.state.prayers.any((p) => p.isNext)
        ? widget.state.prayers.firstWhere((p) => p.isNext)
        : widget.state.prayers.first;

    final diff = nextPrayer.time.difference(now);
    if (!diff.isNegative) {
      countdown =
          "${diff.inHours.toString().padLeft(2, '0')}:${(diff.inMinutes % 60).toString().padLeft(2, '0')}:${(diff.inSeconds % 60).toString().padLeft(2, '0')}";
    }

    return DateAndLocationAndNextPrayerWidget(
      countdownTimerWidget: CountdownTimer(
        duration: countdown,
        nextPrayerName: nextPrayer.displayName,
      ),
      fillProgress: calculateFillProgress(widget.state, now),
    );
  }
}

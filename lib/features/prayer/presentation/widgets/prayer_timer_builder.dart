import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/features/prayer/presentation/controller/prayer_times_cubit.dart';
import 'package:sana/features/prayer/presentation/widgets/countdown_timer.dart';
import 'package:sana/features/prayer/presentation/widgets/date_and_location_and_next_prayer_widget.dart';
import 'package:sana/features/prayer/utils/prayer_progress_calculator.dart';

class PrayerTimerBuilder extends StatefulWidget {
  const PrayerTimerBuilder({required this.state, super.key});
  final PrayerTimesState state;

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
        if (widget.state.prayers.isNotEmpty) {
          final now = DateTime.now();
          final nextPrayer = widget.state.prayers.any((p) => p.isNext)
              ? widget.state.prayers.firstWhere((p) => p.isNext)
              : widget.state.prayers.first;

          final diff = nextPrayer.time.difference(now);
          if (diff.isNegative && diff.inSeconds <= -1) {
            context.read<PrayerTimesCubit>().refresh();
          }
        }
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
    final now = DateTime.now();

    // Get next prayer from state
    final nextPrayer = widget.state.prayers.any((p) => p.isNext)
        ? widget.state.prayers.firstWhere((p) => p.isNext)
        : widget.state.prayers.first;

    final diff = nextPrayer.time.difference(now);
    final String countdown;

    if (diff.isNegative || diff.inSeconds == 0) {
      countdown = '00:00:00';
    } else {
      final hours = diff.inHours.toString().padLeft(2, '0');
      final minutes = (diff.inMinutes % 60).toString().padLeft(2, '0');
      final seconds = (diff.inSeconds % 60).toString().padLeft(2, '0');
      countdown = '$hours:$minutes:$seconds';
    }

    return RepaintBoundary(
      child: DateAndLocationAndNextPrayerWidget(
        countdownTimerWidget: CountdownTimer(
          duration: countdown,
          nextPrayerName: nextPrayer.displayName,
        ),
        fillProgress: calculateFillProgress(widget.state, now),
      ),
    );
  }
}

import 'dart:async';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/features/app_date/presentation/controller/app_date_cubit.dart';
import 'package:sana/features/prayer/data/services/religious_events_service.dart';
import 'package:sana/features/prayer/presentation/controller/prayer_times_cubit.dart';
import 'package:sana/features/prayer/presentation/widgets/carousel/prayer_countdown_carousel_card.dart';
import 'package:sana/features/prayer/presentation/widgets/carousel/prayer_status_carousel_card.dart';
import 'package:sana/features/prayer/presentation/widgets/carousel/religious_event_carousel_card.dart';
import 'package:sana/features/prayer/presentation/widgets/date_and_location_and_next_prayer_widget.dart';
import 'package:sana/features/prayer/utils/prayer_progress_calculator.dart';
import 'package:sana/features/prayer/utils/prayer_time_status_calculator.dart';

class HomePrayerHeader extends StatefulWidget {
  const HomePrayerHeader({required this.state, super.key});
  final PrayerTimesState state;

  @override
  State<HomePrayerHeader> createState() => HomePrayerHeaderState();
}

class HomePrayerHeaderState extends State<HomePrayerHeader> {
  Timer? _timer;
  late final ValueNotifier<String> _durationNotifier;

  @override
  void initState() {
    super.initState();
    _durationNotifier = ValueNotifier(_calculateCountdown());
    _startTimer();
  }

  String _calculateCountdown() {
    if (widget.state.prayers.isEmpty) return '00:00:00';

    final now = DateTime.now();

    final currentPrayer = widget.state.prayers.any((p) => p.isCurrent)
        ? widget.state.prayers.firstWhere((p) => p.isCurrent)
        : null;

    if (currentPrayer != null) {
      final elapsedSinceStart = now.difference(currentPrayer.time);
      if (elapsedSinceStart.inSeconds >= 0 &&
          elapsedSinceStart.inMinutes < 10) {
        final remainingGrace =
            const Duration(minutes: 10).inSeconds - elapsedSinceStart.inSeconds;
        final minutes = (remainingGrace ~/ 60).toString().padLeft(2, '0');
        final seconds = (remainingGrace % 60).toString().padLeft(2, '0');
        return '00:$minutes:$seconds';
      }
    }

    final nextPrayer = widget.state.prayers.any((p) => p.isNext)
        ? widget.state.prayers.firstWhere((p) => p.isNext)
        : widget.state.prayers.first;

    final diff = nextPrayer.time.difference(now);

    if (diff.isNegative || diff.inSeconds == 0) {
      return '00:00:00';
    } else {
      final hours = diff.inHours.toString().padLeft(2, '0');
      final minutes = (diff.inMinutes % 60).toString().padLeft(2, '0');
      final seconds = (diff.inSeconds % 60).toString().padLeft(2, '0');
      return '$hours:$minutes:$seconds';
    }
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

          _durationNotifier.value = _calculateCountdown();
        }
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _durationNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.state.prayers.isEmpty) {
      return const SizedBox.shrink();
    }

    final now = DateTime.now();

    final currentPrayer = widget.state.prayers.any((p) => p.isCurrent)
        ? widget.state.prayers.firstWhere((p) => p.isCurrent)
        : null;
    final nextPrayer = widget.state.prayers.any((p) => p.isNext)
        ? widget.state.prayers.firstWhere((p) => p.isNext)
        : widget.state.prayers.first;

    var isGracePeriod = false;
    if (currentPrayer != null) {
      final elapsedSinceStart = now.difference(currentPrayer.time);
      if (elapsedSinceStart.inSeconds >= 0 &&
          elapsedSinceStart.inMinutes < 10) {
        isGracePeriod = true;
      }
    }

    final displayName = isGracePeriod
        ? currentPrayer!.displayName
        : nextPrayer.displayName;

    // Build Carousel Items
    final items = <Widget>[
      // Card 1: Countdown
      PrayerCountdownCarouselCard(
        durationListenable: _durationNotifier,
        nextPrayerName: displayName,
        isGracePeriod: isGracePeriod,
      ),
      // Card 2: Status
      if (widget.state.originPrayerTimes != null)
        PrayerStatusCarouselCard(
          status: PrayerTimeStatusCalculator.getStatus(
            widget.state.originPrayerTimes!,
            now,
          ),
        ),
    ];

    // Card 3: Religious Events (Only if exists)
    final hijriDate = context.read<AppDateCubit>().state.date.hijri;
    final event = ReligiousEventsService.getEventForDate(hijriDate);
    if (event != null) {
      items.add(ReligiousEventCarouselCard(event: event));
    }

    return RepaintBoundary(
      child: DateAndLocationAndNextPrayerWidget(
        carouselWidget: CarouselSlider(
          items: items,
          options: CarouselOptions(
            height: 60, // Reduced height to return to natural size
            viewportFraction: 1,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 3), // Faster rotation
            autoPlayCurve: Curves.easeInOut,
          ),
        ),
        fillProgress: calculateFillProgress(widget.state, now),
      ),
    );
  }
}

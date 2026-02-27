import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:sana/features/app_date/presentation/widgets/hijri_and_gregorian_date_widget.dart';
import 'package:sana/features/prayer/presentation/controller/prayer_times_cubit.dart';
import 'package:sana/features/prayer/presentation/widgets/header/city_country_widget.dart';
import 'package:sana/features/prayer/presentation/widgets/header/home_prayer_carousel.dart';
import 'package:sana/features/prayer/presentation/widgets/wave_progress_widget.dart';
import 'package:sana/features/prayer/utils/prayer_countdown_calculator.dart';

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
    _durationNotifier = ValueNotifier(
      PrayerCountdownCalculator.calculateCountdown(widget.state.prayers),
    );
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted || widget.state.prayers.isEmpty) return;

      final now = DateTime.now();
      final nextPrayer = widget.state.prayers.firstWhere(
        (p) => p.isNext,
        orElse: () => widget.state.prayers.first,
      );

      if (nextPrayer.time.difference(now).isNegative) {
        context.read<PrayerTimesCubit>().refresh();
      }

      _durationNotifier.value = PrayerCountdownCalculator.calculateCountdown(
        widget.state.prayers,
      );
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

    return RepaintBoundary(
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.secondaryBackground.withValues(alpha: 0.4),
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(8),
            bottomRight: Radius.circular(8),
          ),
        ),
        clipBehavior: Clip.hardEdge,
        child: Stack(
          children: [
            const Positioned.fill(child: WaveProgressWidget()),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SafeArea(
                bottom: false,
                child: Column(
                  spacing: 8,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: kIsWeb ? 16 : 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          HijriAndGregorianDateWidget(),
                          CityCountryWidget(),
                        ],
                      ),
                    ),
                    HomePrayerCarousel(
                      state: widget.state,
                      durationListenable: _durationNotifier,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

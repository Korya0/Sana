import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/common/common.dart';
import 'package:sana/features/app_date/presentation/cubits/app_date_cubit.dart';
import 'package:sana/features/app_date/presentation/widgets/hijri_and_gregorian_date_widget.dart';
import 'package:sana/core/constants/app_spacing.dart';
import 'package:sana/features/prayer/presentation/cubits/prayer_times_cubit.dart';
import 'package:sana/features/prayer/presentation/cubits/prayer_times_state.dart';
import 'package:sana/features/prayer/presentation/widgets/header/city_country_widget.dart';
import 'package:sana/features/prayer/presentation/widgets/header/home_prayer_carousel.dart';
import 'package:sana/features/prayer/presentation/widgets/prayer_timeline.dart';
import 'package:sana/features/prayer/calculators/prayer_countdown_calculator.dart';

class HomePrayerLoaded extends StatefulWidget {
  const HomePrayerLoaded({required this.state, super.key});
  final PrayerTimesState state;

  @override
  State<HomePrayerLoaded> createState() => HomePrayerLoadedState();
}

class HomePrayerLoadedState extends State<HomePrayerLoaded> {
  Timer? _timer;
  late final ValueNotifier<String> _durationNotifier;

  @override
  void initState() {
    super.initState();
    _durationNotifier = ValueNotifier(
      _calculateCountdown(widget.state),
    );
    _startTimer();
  }

  String _calculateCountdown(PrayerTimesState state) {
    if (state is PrayerTimesLoaded) {
      return PrayerCountdownCalculator.calculateCountdown(state.prayers);
    }
    return '';
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;

      final state = widget.state;
      if (state is PrayerTimesLoaded) {
        if (state.prayers.isEmpty) return;

        final now = DateTime.now();
        final nextPrayer =
            state.prayers.where((p) => p.isNext).firstOrNull ??
            state.prayers.first;

        if (nextPrayer.time.difference(now).isNegative) {
          final appDate = context.read<AppDateCubit>().state.date;
          if (appDate != null) {
            context.read<PrayerTimesCubit>().refresh(appDate: appDate);
          }
        }

        _durationNotifier.value = PrayerCountdownCalculator.calculateCountdown(
          state.prayers,
        );
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
    final state = widget.state;
    if (state is PrayerTimesLoaded) {
      if (state.prayers.isEmpty) {
        return const SizedBox.shrink();
      }

      return RepaintBoundary(
        child: Container(
          decoration: featureCardDecoration(
            context: context,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(AppSpacing.radiusS),
              bottomRight: Radius.circular(AppSpacing.radiusS),
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Padding(
                  padding: EdgeInsets.only(
                    top: kIsWeb ? AppSpacing.v16 : 0,
                    left: AppSpacing.v12,
                    right: AppSpacing.v12,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      HijriAndGregorianDateWidget(),
                      CityCountryWidget(),
                    ],
                  ),
                ),
                const AppGap.h(AppSpacing.v4),
                HomePrayerCarousel(
                  state: state,
                  durationListenable: _durationNotifier,
                ),
                const AppGap.h(AppSpacing.v4),
                PrayersTimeSection(state: state),
                const AppGap.h(AppSpacing.v8),
              ],
            ),
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }
}

import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sana/core/constants/constants.dart';
import 'package:sana/core/utils/utils.dart';
import 'package:sana/core/services/location_manager/presentation/cubit/location_permission/location_cubit.dart';
import 'package:sana/core/services/location_manager/presentation/cubit/location_permission/location_state.dart';
import 'package:sana/core/theme/app_spacing.dart';
import 'package:sana/features/app_date/presentation/cubit/app_date_cubit.dart';
import 'package:sana/features/app_date/presentation/cubit/app_date_state.dart';
import 'package:sana/features/home/presentation/widgets/skeleton/skeletonizer_home_prayer.dart';
import 'package:sana/features/prayer/presentation/cubit/prayer_times_cubit.dart';
import 'package:sana/features/prayer/presentation/cubit/prayer_times_state.dart';
import 'package:sana/features/prayer/presentation/widgets/header/home_prayer_loaded.dart';
import 'package:sana/features/salat_ala_nabi/presentation/widgets/toggle_title_and_switch_widget.dart';

class HomePrayerSection extends StatefulWidget {
  const HomePrayerSection({super.key});

  @override
  State<HomePrayerSection> createState() => _HomePrayerSectionState();
}

class _HomePrayerSectionState extends State<HomePrayerSection> {
  @override
  void initState() {
    super.initState();
    unawaited(
      context.read<PrayerTimesCubit>().init().then((_) {
        if (mounted) {
          _refreshPrayers();
        }
      }),
    );
  }

  void _refreshPrayers() {
    final appDate = context.read<AppDateCubit>().state.date;
    if (appDate != null) {
      context.read<PrayerTimesCubit>().refresh(appDate: appDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AppDateCubit, AppDateState>(
          listener: (context, state) {
            _refreshPrayers();
          },
        ),
        BlocListener<LocationCubit, LocationState>(
          listener: (context, state) {
            if (state is LocationSuccess) {
              _refreshPrayers();
            }
          },
        ),
      ],
      child: BlocBuilder<LocationCubit, LocationState>(
        builder: (context, locationState) {
          if (locationState is LocationSkipped) {
            return Stack(
              children: [
                const SkeletonizerHomePrayer(),
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(AppSpacing.radiusS),
                      bottomRight: Radius.circular(AppSpacing.radiusS),
                    ),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                      child: ColoredBox(
                        color: context.color.scaffoldBackgroundColor.withValues(
                          alpha: 0.4,
                        ),
                        child: Center(
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.v24,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.v16,
                              vertical: AppSpacing.v4,
                            ),
                            decoration: BoxDecoration(
                              color: context.color.scaffoldBackgroundColor,
                              borderRadius: BorderRadius.circular(
                                AppSpacing.radiusS,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: context.color.textPrimary.withValues(alpha: 0.05),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ToggleTitleAndSwitchWidget(
                              title: AppStrings.activateLocation,
                              value: false,
                              onChanged: ({required value}) {
                                context.read<LocationCubit>().requestChoice();
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }

          return BlocBuilder<PrayerTimesCubit, PrayerTimesState>(
            builder: (context, state) {
              if (state is PrayerTimesLoaded) {
                return HomePrayerLoaded(state: state);
              } else if (state is PrayerTimesError) {
                return const SizedBox.shrink();
              }
              return const SkeletonizerHomePrayer();
            },
          );
        },
      ),
    );
  }
}

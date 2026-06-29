import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/constants/constants.dart';
import 'package:sana/core/services/location_manager/presentation/cubit/location_permission/location_cubit.dart';
import 'package:sana/features/prayer/presentation/widgets/prayer_settings/settings_tile_widget.dart';

class PrayerLocationWidget extends StatelessWidget {
  const PrayerLocationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<LocationCubit>();
    final selectedCountryName = cubit.getStoredLocationName();

    return SettingsTileWidget(
      title: selectedCountryName ?? AppStrings.autoLocation,
      onTap: () {
        context.read<LocationCubit>().requestChoice();
      },
    );
  }
}

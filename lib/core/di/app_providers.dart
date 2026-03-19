import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/di/service_locator.dart';
import 'package:sana/features/app_date/presentation/controller/app_date_cubit.dart';
import 'package:sana/features/app_update/presentation/controller/app_update_cubit.dart';
import 'package:sana/features/location_manager/presentation/controller/location_permission/location_cubit.dart';
import 'package:sana/features/prayer/presentation/controller/prayer_times_cubit.dart';

class AppProviders extends StatelessWidget {
  const AppProviders({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<LocationCubit>()),
        BlocProvider(create: (_) => sl<AppDateCubit>()),
        BlocProvider(create: (_) => sl<PrayerTimesCubit>()),
        BlocProvider(create: (_) => sl<AppUpdateCubit>()),
      ],
      child: child,
    );
  }
}

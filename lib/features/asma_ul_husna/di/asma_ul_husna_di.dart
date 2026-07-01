import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';

import 'package:sana/features/asma_ul_husna/data/datasources/asma_ul_husna_local_data_source.dart';
import 'package:sana/features/asma_ul_husna/data/repos/asma_ul_husna_repository.dart';
import 'package:sana/features/asma_ul_husna/presentation/cubit/asma_ul_husna_cubit.dart';
import 'package:sana/features/asma_ul_husna/presentation/cubit/daily_asma_ul_husna_cubit.dart';
import 'package:sana/features/app_date/presentation/cubit/app_date_cubit.dart';

void setupAsmaUlHusnaDependencies(GetIt sl) {
  sl
    ..registerLazySingleton<IAsmaUlHusnaLocalDataSource>(
      () => AsmaUlHusnaLocalDataSource(rootBundle),
    )
    ..registerLazySingleton<IAsmaUlHusnaRepository>(
      () => AsmaUlHusnaRepoImpl(sl<IAsmaUlHusnaLocalDataSource>()),
    )
    ..registerLazySingleton<AsmaUlHusnaCubit>(
      () => AsmaUlHusnaCubit(
        sl<IAsmaUlHusnaRepository>(),
      ),
    )
    ..registerFactory<DailyAsmaUlHusnaCubit>(
      () => DailyAsmaUlHusnaCubit(
        sl<IAsmaUlHusnaRepository>(),
        sl<AppDateCubit>(),
      ),
    );
}

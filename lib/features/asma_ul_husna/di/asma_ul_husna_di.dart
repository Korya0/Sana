import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';

import 'package:sana/features/asma_ul_husna/data/data_sources/asma_ul_husna_local_data_source.dart';
import 'package:sana/features/asma_ul_husna/data/repos/asma_ul_husna_repository.dart';
import 'package:sana/features/asma_ul_husna/presentation/cubits/asma_ul_husna_cubit.dart';
import 'package:sana/features/asma_ul_husna/presentation/cubits/daily_asma_ul_husna_cubit.dart';
import 'package:sana/features/app_date/presentation/cubits/app_date_cubit.dart';

void setupAsmaUlHusnaDependencies(GetIt sl) {
  sl
    ..registerLazySingleton<AsmaUlHusnaLocalDataSource>(
      () => AsmaUlHusnaLocalDataSourceImpl(rootBundle),
    )
    ..registerLazySingleton<AsmaUlHusnaRepository>(
      () => AsmaUlHusnaRepoImpl(sl<AsmaUlHusnaLocalDataSource>()),
    )
    ..registerFactory<AsmaUlHusnaCubit>(
      () => AsmaUlHusnaCubit(
        sl<AsmaUlHusnaRepository>(),
      ),
    )
    ..registerFactory<DailyAsmaUlHusnaCubit>(
      () => DailyAsmaUlHusnaCubit(
        sl<AsmaUlHusnaRepository>(),
        sl<AppDateCubit>(),
      ),
    );
}

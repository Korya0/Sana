import 'package:get_it/get_it.dart';
import 'package:sana/features/home/data/datasources/features_local_data_source.dart';
import 'package:sana/features/home/data/datasources/i_features_local_data_source.dart';
import 'package:sana/features/home/data/repos/features_repository.dart';
import 'package:sana/features/home/presentation/cubit/features_list_cubit.dart';

void setupHomeDependencies(GetIt sl) {
  sl
    ..registerLazySingleton<IFeaturesLocalDataSource>(
      FeaturesLocalDataSource.new,
    )
    ..registerLazySingleton<IFeaturesRepository>(() => FeaturesRepoImpl(sl()))
    ..registerLazySingleton<FeaturesListCubit>(() => FeaturesListCubit(sl()));
}

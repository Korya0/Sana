import 'package:get_it/get_it.dart';
import 'package:sana/features/home/data/datasources/features_local_data_source.dart';
import 'package:sana/features/home/data/repositories/features_repository.dart';
import 'package:sana/features/home/presentation/controller/features_list_cubit.dart';

void setupHomeDependencies(GetIt sl) {
  sl
    // 1) DataSources
    ..registerLazySingleton<FeaturesLocalDataSource>(
      FeaturesLocalDataSource.new,
    )
    // 2) Repositories
    ..registerLazySingleton<IFeaturesRepository>(
      () => FeaturesRepository(sl<FeaturesLocalDataSource>()),
    )
    // 3) Cubits
    ..registerFactory<FeaturesListCubit>(
      () => FeaturesListCubit(sl<IFeaturesRepository>()),
    );
}

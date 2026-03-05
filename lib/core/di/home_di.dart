import 'package:get_it/get_it.dart';
import 'package:sana/features/home/data/datasources/features_local_data_source.dart';
import 'package:sana/features/home/data/repositories/features_repository.dart';
import 'package:sana/features/home/presentation/controller/features_list_cubit.dart';

void setupHomeDependencies(GetIt sl) {
  // DataSources
  sl.registerLazySingleton<FeaturesLocalDataSource>(
    FeaturesLocalDataSource.new,
  );

  // Repositories
  sl.registerLazySingleton<IFeaturesRepository>(
    () => FeaturesRepository(sl<FeaturesLocalDataSource>()),
  );

  // Cubits
  sl.registerFactory<FeaturesListCubit>(
    () => FeaturesListCubit(sl<IFeaturesRepository>()),
  );
}

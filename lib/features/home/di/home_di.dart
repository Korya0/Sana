import 'package:get_it/get_it.dart';
import 'package:sana/features/home/data/datasources/features_local_data_source.dart';
import 'package:sana/features/home/data/repos/features_repository.dart';
import 'package:sana/features/home/presentation/cubit/features_list_cubit.dart';

class HomeDependencyInjection {
  static void init(GetIt sl) {
    // Data Source
    sl
      ..registerLazySingleton<FeaturesLocalDataSource>(
        FeaturesLocalDataSource.new,
      )
      // Repository
      ..registerLazySingleton<IFeaturesRepository>(() => FeaturesRepoImpl(sl()))
      // Cubit
      ..registerFactory<FeaturesListCubit>(() => FeaturesListCubit(sl()));
  }
}

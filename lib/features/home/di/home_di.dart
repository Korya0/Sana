import 'package:get_it/get_it.dart';
import 'package:sana/features/home/data/data_sources/features_local_data_source.dart';
import 'package:sana/features/home/data/data_sources/features_local_data_source_impl.dart';
import 'package:sana/features/home/data/repos/features_repository.dart';
import 'package:sana/features/home/presentation/cubits/features_list_cubit.dart';

void setupHomeDependencies(GetIt sl) {
  sl
    ..registerLazySingleton<FeaturesLocalDataSource>(
      FeaturesLocalDataSourceImpl.new,
    )
    ..registerLazySingleton<FeaturesRepository>(() => FeaturesRepoImpl(sl()))
    ..registerLazySingleton<FeaturesListCubit>(() => FeaturesListCubit(sl()));
}

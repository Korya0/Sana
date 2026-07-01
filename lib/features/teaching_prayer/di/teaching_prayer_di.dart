import 'package:get_it/get_it.dart';
import 'package:sana/core/services/assets/asset_loader.dart';
import 'package:sana/features/teaching_prayer/data/datasources/teaching_prayer_local_data_source.dart';
import 'package:sana/features/teaching_prayer/data/repos/teaching_prayer_repo_impl.dart';
import 'package:sana/features/teaching_prayer/domain/repos/i_teaching_prayer_repository.dart';
import 'package:sana/features/teaching_prayer/presentation/cubit/teaching_prayer_cubit.dart';

void setupTeachingPrayerDependencies(GetIt sl) {
  sl
    ..registerLazySingleton<ITeachingPrayerLocalDataSource>(
      () => TeachingPrayerLocalDataSource(sl<IAssetLoader>()),
    )
    ..registerLazySingleton<ITeachingPrayerRepository>(
      () => TeachingPrayerRepoImpl(sl<ITeachingPrayerLocalDataSource>()),
    )
    ..registerFactory<TeachingPrayerCubit>(
      () => TeachingPrayerCubit(sl<ITeachingPrayerRepository>()),
    );
}

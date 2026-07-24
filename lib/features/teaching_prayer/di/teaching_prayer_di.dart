import 'package:get_it/get_it.dart';
import 'package:sana/core/services/assets/asset_loader.dart';
import 'package:sana/features/teaching_prayer/data/data_sources/teaching_prayer_local_data_source.dart';
import 'package:sana/features/teaching_prayer/data/repos/teaching_prayer_repo_impl.dart';
import 'package:sana/features/teaching_prayer/domain/repos/teaching_prayer_repository.dart';
import 'package:sana/features/teaching_prayer/presentation/cubits/teaching_prayer_cubit.dart';

void setupTeachingPrayerDependencies(GetIt sl) {
  sl
    ..registerLazySingleton<TeachingPrayerLocalDataSource>(
      () => TeachingPrayerLocalDataSourceImpl(sl<AssetLoader>()),
    )
    ..registerLazySingleton<TeachingPrayerRepository>(
      () => TeachingPrayerRepoImpl(sl<TeachingPrayerLocalDataSource>()),
    )
    ..registerFactory<TeachingPrayerCubit>(
      () => TeachingPrayerCubit(sl<TeachingPrayerRepository>()),
    );
}

import 'package:get_it/get_it.dart';
import 'package:sana/features/teaching_prayer/data/datasources/teaching_prayer_local_data_source.dart';
import 'package:sana/features/teaching_prayer/data/repos/teaching_prayer_repository.dart';
import 'package:sana/features/teaching_prayer/presentation/cubit/teaching_prayer_cubit.dart';

class TeachingPrayerDependencyInjection {
  static void init(GetIt sl) {
    sl
      ..registerLazySingleton<TeachingPrayerLocalDataSource>(
        TeachingPrayerLocalDataSource.new,
      )
      ..registerLazySingleton<ITeachingPrayerRepository>(
        () => TeachingPrayerRepoImpl(sl<TeachingPrayerLocalDataSource>()),
      )
      ..registerFactory<TeachingPrayerCubit>(
        () => TeachingPrayerCubit(repository: sl<ITeachingPrayerRepository>()),
      );
  }
}

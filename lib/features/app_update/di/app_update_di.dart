import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:get_it/get_it.dart';
import 'package:sana/features/app_update/data/repositories/app_update_repository.dart';
import 'package:sana/features/app_update/data/services/app_update_service.dart';
import 'package:sana/features/app_update/presentation/controller/app_update_cubit.dart';

class AppUpdateDependencyInjection {
  static void init(GetIt sl) {
    sl
      ..registerLazySingleton<AppUpdateService>(
        () => AppUpdateServiceImpl(sl<FirebaseRemoteConfig>(), sl()),
      )
      ..registerLazySingleton<IAppUpdateRepository>(
        () => AppUpdateRepository(sl<AppUpdateService>()),
      )
      ..registerLazySingleton<AppUpdateCubit>(
        () => AppUpdateCubit(sl<IAppUpdateRepository>()),
      );
  }
}

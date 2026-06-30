import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:get_it/get_it.dart';
import 'package:sana/core/services/app_date/data/repositories/app_date_repository.dart';
import 'package:sana/core/services/app_date/domain/repositories/i_app_date_repository.dart';
import 'package:sana/core/services/app_date/presentation/cubit/app_date_cubit.dart';
import 'package:sana/core/services/app_update/data/repositories/app_update_repository.dart';
import 'package:sana/core/services/app_update/data/services/app_update_service.dart';
import 'package:sana/core/services/app_update/presentation/cubit/app_update_cubit.dart';
import 'package:sana/core/services/background/i_work_manager_service.dart';
import 'package:sana/core/services/background/work_manager_service_impl.dart';
import 'package:sana/core/services/device_info/device_info_service.dart';
import 'package:sana/core/services/local_storage/i_local_storage_service.dart';
import 'package:sana/core/services/location_manager/data/datasources/local/geolocator_wrapper.dart';
import 'package:sana/core/services/location_manager/data/datasources/local/location_local_data_source.dart';
import 'package:sana/core/services/location_manager/data/datasources/remote/location_remote_data_source.dart';
import 'package:sana/core/services/location_manager/data/repos/i_location_repository.dart';
import 'package:sana/core/services/location_manager/data/repos/location_repo_impl.dart';
import 'package:sana/core/services/location_manager/presentation/cubit/location_name/location_name_cubit.dart';
import 'package:sana/core/services/location_manager/presentation/cubit/location_permission/location_cubit.dart';
import 'package:sana/core/services/notification/i_notification_service.dart';
import 'package:sana/core/services/notification/notification_service_impl.dart';
import 'package:sana/core/services/permissions/app_permissions_manager.dart';
import 'package:sana/core/services/sharing/logic/i_share_service.dart';
import 'package:sana/core/services/sharing/logic/share_service.dart';
import 'package:sana/core/services/time/data/services/midnight_timer_service.dart';
import 'package:sana/core/services/time/domain/services/i_midnight_timer_service.dart';
import 'package:sana/core/theme/cubit/theme_cubit.dart';

void setupServicesDependencies(GetIt sl) {
  sl
    ..registerLazySingleton<IDeviceInfoService>(DeviceInfoServiceImpl.new)
    ..registerLazySingleton<IGeolocatorWrapper>(GeolocatorWrapperImpl.new)
    ..registerLazySingleton<IAppPermissionsManager>(
      AppPermissionsManagerImpl.new,
    )
    ..registerLazySingleton<INotificationService>(NotificationServiceImpl.new)
    ..registerLazySingleton<IWorkManagerService>(WorkManagerServiceImpl.new)
    ..registerLazySingleton<IAppUpdateService>(
      () => AppUpdateServiceImpl(sl<FirebaseRemoteConfig>(), sl()),
    )
    ..registerLazySingleton<IAppUpdateRepository>(
      () => AppUpdateRepoImpl(sl<IAppUpdateService>()),
    )
    ..registerLazySingleton<AppUpdateCubit>(
      () => AppUpdateCubit(sl<IAppUpdateRepository>()),
    )
    ..registerLazySingleton<ThemeCubit>(
      () => ThemeCubit(sl<ILocalStorageService>()),
    )
    ..registerLazySingleton<ILocationLocalDataSource>(
      () => LocationLocalDataSource(
        sl<IAppPermissionsManager>(),
        sl<IGeolocatorWrapper>(),
      ),
    )
    ..registerLazySingleton<ILocationRemoteDataSource>(
      () => LocationRemoteDataSource(sl()),
    )
    ..registerLazySingleton<ILocationRepository>(
      () => LocationRepoImpl(
        localDataSource: sl<ILocationLocalDataSource>(),
        remoteDataSource: sl<ILocationRemoteDataSource>(),
        sharedPref: sl<ILocalStorageService>(),
      ),
    )
    ..registerFactory<LocationNameCubit>(
      () => LocationNameCubit(
        repository: sl<ILocationRepository>(),
        prefs: sl<ILocalStorageService>(),
        locationCubit: sl<LocationCubit>(),
      ),
    )
    ..registerLazySingleton<LocationCubit>(
      () => LocationCubit(repository: sl<ILocationRepository>()),
    )
    ..registerLazySingleton<IAppDateRepository>(
      () => AppDateRepositoryImpl(sl<ILocalStorageService>()),
    )
    ..registerLazySingleton<IMidnightTimerService>(
      () => MidnightTimerServiceImpl()..start(),
    )
    ..registerFactory<AppDateCubit>(
      () => AppDateCubit(
        sl<IAppDateRepository>(),
        sl<IMidnightTimerService>(),
      ),
    )
    ..registerLazySingleton<IShareService>(ShareServiceImpl.new);
}

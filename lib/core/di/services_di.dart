import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:get_it/get_it.dart';
import 'package:sana/features/app_update/data/repositories/app_update_repository.dart';
import 'package:sana/features/app_update/data/datasources/app_update_data_source.dart';
import 'package:sana/features/app_update/presentation/cubit/app_update_cubit.dart';
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
import 'package:sana/core/services/haptic/haptic_service_impl.dart';
import 'package:sana/core/services/haptic/i_haptic_service.dart';
import 'package:sana/core/services/sharing/logic/i_share_service.dart';
import 'package:sana/core/services/sharing/logic/share_service.dart';
import 'package:sana/core/services/sharing/presentation/utils/widget_to_image_helper.dart';
import 'package:sana/core/services/time/midnight_timer_service.dart';
import 'package:sana/core/theme/cubit/theme_cubit.dart';
import 'package:screenshot/screenshot.dart';

import 'package:sana/core/services/assets/asset_loader.dart';

void setupServicesDependencies(GetIt sl) {
  sl
    ..registerLazySingleton<IAssetLoader>(AssetLoaderImpl.new)
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
      () => AppUpdateCubit(sl<IAppUpdateRepository>())..initialize(),
    )
    ..registerLazySingleton<ThemeCubit>(
      () => ThemeCubit(sl<ILocalStorageService>()),
    )
    ..registerLazySingleton<ILocationLocalDataSource>(
      () => LocationLocalDataSource(
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
      () => LocationCubit(
        repository: sl<ILocationRepository>(),
        permissionsManager: sl<IAppPermissionsManager>(),
      ),
    )
    ..registerLazySingleton<IMidnightTimerService>(
      () => MidnightTimerServiceImpl()..start(),
    )
    ..registerLazySingleton<SharePlusWrapper>(SharePlusWrapper.new)
    ..registerLazySingleton<IShareService>(
      () => ShareServiceImpl(sl<SharePlusWrapper>()),
    )
    ..registerLazySingleton<ScreenshotController>(ScreenshotController.new)
    ..registerLazySingleton<WidgetToImageHelper>(
      () => WidgetToImageHelper(
        screenshotController: sl<ScreenshotController>(),
      ),
    )
    ..registerLazySingleton<IHapticService>(HapticServiceImpl.new);
}

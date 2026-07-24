import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:get_it/get_it.dart';
import 'package:sana/features/app_update/data/repositories/app_update_repository.dart';
import 'package:sana/features/app_update/data/data_sources/app_update_data_source.dart';
import 'package:sana/features/app_update/presentation/cubits/app_update_cubit.dart';
import 'package:sana/core/services/background_tasks/work_manager_service.dart';
import 'package:sana/core/services/background_tasks/work_manager_service_impl.dart';
import 'package:sana/core/services/device_info/device_info_service.dart';
import 'package:sana/core/services/local_storage/local_storage_service.dart';
import 'package:sana/features/location_manager/data/data_sources/local/geolocator_wrapper.dart';
import 'package:sana/features/location_manager/data/data_sources/local/location_local_data_source.dart';
import 'package:sana/features/location_manager/data/data_sources/remote/location_remote_data_source.dart';
import 'package:sana/features/location_manager/data/repos/location_repository.dart';
import 'package:sana/features/location_manager/data/repos/location_repo_impl.dart';
import 'package:sana/features/location_manager/presentation/cubits/location_name/location_name_cubit.dart';
import 'package:sana/features/location_manager/presentation/cubits/location_permission/location_cubit.dart';
import 'package:sana/features/location_manager/presentation/cubits/location_permission/location_permission_cubit.dart';
import 'package:sana/features/location_manager/presentation/cubits/location_position/location_position_cubit.dart';
import 'package:sana/core/services/notification/notification_service.dart';
import 'package:sana/core/services/notification/notification_service_impl.dart';
import 'package:sana/core/services/notification/notification_scheduler.dart';
import 'package:sana/core/services/notification/notification_scheduler_impl.dart';
import 'package:sana/core/services/permissions/app_permissions_manager.dart';
import 'package:sana/core/services/haptic/haptic_service_impl.dart';
import 'package:sana/core/services/haptic/haptic_service.dart';
import 'package:sana/core/services/sharing/logic/share_service.dart';
import 'package:sana/core/services/sharing/logic/share_service_impl.dart';
import 'package:sana/core/services/url_launcher/launch_url_service.dart';
import 'package:sana/core/services/url_launcher/launch_url_service_impl.dart';
import 'package:sana/features/sharing/presentation/helpers/widget_to_image_helper.dart';
import 'package:sana/core/services/timer/midnight_timer_service.dart';
import 'package:sana/core/cubits/app_cubit.dart';
import 'package:screenshot/screenshot.dart';

import 'package:sana/core/services/assets/asset_loader.dart';

void setupServicesDependencies(GetIt sl) {
  sl
    ..registerLazySingleton<AssetLoader>(AssetLoaderImpl.new)
    ..registerLazySingleton<DeviceInfoService>(DeviceInfoServiceImpl.new)
    ..registerLazySingleton<GeolocatorWrapper>(GeolocatorWrapperImpl.new)
    ..registerLazySingleton<AppPermissionsManager>(
      AppPermissionsManagerImpl.new,
    )
    ..registerLazySingleton<NotificationService>(NotificationServiceImpl.new)
    ..registerLazySingleton<NotificationScheduler>(
      () => NotificationSchedulerImpl(sl<NotificationService>()),
    )
    ..registerLazySingleton<WorkManagerService>(WorkManagerServiceImpl.new)
    ..registerLazySingleton<AppUpdateService>(
      () => AppUpdateServiceImpl(sl<FirebaseRemoteConfig>(), sl()),
    )
    ..registerLazySingleton<AppUpdateRepository>(
      () => AppUpdateRepoImpl(sl<AppUpdateService>()),
    )
    ..registerLazySingleton<AppUpdateCubit>(
      () => AppUpdateCubit(sl<AppUpdateRepository>())..initialize(),
    )
    ..registerLazySingleton<AppCubit>(
      () => AppCubit(sl<LocalStorageService>()),
    )
    ..registerLazySingleton<LocationLocalDataSource>(
      () => LocationLocalDataSourceImpl(
        sl<GeolocatorWrapper>(),
      ),
    )
    ..registerLazySingleton<LocationRemoteDataSource>(
      () => LocationRemoteDataSourceImpl(sl()),
    )
    ..registerLazySingleton<LocationRepository>(
      () => LocationRepoImpl(
        localDataSource: sl<LocationLocalDataSource>(),
        remoteDataSource: sl<LocationRemoteDataSource>(),
        sharedPref: sl<LocalStorageService>(),
      ),
    )
    ..registerLazySingleton<LocationPositionCubit>(
      () => LocationPositionCubit(
        repository: sl<LocationRepository>(),
      ),
    )
    ..registerLazySingleton<LocationPermissionCubit>(
      () => LocationPermissionCubit(
        repository: sl<LocationRepository>(),
        permissionsManager: sl<AppPermissionsManager>(),
        onPositionGranted: () => sl<LocationPositionCubit>().saveCurrentPosition(),
      ),
    )
    ..registerFactory<LocationNameCubit>(
      () => LocationNameCubit(
        repository: sl<LocationRepository>(),
        prefs: sl<LocalStorageService>(),
      ),
    )
    ..registerLazySingleton<LocationCubit>(
      () => LocationCubit(
        repository: sl<LocationRepository>(),
        permissionsManager: sl<AppPermissionsManager>(),
      ),
    )
    ..registerLazySingleton<MidnightTimerService>(
      () => MidnightTimerServiceImpl()..start(),
    )
    ..registerLazySingleton<SharePlusWrapper>(SharePlusWrapper.new)
    ..registerLazySingleton<ShareService>(
      () => ShareServiceImpl(sl<SharePlusWrapper>()),
    )
    ..registerLazySingleton<ScreenshotController>(ScreenshotController.new)
    ..registerLazySingleton<WidgetToImageHelper>(
      () => WidgetToImageHelper(
        screenshotController: sl<ScreenshotController>(),
      ),
    )
    ..registerLazySingleton<HapticService>(HapticServiceImpl.new)
    ..registerLazySingleton<LaunchUrlService>(LaunchUrlServiceImpl.new);
}

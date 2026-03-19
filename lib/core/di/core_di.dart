import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:get_it/get_it.dart';
import 'package:sana/core/networking/api_clients/dorar_api_client.dart';
import 'package:sana/core/networking/api_clients/location_api_client.dart';
import 'package:sana/core/networking/dio_factory.dart';
import 'package:sana/core/services/analytics/analytics_service.dart';
import 'package:sana/core/services/analytics/firebase_analytics_service.dart';
import 'package:sana/core/services/device_info/device_info_service.dart';
import 'package:sana/core/services/local_storage/local_storage_service.dart';
import 'package:sana/core/services/permissions/app_permissions_manager.dart';
import 'package:sana/features/app_date/data/repositories/app_date_repository.dart';
import 'package:sana/features/app_date/presentation/controller/app_date_cubit.dart';
import 'package:sana/features/app_update/di/app_update_di.dart';
import 'package:sana/features/sharing/logic/share_service.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> setupCoreDependencies(GetIt sl) async {
  await Hive.initFlutter();
  final settingsBox = await Hive.openBox<dynamic>('app_settings');
  final localStorageService = LocalStorageService(settingsBox);

  sl
    ..registerLazySingleton<Box<dynamic>>(() => settingsBox)
    ..registerLazySingleton<ILocalStorageService>(() => localStorageService)
    // Firebase
    ..registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance)
    ..registerLazySingleton<FirebaseRemoteConfig>(
      () => FirebaseRemoteConfig.instance,
    )
    ..registerLazySingleton<IAnalyticsService>(
      () => FirebaseAnalyticsServiceImpl(FirebaseAnalytics.instance),
    )
    ..registerLazySingleton<IDeviceInfoService>(DeviceInfoServiceImpl.new)
    ..registerLazySingleton<IAppPermissionsManager>(AppPermissionsManagerImpl.new)
    // Networking
    ..registerLazySingleton<Dio>(DioFactory.getDio)
    ..registerLazySingleton<LocationApiClient>(
      () => LocationApiClient(
        sl<Dio>(),
        baseUrl: 'https://nominatim.openstreetmap.org',
      ),
    )
    ..registerLazySingleton<DorarApiClient>(
      () => DorarApiClient(
        sl<Dio>(),
        baseUrl: 'https://dorar.net',
      ),
    )
    ..registerLazySingleton<IAppDateRepository>(
      () => AppDateRepositoryImpl(sl<ILocalStorageService>()),
    )
    ..registerLazySingleton<AppDateCubit>(
      () => AppDateCubit(sl<IAppDateRepository>()),
    )
    ..registerLazySingleton<ShareService>(ShareServiceImpl.new);

  // Feature specific DI
  AppUpdateDependencyInjection.init(sl);
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:get_it/get_it.dart';
import 'package:sana/core/networking/api_service.dart';
import 'package:sana/core/networking/dio_factory.dart';
import 'package:sana/core/services/sharedpref/shared_pref.dart';
import 'package:sana/core/sharing/logic/share_service.dart';
import 'package:sana/features/app_date/presentation/controller/app_date_cubit.dart';
import 'package:sana/features/app_update/data/repositories/app_update_repository.dart';
import 'package:sana/features/app_update/data/services/app_update_service.dart';
import 'package:sana/features/app_update/presentation/controller/app_update_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> setupCoreDependencies(GetIt sl) async {
  final sharedPreferences = await SharedPreferences.getInstance();
  final sharedPref = SharedPref(sharedPreferences);

  sl
    ..registerLazySingleton<SharedPreferences>(() => sharedPreferences)
    ..registerLazySingleton<ISharedPref>(() => sharedPref)
    // Firebase
    ..registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance)
    ..registerLazySingleton<FirebaseRemoteConfig>(
      () => FirebaseRemoteConfig.instance,
    )
    // Networking
    ..registerLazySingleton<Dio>(DioFactory.getDio)
    ..registerLazySingleton<ApiService>(() => ApiServiceImpl(sl()))
    ..registerSingleton<AppDateCubit>(
      AppDateCubit(sl<SharedPref>()),
    )
    ..registerLazySingleton<ShareService>(ShareServiceImpl.new)
    // Force Update
    ..registerLazySingleton<AppUpdateService>(
      () => AppUpdateServiceImpl(sl<FirebaseRemoteConfig>(), sl()),
    )
    ..registerLazySingleton<IAppUpdateRepository>(
      () => AppUpdateRepository(sl<AppUpdateService>()),
    )
    ..registerFactory<AppUpdateCubit>(
      () => AppUpdateCubit(sl<IAppUpdateRepository>()),
    );
}

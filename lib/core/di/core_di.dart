import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:sana/core/services/date_gregorian_and_hijri/cubit/app_date_cubit.dart';
import 'package:sana/core/services/share_service.dart';
import 'package:sana/core/services/sharedpref/shared_pref.dart';
import 'package:sana/features/app_update/data/services/app_update_service.dart';
import 'package:sana/features/app_update/presentation/controller/app_update_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> setupCoreDependencies(GetIt sl) async {
  final sharedPref = SharedPref();
  await sharedPref.instantiatePreferences();
  sl.registerLazySingleton<SharedPref>(() => sharedPref);

  // Register SharedPreferences instance for direct access
  sl.registerLazySingleton<SharedPreferences>(sharedPref.getPreferenceInstance);

  sl.registerLazySingleton<Dio>(() {
    final dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        // [Web Support] تعطيل sendTimeout في الويب لأنه يسبب تحذيرات في الكونسول وطلبات الـ GET
        sendTimeout: kIsWeb ? null : const Duration(seconds: 10),
      ),
    );

    // Add logging in debug mode
    assert(() {
      dio.interceptors.add(
        LogInterceptor(requestBody: true, responseBody: true),
      );
      return true;
    }());

    return dio;
  });
  sl.registerSingleton<AppDateCubit>(AppDateCubit());
  sl.registerLazySingleton<ShareService>(ShareServiceImpl.new);

  // Force Update
  sl.registerLazySingleton<AppUpdateService>(
    () => AppUpdateServiceImpl(sl(), sl()),
  );
  sl.registerFactory<AppUpdateCubit>(() => AppUpdateCubit(sl()));
}

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:sana/core/logic/force_update_cubit/force_update_cubit.dart';
import 'package:sana/core/services/date_gregorian_and_hijri/cubit/app_date_cubit.dart';
import 'package:sana/core/services/force_update_service.dart';
import 'package:sana/core/services/share_service.dart';
import 'package:sana/core/services/sharedpref/shared_pref.dart';
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
        sendTimeout: const Duration(seconds: 10),
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
  sl.registerLazySingleton<ForceUpdateService>(
    () => ForceUpdateServiceImpl(sl(), sl()),
  );
  sl.registerFactory<ForceUpdateCubit>(() => ForceUpdateCubit(sl()));
}

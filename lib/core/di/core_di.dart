import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:sana/core/networking/api_service.dart';
import 'package:sana/core/networking/dio_factory.dart';
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

  // Networking
  sl.registerLazySingleton<Dio>(() => DioFactory.getDio());
  sl.registerLazySingleton<ApiService>(() => ApiServiceImpl(sl()));

  sl.registerSingleton<AppDateCubit>(AppDateCubit());
  sl.registerLazySingleton<ShareService>(ShareServiceImpl.new);

  // Force Update
  sl.registerLazySingleton<AppUpdateService>(
    () => AppUpdateServiceImpl(sl(), sl()),
  );
  sl.registerFactory<AppUpdateCubit>(() => AppUpdateCubit(sl()));
}

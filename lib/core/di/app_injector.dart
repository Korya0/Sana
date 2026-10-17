import 'package:get_it/get_it.dart';
import 'package:sana/core/app_cubit/theme/theme_cubit.dart';
import 'package:sana/core/services/local_storage/app_local_storage.dart';
import 'package:sana/core/utils/app_logger.dart';

final GetIt sl = GetIt.instance;

Future<void> setupCoreDependencies(GetIt sl) async {
  final localStorage = await AppLocalStorage.open();

  // Logging
  sl.registerLazySingleton<AppLogger>(() => const AppLogger());

  // Storage
  sl.registerSingleton<AppLocalStorage>(localStorage);

  // Cubits
  sl.registerLazySingleton<ThemeCubit>(
    () => ThemeCubit(sl<AppLocalStorage>())..loadSavedTheme(),
  );
}

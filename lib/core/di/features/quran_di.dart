import 'package:get_it/get_it.dart';
import 'package:sana/features/quran/domain/use_cases/initialize_quran_use_case.dart';
import 'package:sana/features/quran/presentation/cubits/quran/quran_cubit.dart';

void setupQuranDependencies(GetIt sl) {
  sl
    // Use cases
    ..registerLazySingleton(() => const InitializeQuranUseCase())
    // Cubit
    ..registerFactory(
      () => QuranCubit(initializeQuran: sl()),
    );
}

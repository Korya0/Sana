import 'package:get_it/get_it.dart';
import 'package:sana/features/quran/data/repos/quran_repo.dart';
import 'package:sana/features/quran/presentation/cubit/quran_cubit.dart';

void setupQuranDependencies(GetIt sl) {
  sl
    ..registerLazySingleton<IQuranRepo>(QuranRepoImpl.new)
    ..registerFactory<QuranCubit>(() => QuranCubit(sl<IQuranRepo>()));
}

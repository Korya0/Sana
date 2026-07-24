import 'package:get_it/get_it.dart';
import 'package:sana/features/quran/domain/repos/quran_repo.dart';
import 'package:sana/features/quran/data/repos/quran_repo.dart';
import 'package:sana/features/quran/presentation/cubits/quran_cubit.dart';

void setupQuranDependencies(GetIt sl) {
  sl
    ..registerLazySingleton<QuranRepo>(QuranRepoImpl.new)
    ..registerFactory<QuranCubit>(() => QuranCubit(sl<QuranRepo>()));
}
